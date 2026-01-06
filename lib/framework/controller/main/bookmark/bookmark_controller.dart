import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:vista_flicks/framework/dependency_injection/inject.dart';
import 'package:vista_flicks/framework/provider/network/api_result.dart';
import 'package:vista_flicks/framework/provider/network/network_exceptions.dart';
import 'package:vista_flicks/framework/repository/bookmark/contract/bookmark_repository.dart';
import 'package:vista_flicks/framework/repository/bookmark/model/get_all_bookmark_response_model.dart';
import 'package:vista_flicks/framework/repository/bookmark/model/get_bookmark_list_response_model.dart';
import 'package:vista_flicks/framework/utils/ui_state.dart';
import 'package:vista_flicks/ui/utils/theme/theme.dart';
import 'package:vista_flicks/ui/utils/widgets/common_dialogs.dart';

final bookmarkController =
    ChangeNotifierProvider((ref) => getIt<BookmarkController>());

@injectable
class BookmarkController extends ChangeNotifier {
  BookmarkRepository bookmarkRepository;

  BookmarkController(this.bookmarkRepository);

  final TextEditingController bookmarkSearchController =
      TextEditingController();

  Timer? _searchTimer;

  /// Timer-based search debounce
  void startSearchTimer(BuildContext context, WidgetRef ref, String value) {
    _searchTimer?.cancel(); // Cancel any existing timer
    _searchTimer = Timer(const Duration(milliseconds: 500), () {
      pageNo = 1;
      getAllBookmarkListAPI(context, ref: ref, search: value, limit: '12');
    });
  }

  /// Dispose Controller
  void disposeController({bool isNotify = false}) {
    bookmarkBannerListState.isLoading = false;
    bookmarkBannerListState.success = null;
    // allBookmarkListState.isLoading = false;
    allBookmarkListState.success = null;
    bookmarkBannerList.clear();
    allBookmarkList.clear();
    if (isNotify) {
      notifyListeners();
    }
  }

  ///----------------------------------- API Integration -----------------------------------///

  UIState<BookmarkBannerListResponseModel> bookmarkBannerListState =
      UIState<BookmarkBannerListResponseModel>();
  List<BookmarkBanner> bookmarkBannerList = [];

  /// Get Bookmark API
  Future getBannerListAPI(BuildContext context,
      {required WidgetRef ref}) async {
    bookmarkBannerListState.isLoading = true;
    bookmarkBannerListState.success = null;
    bookmarkBannerList.clear();

    notifyListeners();

    ApiResult apiResult = await bookmarkRepository.getBannerListAPI();

    apiResult.when(success: (data) async {
      bookmarkBannerListState.success = data;
      bookmarkBannerListState.isLoading = false;

      if (bookmarkBannerListState.success?.success ?? false) {
        if (bookmarkBannerListState.success?.data?.isNotEmpty ?? false) {
          bookmarkBannerList
              .addAll(bookmarkBannerListState.success?.data ?? []);
        }
      }
    }, failure: (NetworkExceptions error) {
      bookmarkBannerListState.isLoading = false;
      notifyListeners();
      String errorMsg = NetworkExceptions.getErrorMessage(error);

      showMessageDialog(context, errorMsg, null);
    });
    bookmarkBannerListState.isLoading = false;

    notifyListeners();
  }

  UIState<GetAllBookmarkResponseModel> allBookmarkListState =
      UIState<GetAllBookmarkResponseModel>();
  int pageNo = 1;
  List<BookmarkBanner> allBookmarkList = [];

  /// Get All Bookmarks API with Pagination
  Future<void> getAllBookmarkListAPI(
    BuildContext context, {
    required WidgetRef ref,
    required String search,
    String limit = "12",
    bool isLoadMore = false, // Added for pagination
  }) async {
    // ✅ Use UIState's isLoadMore to avoid duplicate calls
    if (allBookmarkListState.isLoadMore) return;

    if (!isLoadMore) {
      pageNo = 1;
      allBookmarkListState.isLoading = true;
      allBookmarkList.clear();
    } else {
      allBookmarkListState.isLoadMore = true;
    }

    notifyListeners();

    ApiResult apiResult = await bookmarkRepository.getAllBookmarkListAPI(
      pageNo: pageNo,
      search: search,
      limit: limit,
    );

    apiResult.when(
      success: (data) async {
        allBookmarkListState.success = data;

        allBookmarkListState.isLoadMore = false;

        if (data.success ?? false) {
          if (data.data != null && (data.data?.results?.isNotEmpty ?? false)) {
            if (isLoadMore) {
              allBookmarkList.addAll(data.data?.results ?? []);
            } else {
              allBookmarkList = data.data?.results ?? [];
            }

            pageNo++; // ✅ Move to the next page
          }
        }
        allBookmarkListState.isLoading = false;
        notifyListeners();
      },
      failure: (NetworkExceptions error) {
        allBookmarkListState.isLoading = false;
        allBookmarkListState.isLoadMore = false;
        notifyListeners();

        String errorMsg = NetworkExceptions.getErrorMessage(error);
        showMessageDialog(context, errorMsg, null);
      },
    );

    allBookmarkListState.isLoading = false;
    allBookmarkListState.isLoadMore = false;
    notifyListeners();
  }
}
