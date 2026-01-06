import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/widgets/common_image_view.dart';
import 'package:vista_flicks/core/widgets/custom_button.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';
import 'package:vista_flicks/framework/controller/dynamic_link_controller.dart';
import 'package:vista_flicks/framework/controller/main/account_and_pref/filter/filter_controller.dart';
import 'package:vista_flicks/framework/repository/reels/model/get_reels_list_response_model.dart';
import 'package:vista_flicks/framework/utils/extension/context_extension.dart';
import 'package:vista_flicks/ui/routing/navigation_stack_item.dart';
import 'package:vista_flicks/ui/routing/stack.dart';
import 'package:vista_flicks/ui/screens/main/account_and_pref/filter/filter_screen.dart';
import 'package:vista_flicks/ui/screens/main/preview_and_detail/detail/detail_page.dart';
import 'package:vista_flicks/ui/screens/main/reel/helper/please_sign_in_widget.dart';
import 'package:vista_flicks/ui/screens/main/reel/helper/reel_shimmer.dart';
import 'package:vista_flicks/ui/screens/main/reel/helper/report_dialog.dart';
import 'package:vista_flicks/ui/screens/main/reel/helper/video_list_widget.dart';
import 'package:vista_flicks/ui/screens/main/reel/helper/you_all_caught_up_widget.dart';
import 'package:vista_flicks/ui/utils/helper/base_widget.dart';
import 'package:vista_flicks/ui/utils/helper/location_helper/location_helper.dart';
import 'package:vista_flicks/ui/utils/helper/user_interaction/user_interaction_manager.dart';
import 'package:vista_flicks/ui/utils/widgets/common_dialogs.dart';

import '../../../../core/values/size_constant.dart';
import '../../../../core/values/text_styles/base_textstyle.dart';
import '../../../../framework/controller/main/preview_and_detail/detail/detail_controller.dart';
import '../../../../framework/controller/main/reel/reels_controller.dart';
import '../../../../framework/repository/chat/model/message_list_response_model.dart';
import '../../../../framework/utils/local_storage/session.dart';
import '../../../../gen/assets.gen.dart';
import '../../../utils/anim/fade_box_transition.dart';
import '../../../utils/theme/text_style.dart';
import '../../../utils/widgets/common_button.dart';
import '../../../utils/widgets/common_group_selection_sheet.dart';
import '../../../utils/widgets/common_text.dart';
import 'helper/heart_animation.dart';
import 'helper/reel_comments_bottom_sheet.dart';

class ReelScreen extends ConsumerStatefulWidget {
  final String reelId;
  final String contentId;

  const ReelScreen({super.key, required this.reelId, required this.contentId});

  @override
  ConsumerState<ReelScreen> createState() => _ReelScreenState();
}

class _ReelScreenState extends ConsumerState<ReelScreen>
    with BaseConsumerStatefulWidget {
  Offset? _tapPosition;
  final Map<int, GlobalKey> _widgetKeys = {};

  GlobalKey getKeyForIndex(int index) {
    return _widgetKeys.putIfAbsent(index, () => GlobalKey());
  }

  TextEditingController searchTxtController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    searchTxtController.dispose();
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final reelScreenWatch = ref.watch(reelsController);
      log("currentIndex Future.delayed => ${reelScreenWatch.currentIndex}");
      if (Session.userType.toLowerCase() == "guest") {
      } else {
        reelScreenWatch.startWatchTimer(0);
        if (widget.reelId.isEmpty) {
          Future.delayed(Duration(milliseconds: 0), () {
            // Only create new PageController if it doesn't exist
            reelScreenWatch.pageController ??=
                PageController(initialPage: reelScreenWatch.currentIndex);
          });
          log("currentIndex Future.delayed after => ${reelScreenWatch.currentIndex}");
        } else {
          reelScreenWatch.currentIndex = 0;
          await reelScreenWatch.getReelsById(context,
              ref: ref, reelId: widget.reelId, contentId: widget.contentId);
        }
        reelScreenWatch.updateWidget();
        await LocationHandler.getCurrentPosition();
      }
    });
    super.initState();
  }

  void _animateHeartToButton(
      BuildContext context, Offset startPosition, int index) {
    final overlay = Overlay.of(context);

    // Get the heart button's position
    final RenderBox renderBox =
        getKeyForIndex(index).currentContext!.findRenderObject() as RenderBox;
    final Offset endPosition = renderBox.localToGlobal(Offset.zero);

    final overlayEntry = OverlayEntry(
      builder: (context) {
        return HeartAnimationOverlay(
          start: startPosition,
          end: endPosition,
        );
      },
    );

    overlay.insert(overlayEntry);

    // Remove after animation
    Future.delayed(Duration(milliseconds: 800), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget buildPage(BuildContext context) {
    final reelScreenWatch = ref.watch(reelsController);
    final filterScreenWatch = ref.watch(filterController);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (Session.userType == "guest") {
          showLoginDialog(context, "For more content, Please Sign in", () {
            ref
                .read(navigationStackController)
                .pushAndRemoveAll(NavigationStackItem.splashHome());
          });
        } else {
          if (didPop) {
            if (reelScreenWatch.reelsList.isNotEmpty) {
              reelScreenWatch.sendWatchDuration(
                  reelScreenWatch.previousReelIndex ?? 0, context);
            }
          }
        }
        return;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.black,
        appBar: AppBar(
            toolbarHeight: Platform.isIOS ? 40 : 60,
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.reelId.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          ref.read(navigationStackController).pop();
                          if (reelScreenWatch.reelsList.isNotEmpty) {
                            reelScreenWatch.sendWatchDuration(0, context);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: SvgPicture.asset(
                            height: getHeight(30),
                            width: getWidth(30),
                            Assets.icons.svgBack,
                            color: AppColors.primeryTxt,
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          if (Session.userType == "guest") {
                            showLoginDialog(context,
                                "For more excusive content, Please Sign in",
                                () {
                              ref
                                  .read(navigationStackController)
                                  .pushAndRemoveAll(
                                      NavigationStackItem.splashHome());
                            });
                          } else {
                            // showRedirectConfirmationPopup(context);
                            reelScreenWatch.currentIndex = 0;
                            if (reelScreenWatch.reelsList.isNotEmpty) {
                              reelScreenWatch.sendWatchDuration(
                                  reelScreenWatch.previousReelIndex ?? 0,
                                  context);
                            }
                            await reelScreenWatch.getReels(context, ref: ref);
                            reelScreenWatch.startWatchTimer(
                                reelScreenWatch.previousReelIndex ?? 0);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (reelScreenWatch.pageController.hasClients &&
                                  reelScreenWatch.reelsList.isNotEmpty) {
                                reelScreenWatch.pageController.jumpToPage(0);
                              }
                            });
                          }
                        },
                        child: SvgPicture.asset(
                          height: getHeight(30),
                          width: getWidth(30),
                          Assets.icons.tablerIconFlicks,
                          color: AppColors.primeryTxt,
                        ),
                      ),
              ],
            ),
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            actions: [
              GestureDetector(
                onTap: () {
                  if (Session.userType == "guest") {
                    showLoginDialog(
                      context,
                      "For more exclusive content, Please Sign in",
                      () {
                        ref
                            .read(navigationStackController)
                            .pushAndRemoveAll(NavigationStackItem.splashHome());
                      },
                    );
                  } else {
                    filterScreenWatch.updateSelectedCategory(
                        'Genre', context, ref);
                    if (reelScreenWatch.reelsList.isNotEmpty) {
                      reelScreenWatch.reelsList[reelScreenWatch.currentIndex]
                          .videoPlayerController
                          ?.pause();
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FilterScreen(
                            type: "Genre",
                          ),
                        )).whenComplete(
                      () {
                        if (reelScreenWatch
                                .reelsList[reelScreenWatch.currentIndex]
                                .videoPlayerController !=
                            null) {
                          reelScreenWatch
                              .reelsList[reelScreenWatch.currentIndex]
                              .videoPlayerController
                              ?.play();
                        }
                      },
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: SvgPicture.asset(
                    height: getHeight(30),
                    width: getWidth(30),
                    Assets.icons.tablerIconFilter,
                    color: AppColors.primeryTxt,
                  ),
                ),
              )
            ]),
        body: reelScreenWatch.reelsListState.isLoading
            ? ReelShimmer()
            : RefreshIndicator.adaptive(
                onRefresh: () async {
                  if (Session.userType == "guest") {
                    showLoginDialog(
                      context,
                      "For more exclusive content, Please Sign in",
                      () {
                        ref
                            .read(navigationStackController)
                            .pushAndRemoveAll(NavigationStackItem.splashHome());
                      },
                    );
                  } else {
                    reelScreenWatch.currentIndex = 0;
                    if (reelScreenWatch.reelsList.isNotEmpty) {
                      reelScreenWatch.sendWatchDuration(0, context);
                    }
                    await reelScreenWatch.getReels(context, ref: ref);
                    reelScreenWatch.startWatchTimer(0);
                  }
                },
                child: PageView.builder(
                  // key: const PageStorageKey<String>('reelsPageView'),
                  key: reelScreenWatch.pageStorageKey,
                  controller: reelScreenWatch.pageController,
                  scrollDirection: Axis.vertical,
                  physics: Session.userType == "guest" &&
                          reelScreenWatch.currentIndex == 5
                      ? NeverScrollableScrollPhysics()
                      : AlwaysScrollableScrollPhysics(),
                  itemCount: reelScreenWatch.reelsList.length + 1,
                  onPageChanged: (index) async {
                    if (Session.userType == "guest") {
                      int pageIndex =
                          reelScreenWatch.pageController.page?.round() ?? 0;
                      reelScreenWatch.currentIndex = pageIndex;
                      log("index and i currentIndex $pageIndex");

                      // Trigger preloading of adjacent reels
                      await reelScreenWatch.preloadReels(pageIndex);
                    }
                    // Update currentIndex with the integer page number
                    else {
                      if (reelScreenWatch.reelsList.isEmpty ||
                          (reelScreenWatch.pageController.page ==
                                  reelScreenWatch.reelsList.length &&
                              !reelScreenWatch.hasMoreData)) {
                        return;
                      }
                      int pageIndex =
                          reelScreenWatch.pageController.page?.round() ?? 0;
                      reelScreenWatch.currentIndex = pageIndex;
                      log("index and i currentIndex $pageIndex");

                      // Trigger preloading of adjacent reels
                      await reelScreenWatch.preloadReels(pageIndex);

                      // Send watch duration for the previous reel
                      if (reelScreenWatch.previousReelIndex != null) {
                        reelScreenWatch.sendWatchDuration(
                            reelScreenWatch.previousReelIndex!, context);
                      }

                      reelScreenWatch.interactionActionType = [
                        InteractionActionType.views
                      ];

                      // Start tracking watch time for new reel
                      reelScreenWatch.startWatchTimer(index);

                      if (index == reelScreenWatch.reelsList.length - 2) {
                        reelScreenWatch.getReels(context,
                            ref: ref, isLoadMore: true); // Load next page
                      }
                    }
                    reelScreenWatch.updateWidget();
                  },
                  itemBuilder: (context, index) {
                    if (index > 4 &&
                        Session.userType.toLowerCase() == 'guest') {
                      return PleaseSignInWidget();
                    } else {
                      if (!reelScreenWatch.reelsListState.isLoading) {
                        if (reelScreenWatch.reelsList.isEmpty) {
                          if ((index == reelScreenWatch.reelsList.length &&
                                  !reelScreenWatch.hasMoreData) &&
                              !reelScreenWatch.reelsListState.isLoadMore) {
                            return YouAllCaughtUpWidget();
                          }
                        }
                      }

                      if (index < reelScreenWatch.reelsList.length) {
                        var reelData = reelScreenWatch.reelsList[index];
                        log("reelScreenWatch.reelsList.length  reelScreenWatch.reelsList[index].videoPlayerController");
                        return GestureDetector(
                          onDoubleTapDown: (TapDownDetails details) {
                            if (Session.userType == "guest") {
                              showLoginDialog(
                                context,
                                "For more exclusive content, Please Sign in",
                                () {
                                  ref
                                      .read(navigationStackController)
                                      .pushAndRemoveAll(
                                          NavigationStackItem.splashHome());
                                },
                              );
                            } else {
                              _tapPosition = details.globalPosition;
                            }
                          },
                          onDoubleTap: () {
                            if (Session.userType == "guest") {
                              // showLoginDialog(
                              //   context,
                              //   "For more exclusive content, Please Sign in",
                              //   () {
                              //     ref
                              //         .read(navigationStackController)
                              //         .pushAndRemoveAll(
                              //             NavigationStackItem.splashHome());
                              //   },
                              // );
                            }

                            // Use context.findRenderObject() to handle position in the page view.
                            else {
                              if (_tapPosition != null) {
                                _animateHeartToButton(
                                    context, _tapPosition!, index);
                                reelScreenWatch.toggleLike(index, context,
                                    isFromDoubleTap: true);
                                // reelScreenWatch.interactionActionType.contains(InteractionActionType.dislike) ? reelScreenWatch.toggleLike(index, context) : null;
                              }
                            }
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              VideoListWidget(
                                key: ValueKey(reelScreenWatch.reelsList[index]),
                                // videoListData: reelScreenWatch.reelsList[index],
                                onVideoCompleteEvent: () {
                                  if ((reelScreenWatch.reelsList.length - 1) >
                                      index) {
                                    reelScreenWatch.pageController
                                        .animateToPage(index + 1,
                                            duration:
                                                Duration(milliseconds: 100),
                                            curve: Curves.easeIn);
                                    reelScreenWatch.updateWidget();
                                  }
                                },
                                reelModel: reelScreenWatch.reelsList[index],
                              ),
                              if (reelScreenWatch.showSaveAnimation)
                                AnimatedOpacity(
                                  opacity: reelScreenWatch.savedVideos[index]
                                      ? 1.0
                                      : 0.0,
                                  duration: Duration(milliseconds: 1000),
                                  child: Lottie.asset(
                                    Assets.lottie.savedIcon,
                                  ),
                                ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              if (Session.userType == "guest") {
                                                showLoginDialog(
                                                  context,
                                                  "For more exclusive content, Please Sign in",
                                                  () {
                                                    ref
                                                        .read(
                                                            navigationStackController)
                                                        .pushAndRemoveAll(
                                                            NavigationStackItem
                                                                .splashHome());
                                                  },
                                                );
                                              } else {
                                                // Pause the current video before navigating
                                                if (reelData
                                                        .videoPlayerController !=
                                                    null) {
                                                  reelData.videoPlayerController
                                                      ?.pause();
                                                }
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailScreen(
                                                              contentId: reelData
                                                                      .contentId ??
                                                                  ""),
                                                    )).whenComplete(
                                                  () {
                                                    if (reelData
                                                            .videoPlayerController !=
                                                        null) {
                                                      reelData
                                                          .videoPlayerController
                                                          ?.play();
                                                    }
                                                  },
                                                );
                                              }
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Row(
                                                  children: [
                                                    if (reelData.movieLogo !=
                                                        null)
                                                      CommonImageView(
                                                        width: 150.w,
                                                        url: reelData.movieLogo,
                                                      ),
                                                    if (reelData.movieLogo !=
                                                        null)
                                                      getHorizonatlWidth(10.w),
                                                    if (reelData.movieLogo ==
                                                        null)
                                                      Expanded(
                                                        child: MyRegularText(
                                                          reelData.title ?? "",
                                                          style: BaseTextStyle
                                                              .headerMl,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                if (reelData.rating != 0.0)
                                                  Stack(
                                                    children: [
                                                      SvgPicture.asset(
                                                          height: 20.h,
                                                          width: 100.w,
                                                          Assets.icons.ratings),
                                                      Positioned(
                                                        left: context.width *
                                                            .145,
                                                        child: MyRegularText(
                                                          reelData.rating
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .bebasNeue(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 16,
                                                                  color: AppColors
                                                                      .primeryTxt),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                if (Platform.isAndroid)
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10,
                                                                vertical: 2),
                                                        margin: EdgeInsets.only(
                                                            bottom: 5),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColors
                                                              .black11
                                                              .withOpacity(.5),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        child: Text(
                                                            "Uploaded by : ${reelData.uploadedBy?.userName ?? reelData.uploadedBy?.firstName ?? ""}",
                                                            style: BaseTextStyle
                                                                .textS),
                                                      ),
                                                      if (Platform.isAndroid)
                                                        if (reelData
                                                                .showReelsAsAds ==
                                                            true)
                                                          getHorizonatlWidth(
                                                              5.w),
                                                      if (Platform.isAndroid)
                                                        if (reelData
                                                                .showReelsAsAds ==
                                                            true)
                                                          Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        2),
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 5),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .black11
                                                                  .withOpacity(
                                                                      .5),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            child: Text(
                                                                "Ad | Sponsored",
                                                                style:
                                                                    BaseTextStyle
                                                                        .textS),
                                                          ),
                                                    ],
                                                  ),
                                                Text(
                                                  reelData.description ?? "",
                                                  style: BaseTextStyle.textS
                                                      .copyWith(
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                  maxLines: 2,
                                                ),
                                                MyRegularText(
                                                  "${reelData.views ?? 0} Views",
                                                  style: BaseTextStyle.textXxs,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        getVerticalHeight(20),
                                        Column(
                                          children: [
                                            Column(children: [
                                              if (reelScreenWatch.showLikeIcon)
                                                GestureDetector(
                                                  onTap: () {
                                                    if (Session.userType ==
                                                        "guest") {
                                                      showLoginDialog(
                                                        context,
                                                        "For more exclusive content, Please Sign in",
                                                        () {
                                                          ref
                                                              .read(
                                                                  navigationStackController)
                                                              .pushAndRemoveAll(
                                                                  NavigationStackItem
                                                                      .splashHome());
                                                        },
                                                      );
                                                    } else {
                                                      reelScreenWatch
                                                          .toggleLike(
                                                              index, context);
                                                    }
                                                  },
                                                  child: SvgPicture.asset(
                                                    key: getKeyForIndex(index),
                                                    height: getHeight(30),
                                                    width: getWidth(30),
                                                    reelScreenWatch
                                                                .reelsList[
                                                                    index]
                                                                .isLiked ==
                                                            true
                                                        ? Assets.icons
                                                            .tablerIconHeartFilled
                                                        : Assets.icons
                                                            .tablerIconHeart,
                                                    color: reelScreenWatch
                                                                .reelsList[
                                                                    index]
                                                                .isLiked ==
                                                            true
                                                        ? AppColors.red
                                                        : AppColors.primeryTxt,
                                                  ),
                                                ),
                                              Text(
                                                "${reelData.likes ?? 0}",
                                                style: BaseTextStyle.lableXxs,
                                              ),
                                            ]),
                                            getVerticalHeight(20),
                                            Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    if (Session.userType ==
                                                        "guest") {
                                                      showLoginDialog(
                                                        context,
                                                        "For more exclusive content, Please Sign in",
                                                        () {
                                                          ref
                                                              .read(
                                                                  navigationStackController)
                                                              .pushAndRemoveAll(
                                                                  NavigationStackItem
                                                                      .splashHome());
                                                        },
                                                      );
                                                    } else {
                                                      reelScreenWatch
                                                          .getComments(context,
                                                              ref: ref,
                                                              reelId:
                                                                  reelData.id ??
                                                                      "");
                                                      showModalBottomSheet(
                                                        context: context,
                                                        isScrollControlled:
                                                            true,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        builder: (context) {
                                                          return ReelCommentsBottomSheet(
                                                              reelIndex: index);
                                                        },
                                                      );
                                                    }
                                                  },
                                                  child: SvgPicture.asset(
                                                    height: getHeight(24),
                                                    width: getWidth(24),
                                                    Assets.icons
                                                        .tablerIconComments,
                                                    color: AppColors.primeryTxt,
                                                  ),
                                                ),
                                                MyRegularText(
                                                  "${reelData.commentCount ?? 0}",
                                                  style: BaseTextStyle.lableXxs,
                                                ),
                                              ],
                                            ),
                                            getVerticalHeight(20),
                                            GestureDetector(
                                              onTap: () {
                                                if (Session.userType ==
                                                    "guest") {
                                                  showLoginDialog(
                                                    context,
                                                    "For more exclusive content, Please Sign in",
                                                    () {
                                                      ref
                                                          .read(
                                                              navigationStackController)
                                                          .pushAndRemoveAll(
                                                              NavigationStackItem
                                                                  .splashHome());
                                                    },
                                                  );
                                                } else {
                                                  reelScreenWatch.toggleSave(
                                                      index, context);
                                                }

                                                // showReviewPopup(context);
                                              },
                                              child: SvgPicture.asset(
                                                height: getHeight(30),
                                                width: getWidth(30),
                                                reelScreenWatch.reelsList[index]
                                                            .isBookmarked ==
                                                        true
                                                    ? Assets.icons
                                                        .tablerIconBookmarkFilled
                                                    : Assets.icons
                                                        .tablerIconBookmark,
                                                color: AppColors.primeryTxt,
                                              ),
                                            ),
                                            getVerticalHeight(20),
                                            Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    if (Session.userType
                                                            .toLowerCase() ==
                                                        "guest") {
                                                      return showLoginDialog(
                                                          context,
                                                          "For more excusive content, Please Sign in",
                                                          () {
                                                        ref
                                                            .read(
                                                                navigationStackController)
                                                            .pushAndRemoveAll(
                                                                NavigationStackItem
                                                                    .splashHome());
                                                      });
                                                    } else {
                                                      showReviewPopup(
                                                          context, reelData);
                                                    }
                                                  },
                                                  child: SvgPicture.asset(
                                                    height: getHeight(30),
                                                    width: getWidth(30),
                                                    reelData.isWatched ?? false
                                                        ? Assets.icons
                                                            .tablerIconCircleChecked
                                                        : Assets.icons
                                                            .tablerIconCircleCheck,
                                                  ),
                                                ),
                                                MyRegularText(
                                                  "${reelData.watchedCount ?? 0}",
                                                  style: BaseTextStyle.lableXxs,
                                                ),
                                              ],
                                            ),
                                            getVerticalHeight(20),
                                            GestureDetector(
                                              onTap: () {
                                                if (Session.userType ==
                                                    "guest") {
                                                  showLoginDialog(
                                                    context,
                                                    "For more exclusive content, Please Sign in",
                                                    () {
                                                      ref
                                                          .read(
                                                              navigationStackController)
                                                          .pushAndRemoveAll(
                                                              NavigationStackItem
                                                                  .splashHome());
                                                    },
                                                  );
                                                } else {
                                                  final detailScreenWatch = ref
                                                      .watch(detailController);
                                                  detailScreenWatch
                                                      .selectedGroups
                                                      .clear();
                                                  showModalBottomSheet(
                                                      backgroundColor:
                                                          AppColors.black,
                                                      isScrollControlled: true,
                                                      builder: (context) =>
                                                          CommonGroupSelectionSheet(
                                                            searchTxtController:
                                                                searchTxtController,
                                                            media: MessageMedia(
                                                                mediaUrl: reelData
                                                                        .thumbnailUrl ??
                                                                    "",
                                                                mediaId: reelData
                                                                        .contentId ??
                                                                    "",
                                                                mediaType:
                                                                    "reel",
                                                                mediaReelId:
                                                                    reelData.id ??
                                                                        ""),
                                                          ),
                                                      context: context);
                                                }
                                              },
                                              child: SvgPicture.asset(
                                                height: getHeight(30),
                                                width: getWidth(30),
                                                Assets.icons.tablerIconSend,
                                                color: AppColors.primeryTxt,
                                              ),
                                            ),
                                            getVerticalHeight(20),
                                            if (Session.userType != "guest")
                                              PopupMenuButton<String>(
                                                color: AppColors.black,
                                                icon: SvgPicture.asset(
                                                  height: getHeight(30),
                                                  width: getWidth(30),
                                                  Assets.icons
                                                      .tablerIconDotsVertical,
                                                  color: AppColors.primeryTxt,
                                                ),
                                                onSelected:
                                                    (String value) async {
                                                  switch (value) {
                                                    case 'share':
                                                      final dynamicLinkController =
                                                          ref.read(
                                                              dynamicLinkControllerProvider
                                                                  .notifier);
                                                      await dynamicLinkController
                                                          .createDynamicLink(
                                                        true,
                                                        reelData.title ?? "",
                                                        image: reelData
                                                            .thumbnailUrl,
                                                        contentId:
                                                            reelData.contentId,
                                                        reelId: reelData.id,
                                                        context: context,
                                                      );
                                                      reelScreenWatch
                                                          .interactionActionType
                                                          .add(
                                                              InteractionActionType
                                                                  .share);
                                                      break;
                                                    case 'report':
                                                      reelScreenWatch
                                                          .selectedReason = "";
                                                      showWidgetDialog(
                                                          context,
                                                          ReportDialog(),
                                                          () {});

                                                      break;
                                                  }
                                                },
                                                itemBuilder:
                                                    (BuildContext context) => [
                                                  PopupMenuItem<String>(
                                                    value: 'share',
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                          height: getHeight(20),
                                                          width: getWidth(20),
                                                          Assets.icons
                                                              .tablerIconShare,
                                                          color: AppColors
                                                              .primeryTxt,
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text(
                                                          'Share',
                                                          style: BaseTextStyle
                                                              .textM,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  PopupMenuItem<String>(
                                                    value: 'report',
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                          height: getHeight(20),
                                                          width: getWidth(20),
                                                          Assets.icons
                                                              .tablerIconInfoCircle,
                                                          color: AppColors
                                                              .primeryTxt,
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text(
                                                          'Report',
                                                          style: BaseTextStyle
                                                              .textM,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    getVerticalHeight(10),
                                    reelData.bannerData?.bannerImage! == null
                                        ? SizedBox(
                                            height: 44.h,
                                            child: reelData
                                                        .ottPlatforms?.length ==
                                                    1
                                                ? GestureDetector(
                                                    onTap: () {
                                                      handleOTTPlatformRedirection(
                                                          context,
                                                          ref,
                                                          reelData,
                                                          0);
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          right: 10.w),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  getWidth(12),
                                                              vertical:
                                                                  getHeight(7)),
                                                      decoration: BoxDecoration(
                                                          color: AppColors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        // mainAxisSize:
                                                        //     MainAxisSize.min,
                                                        children: [
                                                          SvgPicture.asset(
                                                            Assets.icons.share2,
                                                            color: AppColors
                                                                .primeryTxt,
                                                          ),
                                                          getHorizonatlWidth(5),
                                                          MyRegularText(
                                                            reelData
                                                                    .ottPlatforms
                                                                    ?.first
                                                                    .id
                                                                    ?.name
                                                                    .toString() ??
                                                                "",
                                                            style: BaseTextStyle
                                                                .buttonS,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : ListView.separated(
                                                    controller:
                                                        _scrollController,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    shrinkWrap: true,
                                                    separatorBuilder:
                                                        (context, index) =>
                                                            SizedBox(),
                                                    itemCount: reelData
                                                            .ottPlatforms
                                                            ?.length ??
                                                        0,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final ottPlatforms =
                                                          reelData.ottPlatforms?[
                                                              index];
                                                      return GestureDetector(
                                                        onTap: () {
                                                          handleOTTPlatformRedirection(
                                                              context,
                                                              ref,
                                                              reelData,
                                                              index);
                                                        },
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 10.w),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal:
                                                                getWidth(12),
                                                            vertical:
                                                                getHeight(7),
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                AppColors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                          ),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              SvgPicture.asset(
                                                                Assets.icons
                                                                    .tablerIconPlaystationTriangle,
                                                                color: AppColors
                                                                    .primeryTxt,
                                                              ),
                                                              getHorizonatlWidth(
                                                                  5),
                                                              MyRegularText(
                                                                ottPlatforms?.id
                                                                        ?.name
                                                                        .toString() ??
                                                                    "",
                                                                style:
                                                                    BaseTextStyle
                                                                        .buttonS,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                          )
                                        : CommonImageView(
                                            fit: BoxFit.cover,
                                            height: 50.h,
                                            borderRadius:
                                                BorderRadius.circular(6.r),
                                            width: context.width,
                                            url: reelData
                                                .bannerData?.bannerImage,
                                          ),
                                    getVerticalHeight(
                                        widget.reelId.isEmpty ? 90.w : 35.h),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // If we've reached the end and there is no more data, show "You All Caught Up"
                        if ((index == reelScreenWatch.reelsList.length) &&
                            !reelScreenWatch.hasMoreData &&
                            !reelScreenWatch.reelsListState.isLoadMore) {
                          return YouAllCaughtUpWidget();
                        } else if (reelScreenWatch.reelsListState.isLoadMore) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return ReelShimmer();
                        }
                      }
                    }
                  },
                ),
              ),
      ),
    );
  }

  handleOTTPlatformRedirection(BuildContext context, WidgetRef ref,
      ReelModel reelData, int index) async {
    if (Session.userType.toLowerCase() == "guest") {
      showLoginDialog(
        context,
        "For more content, Please Sign in",
        () {
          ref.read(navigationStackController).pushAndRemoveAll(
                NavigationStackItem.splashHome(),
              );
        },
      );
      return;
    }

    try {
      final platformData = reelData.ottPlatforms?[index];

      if (platformData == null) {
        print("No OTT platform data available.");
        return;
      }

      String destinationLink = platformData.destinationLink ?? '';
      String packageName = platformData.id?.packageName?.android ?? '';
      String iosStoreId = platformData.id?.packageName?.ios ?? "";

      if (Platform.isIOS) {
        if (destinationLink.isNotEmpty) {
          await launchUrl(Uri.parse(destinationLink),
              mode: LaunchMode.externalApplication);
        } else if (iosStoreId.isNotEmpty) {
          await launchUrl(
            Uri.parse('itms-apps://itunes.apple.com/app/id$iosStoreId'),
            mode: LaunchMode.externalApplication,
          );
        }
        return;
      }

      if (Platform.isAndroid) {
        final isInstalled = await InstalledApps.isAppInstalled(packageName);

        final shouldProceed = await showRedirectConfirmationPopup(
          context,
          // isInstalled: isInstalled,
        );

        if (shouldProceed != true) return;

        if (isInstalled == true && reelData.showReelsAsAds == false) {
          if (destinationLink.isNotEmpty) {
            await launchUrl(Uri.parse(destinationLink),
                mode: LaunchMode.externalApplication);
          } else {
            await InstalledApps.startApp(packageName);
          }
        } else {
          await launchUrl(
            Uri.parse('market://details?id=$packageName'),
            mode: LaunchMode.externalApplication,
          );
        }
      }
    } catch (e) {
      print("Redirect error: $e");
    }
  }

  void showReviewPopup(BuildContext context, ReelModel reelData) {
    final reelScreenWatch = ref.watch(reelsController);
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.all(0),
        backgroundColor: Colors.black.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonImageView(
                height: 137.h,
                url: reelData.imageUrl,
              ),
              // Image(image: AssetImage(Assets.images.p10.path)),
              getVerticalHeight(20),
              Text(
                "Have you already watched this?",
                style: BaseTextStyle.headerXl,
                textAlign: TextAlign.center,
              ),
              getVerticalHeight(20),
              Text(
                "So we won't show it in your feed",
                style: BaseTextStyle.textMl,
                textAlign: TextAlign.center,
              ),
              getVerticalHeight(20),
              CustomButton(
                color: AppColors.primeryTxt.withOpacity(0.8),
                text: "Yes",
                style: BaseTextStyle.buttonM.copyWith(color: AppColors.black),
                fun: () {
                  reelScreenWatch
                      .postBookMarkWatchList(
                    context: context,
                    contentId: reelData.contentId ?? "",
                    isWatched: true,
                    reelId: reelData.id ?? "",
                  )
                      .whenComplete(
                    () {
                      reelData.isWatched = true;
                      reelData.watchedCount = (reelData.watchedCount ?? 0) + 1;
                      reelScreenWatch.updateWidget();
                    },
                  );
                  Navigator.pop(context); // Close first popup
                  showRatingPopup(context, reelData); // Open second popup
                },
              ),
              getVerticalHeight(20),
              CustomButton(
                color: AppColors.primeryTxt.withOpacity(0.8),
                text: "No",
                style: BaseTextStyle.buttonM.copyWith(color: AppColors.black),
                fun: () {
                  Navigator.pop(context); // Close first popup
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showRatingPopup(BuildContext context, ReelModel reelData) {
    final reelScreenWatch = ref.watch(reelsController);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.all(0),
        backgroundColor: Colors.black.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonImageView(
                height: 137.h,
                url: reelData.imageUrl,
              ),
              // Image(image: AssetImage(Assets.images.p10.path)),
              getVerticalHeight(20),
              IgnorePointer(
                ignoring: reelData.rating != 0.0,
                child: RatingBar.builder(
                  unratedColor: AppColors.secondaryTxt,
                  initialRating: reelData.rating ?? 3.0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 40,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) =>
                      Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) {
                    reelData.isRated = true;
                    reelData.rating = rating;

                    print("User rated: $rating");
                    print("reelData.rating: ${reelData.rating}");
                  },
                ),
              ),
              getVerticalHeight(20),
              Text(
                "Rate this movie",
                style: BaseTextStyle.headerXl,
              ),
              getVerticalHeight(20),
              if (reelData.isRated == false)
                CustomButton(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  text: "Confirm",
                  fun: () {
                    reelScreenWatch
                        .postBookMarkWatchList(
                            contentId: reelData.contentId ?? "",
                            reelId: reelData.id,
                            context: context,
                            isBookmarked: reelData.isBookmarked,
                            isWatched: reelData.isWatched,
                            rating: reelData.rating)
                        .whenComplete(
                      () {
                        Navigator.pop(context); // Close r
                      },
                    );
                  },
                ),
              getVerticalHeight(20),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Close rating popup
                },
                child: Text(
                  "Ignore",
                  style: BaseTextStyle.buttonM,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool?> showRedirectConfirmationPopup(
  BuildContext context,
) async {
  return showDialog(
      barrierDismissible: true,
      context: context,
      barrierColor: AppColors.lightGray1.withOpacity(0.5),
      builder: (context) => FadeBoxTransition(
            child: Dialog(
              backgroundColor: AppColors.black,
              surfaceTintColor: AppColors.black,
              insetPadding: EdgeInsets.all(16.sp),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r)),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        left: 16.w, right: 16.w, top: 22.h, bottom: 15.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CommonText(
                          title: "Redirect Confirmation",
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          textStyle: TextStyles.semiBold.copyWith(
                            color: AppColors.primeryTxt,
                            fontSize: 18.sp,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        CommonText(
                          title:
                              "You will be redirected to third party Ott platform. Do you want to continue?",
                          maxLines: 100,
                          textAlign: TextAlign.center,
                          textStyle: TextStyles.regular.copyWith(
                            color: AppColors.primeryTxt.withOpacity(0.8),
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CommonButton(
                                width: 139.w,
                                height: 49.h,
                                isButtonEnabled: true,
                                buttonText: "No",
                                borderRadius: BorderRadius.circular(30.r),
                                borderWidth: 1.w,
                                onTap: () {
                                  Navigator.of(context)
                                      .pop(false); // user selected NO
                                },
                                borderColor: AppColors.black,
                                buttonEnabledColor: AppColors.red,
                                buttonTextColor: AppColors.primeryTxt),
                            SizedBox(width: 15.w),
                            CommonButton(
                                buttonText: "Yes",
                                width: 139.w,
                                height: 49.h,
                                borderWidth: 1.w,
                                isButtonEnabled: true,
                                borderRadius: BorderRadius.circular(30.r),
                                onTap: () {
                                  Navigator.of(context)
                                      .pop(true); // user selected YES
                                },
                                borderColor: AppColors.black,
                                buttonEnabledColor: AppColors.primeryTxt,
                                buttonTextColor: AppColors.black),
                          ],
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
}
