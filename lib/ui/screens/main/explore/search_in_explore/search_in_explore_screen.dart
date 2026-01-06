import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/values/strings.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/core/widgets/common_image_view.dart';
import 'package:vista_flicks/core/widgets/custom_text_form_field.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';
import 'package:vista_flicks/framework/controller/main/explore/explore_controller.dart';
import 'package:vista_flicks/framework/utils/extension/context_extension.dart';
import 'package:vista_flicks/gen/assets.gen.dart';
import 'package:vista_flicks/ui/routing/navigation_stack_item.dart';
import 'package:vista_flicks/ui/routing/stack.dart';
import 'package:vista_flicks/ui/screens/main/bookmark/helper/all_book_mark_shimmer.dart';
import 'package:vista_flicks/ui/screens/main/explore/search_in_explore/Model/get_search_response.dart';

class SearchInExploreScreen extends ConsumerWidget {
  const SearchInExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchInExploreScreen = ref.watch(exploreController);
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getVerticalHeight(50.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getWidth(16.w)),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      onSaved: (value) {
                        searchInExploreScreen.addSearch(value ?? '');
                        searchInExploreScreen.getSearchAPI(context,
                            search: value ?? '');
                      },
                      contentPadding: EdgeInsets.symmetric(
                          vertical: getHeight(12.h),
                          horizontal: getWidth(15.w)),
                      radius: 10.r,
                      fillColor: AppColors.lightGray1,
                      hintText: AppStrings.searchByMovieActorDirector,
                      controller: searchInExploreScreen.searchController,
                      onChanged: (query) {
                        if (searchInExploreScreen.debounce?.isActive ?? false) {
                          searchInExploreScreen.debounce!.cancel();
                        }

                        searchInExploreScreen.debounce =
                            Timer(const Duration(milliseconds: 1000), () {
                          final trimmedQuery = query.trim();

                          if (trimmedQuery.isEmpty) {
                            searchInExploreScreen.filteredMovies.clear();
                            searchInExploreScreen.filteredWebseries.clear();
                            searchInExploreScreen.updateUi();
                          } else {
                            searchInExploreScreen.getSearchAPI(context,
                                search: trimmedQuery);
                          }
                        });
                      },
                      prefix: Icon(Icons.search, color: AppColors.primeryTxt),
                    ),
                  ),
                  getHorizonatlWidth(10),
                  GestureDetector(
                    onTap: () {
                      final query =
                          searchInExploreScreen.searchController.text.trim();
                      if (query.isNotEmpty) {
                        print("Querty =======>$query");
                        searchInExploreScreen.onSearchChanged(query);
                        searchInExploreScreen.getSearchAPI(context,
                            search: query);
                      }
                    },
                    child: MyRegularText(
                      "Search",
                      style:
                          BaseTextStyle.buttonS.copyWith(color: AppColors.red),
                    ),
                  ),
                ],
              ),
            ),
            // getVerticalHeight(10),
            Consumer(
              builder: (context, ref, child) {
                final query =
                    searchInExploreScreen.searchController.text.trim();
                return query.isNotEmpty
                    ? _buildMoviesTab(context, ref)
                    // _buildSearchResults(ref)
                    : _buildRecentSearches(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(WidgetRef ref) {
    final searchInExploreScreen = ref.watch(exploreController);
    return DefaultTabController(
      length: 2, // Ensure this matches the number of tabs
      child: Builder(
        builder: (context) {
          TabController tabController = DefaultTabController.of(context);
          return searchInExploreScreen.searchState.isLoading
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50.h),
                    child: CircularProgressIndicator(
                      color: AppColors.red,
                    ),
                  ),
                )
              : searchInExploreScreen.filteredMovies.isEmpty &&
                      searchInExploreScreen.filteredWebseries.isEmpty
                  ? Center(child: MyRegularText("No results found"))
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          TabBar(
                            controller: tabController,
                            labelColor: AppColors.primeryTxt,
                            labelStyle: BaseTextStyle.lableM,
                            unselectedLabelColor: AppColors.secondaryTxt,
                            indicatorColor: tabController.index == 0
                                ? AppColors.red
                                : AppColors.red,
                            dividerColor: AppColors.border,
                            indicatorSize: TabBarIndicatorSize.tab,
                            // indicator: UnderlineTabIndicator(
                            //     // borderSide: BorderSide(
                            //     //     width: 3.0,
                            //     //     color:
                            //     //         AppColors.placeholder), // Selected tab indicator
                            //     ),
                            tabs: const [
                              Tab(text: "Movies"),
                              Tab(text: "Web Series"),
                            ],
                          ),
                          SizedBox(
                            height: context.height * .8,
                            child: TabBarView(
                              children: [
                                _buildMoviesTab(context, ref),
                                _buildSeriesTab(context, ref),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
        },
      ),
    );
  }

  Widget _buildRecentSearches(BuildContext context, WidgetRef ref) {
    final searchInExploreScreen = ref.watch(exploreController);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getWidth(16.w)),
      child: Column(
        crossAxisAlignment: searchInExploreScreen.recentSearches.isNotEmpty
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          MyRegularText(
            searchInExploreScreen.recentSearches.isNotEmpty
                ? 'Recent Search'
                : 'No Recent Search',
            style: BaseTextStyle.lableM.copyWith(color: AppColors.secondaryTxt),
          ),
          ListView.builder(
            padding: EdgeInsets.symmetric(vertical: getHeight(10.h)),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: searchInExploreScreen.recentSearches.length,
            itemBuilder: (context, index) {
              final search =
                  searchInExploreScreen.recentSearches[index].searchTerm;
              return Padding(
                padding: EdgeInsets.symmetric(vertical: getHeight(12.h)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        searchInExploreScreen.searchController.text =
                            search ?? "";
                        searchInExploreScreen.searchFromRecent(
                            context, search ?? "");
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(Assets.icons.tablerIconHistory,
                              color: AppColors.secondaryTxt),
                          getHorizonatlWidth(10),
                          MyRegularText(search ?? "",
                              style: BaseTextStyle.textS),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        searchInExploreScreen.removeSearch(search ?? "");
                      },
                      child: SvgPicture.asset(Assets.icons.tablerIconXSmall,
                          color: AppColors.secondaryTxt),
                    ),
                  ],
                ),
              );
            },
          ),
          getVerticalHeight(10),
          searchInExploreScreen.searchState.isLoading
              ? Shimmer.fromColors(
                  baseColor: (AppColors.lightGray2).withOpacity(0.2),
                  highlightColor: AppColors.lightGray2,
                  child: CommonImageView(
                    fit: BoxFit.contain,
                    imagePath: Assets.images.banner.path,
                  ),
                )
              : searchInExploreScreen.searchState.success?.data?.searchAdsBanner
                          ?.bannerImage?.isNotEmpty ==
                      true
                  ? CommonImageView(
                      height: 82.h,
                      width: context.width,
                      url: searchInExploreScreen.searchState.success?.data
                              ?.searchAdsBanner?.bannerImage ??
                          "",
                    )
                  : SizedBox()
        ],
      ),
    );
  }

  Widget _buildMoviesTab(BuildContext context, WidgetRef ref) {
    final searchInExploreScreen = ref.watch(exploreController);

    if (searchInExploreScreen.searchState.isLoading) {
      return AllBookMarkShimmer(color: AppColors.lightGray2);
    }

    // Check if no reels are available
    List<Reel> allReels = [];
    allReels.addAll(searchInExploreScreen.filteredMovies
        .expand((movie) => movie.reels!)
        .toList());
    allReels.addAll(searchInExploreScreen.filteredWebseries
        .expand((movie) => movie.reels!)
        .toList());

    if (allReels.isEmpty) {
      return SizedBox(
        height: context.height / 2.5,
        width: context.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
                height: getHeight(150.h),
                width: getWidth(150.w),
                fit: BoxFit.fitWidth,
                Assets.lottie.dataNotFound2),
            Text(
              "No Reels Found",
              style: BaseTextStyle.textMl,
            )
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.symmetric(
          vertical: getHeight(10.h), horizontal: getWidth(16.w)),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
      ),
      shrinkWrap: true,
      itemCount: allReels.length,
      itemBuilder: (context, index) {
        final reel = allReels[index];

        return Padding(
          padding: const EdgeInsets.all(3),
          child: GestureDetector(
            onTap: () {
              // ref.read(navigationStackController).push(
              //       NavigationStackItem.detail(contentId: reel.contentId ?? ""),
              //     );
              ref.read(navigationStackController).push(NavigationStackItem.reel(
                  contentId: allReels[index].contentId ?? "",
                  reelId: allReels[index].id));
              // searchInExploreScreen.postInteraction(
              //   context: context,
              //   contentId: reel.contentId ?? "",
              //   searchTerm: searchInExploreScreen.searchController.text,
              // );
            },
            child: CommonImageView(
              radius: 6.r,
              height: getHeight(147.h),
              width: getWidth(114.w),
              fit: BoxFit.cover,
              url: reel.thumbnailUrl ?? "",
            ),
          ),
        );
      },
    );
  }

  Widget _buildSeriesTab(BuildContext context, WidgetRef ref) {
    final searchInExploreScreen = ref.watch(exploreController);

    // Check if no reels are available
    List<Reel> allReels = searchInExploreScreen.filteredWebseries
        .expand((movie) => movie.reels!)
        .toList();
    if (allReels.isEmpty) {
      return Center(child: MyRegularText("No series found"));
    }
    return GridView.builder(
      padding: EdgeInsets.symmetric(vertical: getHeight(10.h)),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 0.7),
      // itemCount: series.length,
      itemCount: allReels.length,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.all(3),
        child: GestureDetector(
          onTap: () {
            ref.read(navigationStackController).push(NavigationStackItem.reel(
                contentId: allReels[index].contentId ?? "",
                reelId: allReels[index].id));
            // searchInExploreScreen.postInteraction(
            //   context: context,
            //   contentId: allReels.contentId ?? "",
            //   searchTerm: searchInExploreScreen.searchController.text,
            // );
          },
          child: CommonImageView(
            // color: Colors.white,
            fit: BoxFit.cover,
            radius: 6.r,
            height: getHeight(147.h),
            width: getWidth(114.w),
            url: searchInExploreScreen.filteredWebseries[index].imageUrl ?? "",
            // imagePath: Assets.images.frame1195.path,
          ),
        ),
      ),
    );
  }
}
