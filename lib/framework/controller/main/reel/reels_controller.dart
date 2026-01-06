import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:video_player/video_player.dart';
import 'package:vista_flicks/framework/dependency_injection/inject.dart';
import 'package:vista_flicks/framework/provider/network/api_result.dart';
import 'package:vista_flicks/framework/provider/network/network_exceptions.dart';
import 'package:vista_flicks/framework/repository/bookmark/model/get_bookmark_watched_response.dart';
import 'package:vista_flicks/framework/repository/common_response/streaming_video_response_model.dart';
import 'package:vista_flicks/framework/repository/reels/contract/reels_repository.dart';
import 'package:vista_flicks/framework/repository/reels/model/get_reels_list_response_model.dart';
import 'package:vista_flicks/framework/repository/reels/model/post_report_model.dart';
import 'package:vista_flicks/framework/utils/ui_state.dart';
import 'package:vista_flicks/gen/assets.gen.dart';
import 'package:vista_flicks/ui/utils/helper/user_interaction/user_interaction_manager.dart';
import 'package:vista_flicks/ui/utils/helper/user_interaction/user_interaction_response.dart';
import 'package:vista_flicks/ui/utils/widgets/common_dialogs.dart';

import '../../../utils/local_storage/session.dart';
import 'models/get_comments.dart';

final reelsController =
    ChangeNotifierProvider((ref) => getIt<ReelsController>());

@injectable
class ReelsController extends ChangeNotifier {
  final ReelsRepository reelsRepository;
  final InteractionService interactionService;

  ReelsController(this.reelsRepository)
      : interactionService = InteractionService();

  PageController pageController = PageController();

  final List<String> reportReasons = [
    'Offensive content',
    'Misleading or inaccurate',
    'Sexual or violent content',
    'Spam or irrelevant',
    'Other',
  ];
  String? selectedReason;

  // List<bool> likedVideos = [];
  List<bool> showHeart = [];
  List<bool> savedVideos = [];
  bool showSaveAnimation = false;
  DateTime? _watchStartTime;
  TextEditingController commentController = TextEditingController();
  TextEditingController reportController = TextEditingController();
  int? previousReelIndex;
  int currentReelIndex = 0;
  bool showLikeIcon = true;

  Offset? showHeartOverlayPosition;

  // Add preloading related variables
  static const int PRELOAD_COUNT = 2;
  final Set<int> _preloadedIndices = {};
  bool _isPreloading = false;

  /// Preload reels around the current index
  Future<void> preloadReels(int currentIndex) async {
    if (_isPreloading) return;
    _isPreloading = true;

    try {
      // Calculate range of indices to preload
      int startIndex = math.max(0, currentIndex - PRELOAD_COUNT);
      int endIndex =
          math.min(reelsList.length - 1, currentIndex + PRELOAD_COUNT);

      // Preload next reels
      for (int i = currentIndex + 1; i <= endIndex; i++) {
        if (!_preloadedIndices.contains(i) && i < reelsList.length) {
          await _initializeReelAtIndex(i);
          _preloadedIndices.add(i);
        }
      }

      // Preload previous reels
      for (int i = currentIndex - 1; i >= startIndex; i--) {
        if (!_preloadedIndices.contains(i) && i >= 0) {
          await _initializeReelAtIndex(i);
          _preloadedIndices.add(i);
        }
      }

      // Clean up old preloaded reels that are too far away
      _cleanupOldPreloadedReels(currentIndex);
    } finally {
      _isPreloading = false;
    }
  }

  /// Initialize a single reel at the given index
  Future<void> _initializeReelAtIndex(int index) async {
    if (index < 0 || index >= reelsList.length) return;

    final reel = reelsList[index];
    if (reel.videoPlayerController == null) {
      try {
        final controller = VideoPlayerController.networkUrl(
          Uri.parse(reel.videoUrl ?? ""),
        );
        await controller.initialize();
        reel.videoPlayerController = controller;
      } catch (e) {
        log("Error preloading reel at index $index: $e");
      }
    }
  }

  /// Clean up reels that are too far from the current index
  void _cleanupOldPreloadedReels(int currentIndex) {
    final indicesToRemove = _preloadedIndices.where((index) {
      return (index < currentIndex - PRELOAD_COUNT * 2) ||
          (index > currentIndex + PRELOAD_COUNT * 2);
    }).toList();

    for (final index in indicesToRemove) {
      if (index >= 0 && index < reelsList.length) {
        reelsList[index].videoPlayerController?.dispose();
        reelsList[index].videoPlayerController = null;
      }
      _preloadedIndices.remove(index);
    }
  }

  @override
  void dispose() {
    // Dispose all video controllers
    for (final reel in reelsList) {
      reel.videoPlayerController?.dispose();
    }
    _preloadedIndices.clear();
    super.dispose();
  }

  /// Dispose Controller
  void disposeController({bool isNotify = false}) {
    videoList.clear();
    reelsListState.isLoading = false;
    reelsListState.success = null;
    currentPage = 1;
    reelsList.clear();
    if (isNotify) {
      notifyListeners();
    }
  }

  List<InteractionActionType> interactionActionType = [
    InteractionActionType.views
  ];

  /// Update Widget
  void updateWidget() {
    notifyListeners();
  }

  void startWatchTimer(int index) {
    _watchStartTime = DateTime.now();
    previousReelIndex = index;
    log("_calculateWatchDuration startWatchTimer $index at $_watchStartTime");
  }

  Future<void> sendWatchDuration(int index, BuildContext context) async {
    if (_watchStartTime == null) return;

    int watchedTime = _calculateWatchDuration(); // in seconds
    log("_calculateWatchDuration sendWatchDuration $watchedTime seconds");

    final videoDuration =
        reelsList[index].videoPlayerController?.value.duration;
    if (videoDuration == null) return;

    // Get total video duration in seconds
    int videoDurationSeconds = videoDuration.inSeconds;

    // Calculate watch count
    videoDurationSeconds = videoDurationSeconds > 0 ? videoDurationSeconds : 1;
    int watchCount = (watchedTime / videoDurationSeconds).ceil();
    log("Watch count for reel $index: $watchCount");

    interactionActionType.add(InteractionActionType.watch);
    reelsList[previousReelIndex ?? 0].videoPlayerController?.pause();

    postInteraction(
      context: context,
      duration: watchedTime,
      index: index,
      watchCount: watchCount, // pass it to backend if needed
    );
  }

  int _calculateWatchDuration() {
    if (_watchStartTime == null) return 1;

    final now = DateTime.now();
    final watchedDuration = now.difference(_watchStartTime!).inSeconds;
    _watchStartTime = null; // Reset

    return watchedDuration > 0 ? watchedDuration : 1; // Ensure minimum 1 sec
  }

  List<VideoData> videoList = [];

  Future<void> loadJson() async {
    String jsonString = await rootBundle.loadString(Assets.json.streamingVideo);

    // Decode the JSON string to a Map
    StreamingVideoResponseModel streamingVideoResponseModel =
        streamingVideoResponseModelFromJson(jsonString);
    videoList.addAll(streamingVideoResponseModel.data ?? []);
    notifyListeners();
  }

  ///----------------------------------- API Integration -----------------------------------///

  UIState<GetReelsListResponseModel> reelsListState =
      UIState<GetReelsListResponseModel>();
  List<ReelModel> reelsList = [];
  int currentPage = 1;
  int currentIndex = 0;

  PageStorageKey<int> pageStorageKey = PageStorageKey<int>(0);

  bool hasMoreData = true;
  bool isMute = false;

  Future getReels(BuildContext context,
      {required WidgetRef ref, bool isLoadMore = false}) async {
    if (reelsListState.isLoading) return;
    var token = Session.userAccessToken;

    if (!isLoadMore) {
      reelsListState.isLoading = true;

      reelsListState.success = null;
      currentPage = 1;
      savedVideos.clear();
      reelsList.clear();
      _preloadedIndices.clear();
      pageStorageKey = PageStorageKey<int>(0);
    } else {
      reelsListState.isLoadMore = true;
    }
    notifyListeners();

    ApiResult apiResult = Session.userType.toLowerCase() == "guest"
        ? await reelsRepository.getGuestReels()
        : await reelsRepository
            .getReels(pageNo: currentPage)
            .timeout(const Duration(seconds: 15));

    apiResult.when(
      success: (data) async {
        reelsListState.success = data;
        reelsListState.isLoading = false;
        reelsListState.isLoadMore = false;

        var newReels = reelsListState.success?.data?.results ?? [];
        if (Session.userType.toLowerCase() != "guest" && token.isEmpty) {
          return;
        }
        if (newReels.isEmpty) {
          print("🟡 No data received, retrying after 10 seconds...");
          Future.delayed(const Duration(seconds: 4), () async {
            await getReels(context, ref: ref, isLoadMore: isLoadMore);
          });
          return;
        }
        if (newReels.isNotEmpty) {
          // likedVideos.addAll(List.generate(newReels.length, (index) => false));
          showHeart.addAll(List.generate(newReels.length, (index) => false));
          savedVideos.addAll(List.generate(newReels.length, (index) => false));

          for (var i = 0; i < newReels.length; i++) {
            final controller = VideoPlayerController.networkUrl(
              Uri.parse(newReels[i].videoUrl ?? ""),
            );

            newReels[i].videoPlayerController = controller;
          }
          reelsList.addAll(newReels);

          // Preload initial reels
          if (!isLoadMore) {
            await preloadReels(0);
            startWatchTimer(0);
          }

          notifyListeners();
          currentPage++; // Move to the next page

          // If the number of new reels is less than the page size, no more data
          const int pageSize = 10;
          if (newReels.length < pageSize) {
            hasMoreData = false;
            reelsListState.isLoadMore = false;
          }
        } else {
          reelsListState.isLoadMore = false;
          hasMoreData = false; // No more data available
        }
      },
      failure: (NetworkExceptions error) {
        reelsListState.isLoading = false;
        reelsListState.isLoadMore = false;
        String errorMsg = NetworkExceptions.getErrorMessage(error);
        if (errorMsg.contains("504")) {
          print("🔴 504 Gateway Timeout received, retrying in 20 seconds...");
          Future.delayed(const Duration(seconds: 20), () {
            getReels(context, ref: ref, isLoadMore: isLoadMore);
          });
        } else {
          showMessageDialog(context, "Something went wrong", null);
        }
      },
    );

    notifyListeners();
  }

  UIState<GetReelsListResponseModel> guestReelsListState =
      UIState<GetReelsListResponseModel>();
  Future getGuestsReels(
    BuildContext context,
  ) async {
    // if (!isLoadMore) {
    //   reelsListState.isLoading = true;
    //
    //   reelsListState.success = null;
    //   currentPage = 1;
    //   savedVideos.clear();
    //   reelsList.clear();
    //   _preloadedIndices.clear();
    //   pageStorageKey = PageStorageKey<int>(0);
    // } else {
    //   reelsListState.isLoadMore = true;
    // }
    ApiResult apiResult = await reelsRepository.getGuestReels();

    apiResult.when(
      success: (data) async {
        guestReelsListState.success = data;
        guestReelsListState.isLoading = false;
        guestReelsListState.isLoadMore = false;

        if (guestReelsListState.success?.success ?? false) {
          Session.userType = guestReelsListState.success?.data?.userType ?? "";
        }
        print(Session.userType);
        var newReels = data.data?.results ?? [];
        if (newReels.isNotEmpty) {
          // likedVideos.addAll(List.generate(newReels.length, (index) => false));
          // showHeart.addAll(List.generate(newReels.length, (index) => false));
          // savedVideos.addAll(List.generate(newReels.length, (index) => false));

          for (var i = 0; i < newReels.length; i++) {
            final controller = VideoPlayerController.networkUrl(
              Uri.parse(newReels[i].videoUrl ?? ""),
            );

            newReels[i].videoPlayerController = controller;
          }
          reelsList.addAll(newReels);

          notifyListeners();
          currentPage++; // Move to the next page
        } else {
          hasMoreData = false; // No more data available
        }
      },
      failure: (NetworkExceptions error) {
        guestReelsListState.isLoading = false;

        String errorMsg = NetworkExceptions.getErrorMessage(error);
        showMessageDialog(context, errorMsg, null);
      },
    );

    notifyListeners();
  }

  Future getReelsById(BuildContext context,
      {required WidgetRef ref,
      bool isLoadMore = false,
      String? reelId,
      required String contentId}) async {
    if (reelsListState.isLoading || (isLoadMore && !hasMoreData)) return;

    if (!isLoadMore) {
      reelsListState.isLoading = true;
      reelsListState.success = null;
      currentPage = 1;
      savedVideos.clear();
      reelsList.clear();
    } else {
      reelsListState.isLoadMore = true;
    }
    notifyListeners();

    ApiResult apiResult = await reelsRepository.getReelsById(
        reelId: reelId ?? "", contentId: contentId); //

    apiResult.when(
      success: (data) async {
        reelsListState.success = data;
        reelsListState.isLoading = false;
        reelsListState.isLoadMore = false;

        print("data==================>${reelsListState.success?.data}");
        print(
            "data.result==================>${reelsListState.success?.data?.results}");
        // print("data.result.data==================>${data.result.data}");
        var newReels = reelsListState.success?.data?.results ?? [];
        if (newReels.isNotEmpty) {
          reelsList.addAll(newReels);
          // likedVideos.addAll(List.generate(newReels.length, (index) => false));
          showHeart.addAll(List.generate(newReels.length, (index) => false));
          savedVideos.addAll(List.generate(newReels.length, (index) => false));
          getReels(context, ref: ref, isLoadMore: true);
          notifyListeners();
          currentPage++; // Move to the next page
        } else {
          hasMoreData = false; // No more data available
        }
      },
      failure: (NetworkExceptions error) {
        reelsListState.isLoading = false;
        reelsListState.isLoadMore = false;
        String errorMsg = NetworkExceptions.getErrorMessage(error);
        showMessageDialog(context, errorMsg, null);
      },
    );

    notifyListeners();
  }

  /// Like or unlike the video
  Future<void> toggleLike(
    int index,
    BuildContext context, {
    bool isFromDoubleTap = false,
  }) async {
    final reel = reelsList[index];
    final wasLiked = reel.isLiked ?? false;

    if (isFromDoubleTap) {
      // 👇 Only like if not already liked
      if (!wasLiked) {
        reel.isLiked = true;
        reel.likes = (reel.likes ?? 0) + 1;

        interactionActionType
          ..remove(InteractionActionType.dislike)
          ..add(InteractionActionType.like);
      }
    } else {
      // Toggle like state
      reel.isLiked = !wasLiked;

      if (reel.isLiked == true) {
        reel.likes = (reel.likes ?? 0) + 1;

        interactionActionType
          ..remove(InteractionActionType.dislike)
          ..add(InteractionActionType.like);
      } else {
        if ((reel.likes ?? 0) > 0) {
          reel.likes = (reel.likes ?? 0) - 1;
        }

        interactionActionType
          ..remove(InteractionActionType.like)
          ..add(InteractionActionType.dislike);
      }
    }

    // Show heart animation
    showHeart[index] = true;
    notifyListeners();

    // Hide heart after delay
    Future.delayed(const Duration(milliseconds: 800), () {
      showHeart[index] = false;
      notifyListeners();
    });
  }

  // Future<void> toggleLike(int index, BuildContext context,
  //     {bool isFromDoubleTap = false}) async {
  //   if (isFromDoubleTap) {
  //     reelsList[index].isLiked = true;
  //   } else {
  //     reelsList[index].isLiked =
  //         reelsList[index].isLiked == true ? false : true;
  //   }
  //
  //   if (reelsList[index].isLiked == true) {
  //     if (!interactionActionType.contains(InteractionActionType.like)) {
  //       reelsList[index].likes = (reelsList[index].likes ?? 0) + 1;
  //       interactionActionType.add(InteractionActionType.like);
  //     }
  //   } else {
  //     if (!isFromDoubleTap) {
  //       if (reelsList[index].likes != 0) {
  //         reelsList[index].likes = (reelsList[index].likes ?? 0) - 1;
  //       }
  //       interactionActionType.add(InteractionActionType.dislike);
  //     }
  //   }
  //   showHeart[index] = true;
  //   notifyListeners();
  //
  //   Future.delayed(const Duration(milliseconds: 800), () {
  //     showHeart[index] = false;
  //     notifyListeners();
  //   });
  //   // await postInteraction(
  //   //     context: context,
  //   //     actionType: reelsList[index].isLiked == true
  //   //         ? InteractionActionType.like
  //   //         : InteractionActionType.dislike,
  //   //     index: index,
  //   //     duration: 0); // Duration not needed for like/dislike
  // }

  /// Save or unsave the video
  Future<void> toggleSave(int index, context) async {
    reelsList[index].isBookmarked =
        reelsList[index].isBookmarked == true ? false : true;
    showSaveAnimation = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 300), () {
      showSaveAnimation = false;
      notifyListeners();
    });

    await postBookMarkWatchList(
        context: context,
        isBookmarked: reelsList[index].isBookmarked,
        contentId: reelsList[index].contentId ?? "",
        reelId: reelsList[index].id ?? "");
  }

  UIState<GetBookMarkWatchResponse> bookmarkWatchListState =
      UIState<GetBookMarkWatchResponse>();

  Future<void> postBookMarkWatchList(
      {context,
      bool? isBookmarked,
      bool? isWatched,
      double? rating,
      required String contentId,
      String? reelId}) async {
    ApiResult<GetBookMarkWatchResponse> apiResult =
        await reelsRepository.postBookMarkWatchList(
            isWatched: isWatched,
            isBookmarked: isBookmarked,
            rating: rating ?? 0.0,
            contentId: contentId,
            reelId: reelId ?? "");

    apiResult.when(
      success: (data) async {
        // bookmarkWatchListState.success = data;
        bookmarkWatchListState.isLoading = false;
        bookmarkWatchListState.isLoadMore = false;
        updateWidget();
      },
      failure: (NetworkExceptions error) {
        bookmarkWatchListState.isLoading = false;
        bookmarkWatchListState.isLoadMore = false;
        String errorMsg = NetworkExceptions.getErrorMessage(error);
        showMessageDialog(context, errorMsg, null);
      },
    );
  }

  UIState<PostReportResponseModel> postReportState =
      UIState<PostReportResponseModel>();

  Future<void> postReport({context, report}) async {
    ApiResult<PostReportResponseModel> apiResult =
        await reelsRepository.postReport(report: report);

    apiResult.when(
      success: (data) async {
        // bookmarkWatchListState.success = data;
        postReportState.isLoading = false;
        postReportState.isLoadMore = false;
        updateWidget();
      },
      failure: (NetworkExceptions error) {
        postReportState.isLoading = false;
        postReportState.isLoadMore = false;
        String errorMsg = NetworkExceptions.getErrorMessage(error);
        showMessageDialog(context, errorMsg, null);
      },
    );
  }

  Future<void> postInteraction({
    required BuildContext context,
    // required List<InteractionActionType> actionType,
    int? duration, // Duration passed directly
    required int index,
    String? reelId,
    String? comment,
    String? searchTerm,
    String? recipient,
    int? watchCount,
    bool? isPromoted,
    String? adCampaignId,
  }) async {
    ApiResult<GetUserInteractionResponse>? apiResult =
        await interactionService.postInteraction(
      actionType: comment != null
          ? [InteractionActionType.comment]
          : interactionActionType,
      watchCount: watchCount,
      reelId: reelsList[index].id ?? "",
      contentId: reelsList[index].contentId ?? "",
      comment: comment,
      searchTerm: searchTerm,
      duration: duration,
      // Passing correct duration
      recipient: recipient,
      isPromoted: isPromoted,
      adCampaignId: adCampaignId,
    );

    apiResult?.when(
      success: (data) async {
        log("Interaction Response: $data");
      },
      failure: (NetworkExceptions error) {
        String errorMsg = NetworkExceptions.getErrorMessage(error);
        log("post interaction error: $errorMsg");
        showMessageDialog(context, "Something went wrong", null);
      },
    );
  }

  UIState<GetCommentsResponseModel> commentsState =
      UIState<GetCommentsResponseModel>();
  List<Result> commentsList = [];

  bool hasMoreComments = true;

  Future<void> getComments(
    BuildContext context, {
    required WidgetRef ref,
    required String reelId, // assuming comments are fetched per reel
    bool isLoadMore = false,
  }) async {
    if (commentsState.isLoading || (isLoadMore && !hasMoreComments)) return;

    if (!isLoadMore) {
      commentsState.isLoading = true;
      commentsState.success = null;
      commentsList.clear();
    } else {
      commentsState.isLoadMore = true;
    }

    notifyListeners();

    ApiResult apiResult = await reelsRepository.getComments(
      reelId: reelId,
    );

    apiResult.when(
      success: (data) {
        commentsState.success = data;
        commentsState.isLoading = false;
        commentsState.isLoadMore = false;

        var newComments = commentsState.success?.data?.results ?? [];

        if (newComments.isNotEmpty) {
          commentsList.addAll(newComments);
          commentsList.removeWhere(
            (element) => element.comment == null || element.comment == "",
          );
        } else {
          hasMoreComments = false;
        }

        notifyListeners();
      },
      failure: (NetworkExceptions error) {
        commentsState.isLoading = false;
        commentsState.isLoadMore = false;

        String errorMsg = NetworkExceptions.getErrorMessage(error);
        showMessageDialog(context, errorMsg, null);
      },
    );

    notifyListeners();
  }
}
