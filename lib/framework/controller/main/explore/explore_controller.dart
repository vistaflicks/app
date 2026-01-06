import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:vista_flicks/framework/provider/network/api_result.dart';
import 'package:vista_flicks/framework/provider/network/network_exceptions.dart';
import 'package:vista_flicks/framework/repository/search/contract/search_repository.dart';
import 'package:vista_flicks/framework/repository/search/model/explore_list_response_model.dart';
import 'package:vista_flicks/framework/repository/search/model/get_home_view_all_model.dart';
import 'package:vista_flicks/framework/utils/ui_state.dart';
import 'package:vista_flicks/ui/screens/main/explore/search_in_explore/Model/get_search_response.dart';
import 'package:vista_flicks/ui/utils/const/app_constants.dart';
import 'package:vista_flicks/ui/utils/helper/user_interaction/user_interaction_manager.dart';
import 'package:vista_flicks/ui/utils/helper/user_interaction/user_interaction_response.dart';
import 'package:vista_flicks/ui/utils/widgets/common_dialogs.dart';

import '../../../../ui/utils/theme/theme.dart';
import '../../../dependency_injection/inject.dart';

final exploreController =
    ChangeNotifierProvider((ref) => getIt<ExploreController>());

@injectable
class ExploreController extends ChangeNotifier {
  SearchRepository searchRepository;
  final InteractionService interactionService;
  ExploreController(this.searchRepository)
      : interactionService = InteractionService();

  bool isLoading = false;

  // String searchText = '';
  TextEditingController searchController = TextEditingController();

  bool isSearching = false;

  // Future<void> loadMoviesAndSeries() async {
  //   try {
  //     final String jsonString = await rootBundle.loadString(Assets.json.movies);
  //     final jsonData = jsonDecode(jsonString);
  //     MoviesAndSeriesModel model = MoviesAndSeriesModel.fromJson(jsonData);

  //     allMoviesAndSeries = model.data ?? [];
  //     notifyListeners();
  //   } catch (e) {
  //     print("Error loading movies and series: $e");
  //   }
  // }

  void disposeController({bool isNotify = false}) {
    isLoading = false;
    exploreListState.isLoading = false;
    exploreListState.success = null;
    bannerList.clear();
    categoryList.clear();
    bannerData = null;
    if (isNotify) {
      notifyListeners();
    }
  }

  ///----------------------------------- API Integration -----------------------------------///

  UIState<ExploreListResponseModel> exploreListState =
      UIState<ExploreListResponseModel>();
  List<BannerData> bannerList = [];
  List<TitleDatum> categoryList = [];
  TitleDatum? bannerData;

  /// Get Explore API
  Future getExploreListAPI(BuildContext context,
      {required WidgetRef ref}) async {
    showLog('getExploreListAPI getExploreListAPI getExploreListAPI called');
    exploreListState.isLoading = true;
    exploreListState.success = null;
    bannerData = null;
    bannerList.clear();
    categoryList.clear();

    notifyListeners();

    ApiResult apiResult = await searchRepository.getExploreListAPI();

    apiResult.when(success: (data) async {
      exploreListState.success = data;
      exploreListState.isLoading = false;

      if (exploreListState.success?.success ?? false) {
        if (exploreListState.success?.data?.bannerData?.isNotEmpty ?? false) {
          bannerList.addAll(exploreListState.success?.data?.bannerData ?? []);
        }

        categoryList.addAll(exploreListState.success?.data?.titleData ?? []);

        //   for (int i = 0;
        //       i < (exploreListState.success?.data?.titleData?.length ?? 0);
        //       i++) {
        //     if ((exploreListState.success?.data?.titleData?[i].data?.isNotEmpty ??
        //         false)) {
        //       if (!(exploreListState.success?.data?.titleData?[i].title
        //               ?.toLowerCase()
        //               .startsWith('banner') ??
        //           false)) {
        //         categoryList.add(exploreListState.success!.data!.titleData![i]);
        //         log("categoryList=====================>${categoryList.length}");
        //       } else {
        //         bannerData = exploreListState.success?.data?.titleData?[i];
        //       }
        //     }
        //   }

        //   /// Set Trending In Vista Flicks At 0 index
        //   int getTrendingIndex = categoryList.indexWhere((element) =>
        //       element.title?.toLowerCase() == 'trending in vista flicks');

        //   if (getTrendingIndex != -1) {
        //     TitleDatum trendingData = categoryList[getTrendingIndex];
        //     categoryList.removeAt(getTrendingIndex);
        //     categoryList.insert(0, trendingData);
        //   }

        //   int bannerCount = bannerData?.data?.length ?? 0;
        //   int setBannerAtIndex = bannerCount > 0
        //       ? categoryList.length ~/ bannerCount
        //       : 1; // Set a default value to avoid division by zero

        //   int bannerIndex = 0;
        //   int categoryIndex = 0;

        //   List<TitleDatum> updatedList = [];

        //   for (var category in categoryList) {
        //     updatedList.add(category);
        //     categoryIndex++;

        //     if (setBannerAtIndex != 0 &&
        //         categoryIndex % setBannerAtIndex == 0 &&
        //         bannerIndex < (bannerData?.data?.length ?? 0)) {
        //       updatedList.add(
        //         TitleDatum(
        //           title: 'Banner Ad',
        //           data: [
        //             CategoryData(
        //               name: bannerData!.data![bannerIndex].name,
        //               contentId: bannerData!.data![bannerIndex].contentId,
        //               content: bannerData!.data![bannerIndex].content,
        //               imageUrl: bannerData!.data![bannerIndex].imageUrl,
        //             ),
        //           ],
        //           isBanner: true,
        //         ),
        //       );
        //       bannerIndex++;

        //       if (bannerIndex >= bannerData!.data!.length) {
        //         bannerIndex = 0;
        //       }
        //     }
        //   }

        //   categoryList = updatedList;
      }

      showLog('categoryList categoryList categoryList ${categoryList.length}');
      // }
    }, failure: (NetworkExceptions error) {
      exploreListState.isLoading = false;
      notifyListeners();
      String errorMsg = NetworkExceptions.getErrorMessage(error);

      showMessageDialog(context, errorMsg, null);
    });
    exploreListState.isLoading = false;

    notifyListeners();
  }

  Future<void> postInteraction({
    required BuildContext context,
    String? contentId,
    String? searchTerm,
  }) async {
    ApiResult<GetUserInteractionResponse>? apiResult = await interactionService
        .postInteraction(
            actionType: [InteractionActionType.search],
            contentId: contentId ?? "",
            searchTerm: searchTerm);

    apiResult?.when(
      success: (data) async {
        log("Interaction Response: $data");
      },
      failure: (NetworkExceptions error) {
        String errorMsg = NetworkExceptions.getErrorMessage(error);
        showMessageDialog(context, errorMsg, null);
      },
    );
  }

  int currentViewAllPage = 1;
  bool hasMoreData = true; // Check if more data is available

  UIState<GetHomeViewAllModel> getHomeViewAllState =
      UIState<GetHomeViewAllModel>();
  List<HomeViewAllData> homeViewAllDataList = [];

  Future<void> getHomeViewAllAPI({
    String? search,
    required String type,
    bool isLoadMore = false,
  }) async {
    // Prevent multiple API calls

    if (getHomeViewAllState.isLoading) return;

    // Set loading state
    if (isLoadMore) {
      getHomeViewAllState.isLoadMore = true;
    } else {
      getHomeViewAllState.isLoading = true;
      getHomeViewAllState.success = null; // Reset for fresh data
      currentViewAllPage = 1;
      homeViewAllDataList.clear();
    }
    notifyListeners();

    // API call
    ApiResult response = await searchRepository.getHomeViewAllAPI(
        type: type, page: "$currentViewAllPage", search: search);

    response.when(
      // success: (data) {
      //   getHomeViewAllState.success = data;
      //   getHomeViewAllState.isLoading = false;
      //   getHomeViewAllState.isLoadMore = false;
      //
      //   log('Data received: ${data.data?.results?.length} items');
      //
      //   if (data.data?.results?.isNotEmpty ?? false) {
      //     if (!isLoadMore) {
      //       homeViewAllDataList.clear(); // Clear only for new searches
      //     }
      //
      //     /// **Prevent Duplicate Entries**
      //     final newItems = data.data!.results!
      //         .where((newItem) => !homeViewAllDataList.any((existingItem) =>
      //             existingItem.contentId ==
      //             newItem.contentId)) // Check for duplicates
      //         .toList();
      //
      //     homeViewAllDataList.addAll(newItems);
      //
      //     currentViewAllPage++; // Increase page number
      //     hasMoreData = newItems.isNotEmpty; // Check if more data exists
      //   } else {
      //     hasMoreData = false; // No more data
      //   }
      //
      //   // Notify UI
      //   notifyListeners();
      // },
      success: (data) {
        getHomeViewAllState.success = data;
        getHomeViewAllState.isLoading = false;
        getHomeViewAllState.isLoadMore = false;

        final results = data.data?.results ?? [];
        final totalPages = data.data?.totalPages ?? 1;

        log('Data received: ${results.length} items');

        if (results.isNotEmpty) {
          if (!isLoadMore) homeViewAllDataList.clear();

          final newItems = results
              .where((newItem) => !homeViewAllDataList.any((existingItem) =>
                  existingItem.contentId == newItem.contentId))
              .toList();

          homeViewAllDataList.addAll(newItems);
          if (currentViewAllPage < totalPages) {
            currentViewAllPage++;
            hasMoreData = true;
          } else {
            hasMoreData = false;
          }
        } else {
          hasMoreData = false;
        }

        notifyListeners();
      },
      failure: (NetworkExceptions error) {
        getHomeViewAllState.isLoading = false;
        getHomeViewAllState.isLoadMore = false;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  Timer? debounce;

  UIState<GetSearchResponse> searchState = UIState<GetSearchResponse>();
  List<GetSearchRecentSearch> recentSearches = [];
  List<GetSearchData> filteredMovies = [];
  List<GetSearchData> filteredWebseries = [];

  Future<void> getSearchAPI(BuildContext context,
      {required String search}) async {
    searchState.isLoading = true;
    notifyListeners();

    ApiResult response = await searchRepository.getSearchAPI(search: search);
    response.when(success: (data) {
      searchState.success = data;
      final searchData = searchState.success?.data;
      recentSearches = searchData?.recentSearches ?? [];
      filteredMovies = searchData?.movies ?? [];
      filteredWebseries = searchData?.webseries ?? [];

      searchState.isLoading = false;
      notifyListeners();
    }, failure: (NetworkExceptions error) {
      searchState.isLoading = false;
      notifyListeners();
      String errorMsg = NetworkExceptions.getErrorMessage(error);
      showMessageDialog(context, errorMsg, null);
    });
  }

  void updateUi() {
    notifyListeners();
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      filteredMovies.clear();
      filteredMovies = searchState.success?.data?.movies ?? [];
      filteredWebseries.clear();
      filteredWebseries = searchState.success?.data?.webseries ?? [];

      notifyListeners();
    } else {
      filteredMovies = filteredMovies
          .where((item) =>
              item.name?.toLowerCase().contains(query.toLowerCase()) == true)
          .toList();

      filteredWebseries = filteredWebseries
          .where((item) =>
              item.name?.toLowerCase().contains(query.toLowerCase()) == true)
          .toList();
    }
    notifyListeners();
  }

  void addSearch(String query) {
    if (query.isNotEmpty) {
      if (recentSearches.contains(GetSearchRecentSearch(searchTerm: query))) {
        recentSearches.removeWhere((item) => item.searchTerm == query);
      }

      recentSearches.insert(0, GetSearchRecentSearch(searchTerm: query));

      // Persist recent searches (Use SharedPreferences or Hive)
      notifyListeners();
    }
  }

  void removeSearch(String query) {
    recentSearches.removeWhere((item) => item.searchTerm == query);
    notifyListeners();
  }

  void searchFromRecent(BuildContext context, String query) {
    // searchController.text = query;
    // searchText = query;
    getSearchAPI(context, search: query);
    notifyListeners();
  }
}
