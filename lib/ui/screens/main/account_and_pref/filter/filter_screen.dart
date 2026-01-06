import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/values/strings.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/core/widgets/common_bg_container.dart';
import 'package:vista_flicks/core/widgets/custom_button.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';
import 'package:vista_flicks/framework/controller/main/account_and_pref/filter/filter_controller.dart';
import 'package:vista_flicks/framework/controller/main/reel/reels_controller.dart';
import 'package:vista_flicks/framework/repository/preferences/model/get_preferences_response_model.dart';
import 'package:vista_flicks/framework/utils/extension/extension.dart';
import 'package:vista_flicks/gen/assets.gen.dart';
import 'package:vista_flicks/ui/utils/const/app_constants.dart';
import 'package:vista_flicks/ui/utils/const/app_enums.dart';
import 'package:vista_flicks/ui/utils/widgets/dialog_progressbar.dart';

class FilterScreen extends ConsumerStatefulWidget {
  final String type;

  const FilterScreen({super.key, required this.type});

  @override
  ConsumerState<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends ConsumerState<FilterScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final filerScreenWatch = ref.read(filterController);
      filerScreenWatch.getAllPreferences(context, ref: ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filterWatch = ref.watch(filterController);
    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.black.withOpacity(0.2),
            appBar: AppBar(
              backgroundColor: AppColors.black,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              centerTitle: true,
              foregroundColor: AppColors.primeryTxt,
              title: MyRegularText("Filters"),
              actions: [
                TextButton(
                  onPressed: () {
                    filterWatch.clearAllFilters();
                  },
                  child: MyRegularText("Clear All", color: Colors.white),
                ),
              ],
            ),
            bottomNavigationBar:
                // filterWatch.isFilterUpdated() ?
                CustomButton(
              text: AppStrings.update,
              color: filterWatch.isFilterUpdated()
                  ? AppColors.red
                  : AppColors.lightGray1,
              isLoading: filterWatch.updatePreferenceState.isLoading,
              fun: () async {
                if (filterWatch.isFilterUpdated()) {
                  await filterWatch.updatePreferencesAPI(
                      isFromFilter: false, context, ref: ref);
                  // Navigator.pop(context);
                  final reelScreenWatch = ref.watch(reelsController);
                  reelScreenWatch.currentPage = 1;
                  reelScreenWatch.currentIndex = 0;
                  await reelScreenWatch.getReels(context, ref: ref).then(
                    (value) {
                      Future.delayed(
                        Duration(milliseconds: 500),
                        () {
                          if (reelScreenWatch.pageController.hasClients) {
                            reelScreenWatch.pageController.jumpTo(0);
                          }
                        },
                      );
                    },
                  );
                  reelScreenWatch.pageStorageKey = PageStorageKey<int>(0);
                } else {
                  print("Need to tap");
                }
              },
            ).paddingLTRB(getWidth(16.w), getHeight(5.h), getWidth(16.w),
                    getHeight(15.h)),
            // : const SizedBox(),
            body: CommonBgContainer(
              padding: EdgeInsets.all(0),
              boxDecoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  AppColors.transparent,
                  AppColors.black,
                  AppColors.black,
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        // color: AppColors.transparent,
                        border: Border(
                          right: BorderSide(color: AppColors.border),
                        ),
                      ),
                      child: ListView.builder(
                        itemCount: filterWatch.filterCategories.length,
                        itemBuilder: (context, index) {
                          final category = filterWatch.filterCategories[index];
                          return GestureDetector(
                            onTap: () {
                              filterWatch.updateSelectedCategory(
                                  getFilterType(category), context, ref);
                              filterWatch.updateWidget();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: getHeight(15),
                                  horizontal: getWidth(10)),
                              decoration: BoxDecoration(
                                color: filterWatch.selectedCategory == category
                                    ? AppColors.lightGray1
                                    : AppColors.transparent,
                                border: Border(
                                  bottom: BorderSide(color: AppColors.border),
                                ),
                              ),
                              child: category == FilterType.imdbRating
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                                width: getWidth(36),
                                                Assets.images.imdb),
                                            getHorizonatlWidth(getWidth(3)),
                                            MyRegularText(
                                              getFilterType(category),
                                              style: BaseTextStyle.lableS.copyWith(
                                                  color: filterWatch
                                                              .selectedCategory ==
                                                          category
                                                      ? AppColors.primeryTxt
                                                      : AppColors.secondaryTxt),
                                            ),
                                          ],
                                        ),
                                        // filterWatch.isFilterUpdated()
                                        //     ? Container(
                                        //         height: 3.h,
                                        //         width: 3.w,
                                        //         color: AppColors.red,
                                        //       )
                                        //     : SizedBox.shrink()
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        MyRegularText(
                                          getFilterType(category),
                                          style: BaseTextStyle.lableS.copyWith(
                                              color: filterWatch
                                                          .selectedCategory ==
                                                      category
                                                  ? AppColors.primeryTxt
                                                  : AppColors.secondaryTxt),
                                        ),
                                        // filterWatch.isFilterUpdated()
                                        //     ? Container(
                                        //         height: 3.h,
                                        //         width: 3.w,
                                        //         color: AppColors.red,
                                        //       )
                                        //     : SizedBox.shrink()
                                      ],
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: SingleChildScrollView(
                      child: Container(
                        // height: context.height,
                        padding: EdgeInsets.all(0),
                        child: Consumer(
                          builder: (context, ref, child) {
                            if (filterWatch.selectedCategory ==
                                FilterType.ottPlatforms) {
                              return GridView.builder(
                                padding: EdgeInsets.all(10),
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 0.8,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemCount: filterWatch.preferencesList.length,
                                itemBuilder: (context, index) {
                                  PreferenceResult preferenceResult =
                                      filterWatch.preferencesList[index];
                                  return GestureDetector(
                                    onTap: () {
                                      filterWatch.preferencesList[index]
                                          .isPreferred = !(filterWatch
                                              .preferencesList[index]
                                              .isPreferred ??
                                          false);
                                      filterWatch
                                          .updateIsPreferredInMainListWidget(
                                              index);
                                    },
                                    child: Column(
                                      children: [
                                        filterWatch.preferencesList[index]
                                                    .icon !=
                                                null
                                            ? Container(
                                                height: getHeight((filterWatch
                                                            .preferencesList[
                                                                index]
                                                            .isPreferred ??
                                                        false)
                                                    ? 60.h
                                                    : 50.h),
                                                width: getWidth((filterWatch
                                                            .preferencesList[
                                                                index]
                                                            .isPreferred ??
                                                        false)
                                                    ? 60.w
                                                    : 50.w),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: (filterWatch
                                                                  .preferencesList[
                                                                      index]
                                                                  .isPreferred ??
                                                              false)
                                                          ? AppColors.red
                                                          : Colors.transparent,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        filterWatch
                                                            .preferencesList[
                                                                index]
                                                            .icon),
                                                  ),
                                                ),
                                              )
                                            : SizedBox(
                                                height: getHeight(50),
                                                width: getWidth(50),
                                              ),
                                        MyRegularText(
                                          preferenceResult.name ?? '',
                                          style: BaseTextStyle.lableXs,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            } else if (filterWatch.selectedCategory ==
                                FilterType.imdbRating) {
                              return ListView.separated(
                                separatorBuilder: (context, index) {
                                  return Container(
                                    height: 1.h,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom:
                                            BorderSide(color: AppColors.border),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: filterWatch.preferencesList.length,
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsets.all(0),
                                itemBuilder: (context, index) {
                                  PreferenceResult rating =
                                      filterWatch.preferencesList[index];
                                  return GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      filterWatch.preferencesList[index]
                                          .isPreferred = !(filterWatch
                                              .preferencesList[index]
                                              .isPreferred ??
                                          false);
                                      filterWatch
                                          .updateIsPreferredInMainListWidget(
                                              index);
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: getHeight(15),
                                              horizontal: getWidth(10)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    Assets.icons
                                                        .tablerIconStarFilled,
                                                    color: Color(0xffE6B91E),
                                                  ),
                                                  getHorizonatlWidth(5),
                                                  MyRegularText(
                                                    "${rating.minImdbRating ?? 0} - ${rating.maxImdbRating ?? 0}",
                                                    style: BaseTextStyle.lableS
                                                        .copyWith(
                                                      fontSize: (filterWatch
                                                                  .preferencesList[
                                                                      index]
                                                                  .isPreferred ??
                                                              false)
                                                          ? 16
                                                          : 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              getVerticalHeight(5),
                                              MyRegularText(
                                                rating.name ?? "N/A",
                                                style: BaseTextStyle.textXs
                                                    .copyWith(
                                                        color: AppColors
                                                            .secondaryTxt),
                                              )
                                            ],
                                          ),
                                        ),
                                        Checkbox(
                                          side: BorderSide.none,
                                          fillColor: WidgetStatePropertyAll(
                                              (filterWatch
                                                          .preferencesList[
                                                              index]
                                                          .isPreferred ??
                                                      false)
                                                  ? AppColors.red
                                                  : AppColors.placeholder),
                                          checkColor: AppColors.black,
                                          value: filterWatch
                                                  .preferencesList[index]
                                                  .isPreferred ??
                                              false,
                                          onChanged: (bool? value) {
                                            filterWatch.preferencesList[index]
                                                .isPreferred = !(filterWatch
                                                    .preferencesList[index]
                                                    .isPreferred ??
                                                false);
                                            filterWatch
                                                .updateIsPreferredInMainListWidget(
                                                    index);
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            } else if (filterWatch.selectedCategory ==
                                FilterType.ageRating) {
                              return ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: filterWatch.preferencesList.length,
                                itemBuilder: (context, index) {
                                  PreferenceResult ageRating =
                                      filterWatch.preferencesList[index];
                                  return GestureDetector(
                                    onTap: () {
                                      filterWatch.preferencesList[index]
                                          .isPreferred = !(filterWatch
                                              .preferencesList[index]
                                              .isPreferred ??
                                          false);
                                      filterWatch
                                          .updateIsPreferredInMainListWidget(
                                              index);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: AppColors.border),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 10),
                                            child: SizedBox(
                                              width: getWidth(170),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  MyRegularText(
                                                    ageRating.name ?? '',
                                                    style: BaseTextStyle.lableS.copyWith(
                                                        fontSize: (filterWatch
                                                                    .preferencesList[
                                                                        index]
                                                                    .isPreferred ??
                                                                false)
                                                            ? 16
                                                            : 14),
                                                  ),
                                                  getVerticalHeight(5),
                                                  MyRegularText(
                                                    ageRating.description ??
                                                        "N/A",
                                                    style: BaseTextStyle.textXs
                                                        .copyWith(
                                                            color: AppColors
                                                                .secondaryTxt),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Checkbox(
                                            side: BorderSide.none,
                                            fillColor: WidgetStatePropertyAll(
                                                (filterWatch
                                                            .preferencesList[
                                                                index]
                                                            .isPreferred ??
                                                        false)
                                                    ? AppColors.red
                                                    : AppColors.placeholder),
                                            checkColor: AppColors.black,
                                            value: filterWatch
                                                    .preferencesList[index]
                                                    .isPreferred ??
                                                false,
                                            onChanged: (bool? value) {
                                              filterWatch.preferencesList[index]
                                                  .isPreferred = !(filterWatch
                                                      .preferencesList[index]
                                                      .isPreferred ??
                                                  false);
                                              filterWatch
                                                  .updateIsPreferredInMainListWidget(
                                                      index);
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Padding(
                                padding: EdgeInsets.all(10),
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    ...List.generate(
                                      filterWatch.preferencesList.length,
                                      (index) {
                                        return GestureDetector(
                                          onTap: () {
                                            filterWatch.preferencesList[index]
                                                .isPreferred = !(filterWatch
                                                    .preferencesList[index]
                                                    .isPreferred ??
                                                false);
                                            showLog(
                                                'filterWatch.preferencesList[index].isPreferred ${filterWatch.preferencesList[index].isPreferred}');
                                            filterWatch
                                                .updateIsPreferredInMainListWidget(
                                                    index);
                                            filterWatch.updateWidget();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.black
                                                  .withOpacity(.5),
                                              border: Border.all(
                                                color: (filterWatch
                                                            .preferencesList[
                                                                index]
                                                            .isPreferred ??
                                                        false)
                                                    ? AppColors.red
                                                    : AppColors.primeryTxt
                                                        .withOpacity(.2),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 12),
                                            child: MyRegularText(
                                              filterWatch.preferencesList[index]
                                                      .name
                                                      ?.capitalizeFirst() ??
                                                  '',
                                              style:
                                                  BaseTextStyle.textS.copyWith(
                                                color: AppColors.primeryTxt,
                                                fontSize: (filterWatch
                                                            .preferencesList[
                                                                index]
                                                            .isPreferred ??
                                                        false)
                                                    ? 16
                                                    : 14,
                                              ),
                                              maxLines: 4,
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        DialogProgressBar(isLoading: filterWatch.getPreferenceState.isLoading)
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:vista_flicks/pages/main/account_and_pref/filter/filter_controller.dart';
//
// import '../../../../core/values/app_colours.dart';
// import '../../../../core/values/text_styles/base_textstyle.dart';
// import '../../../../core/widgets/my_regular_text.dart';
//
// class FilterPage extends GetView<FilterController> {
//   const FilterPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final List<String> filterCategories = [
//       "Genre",
//       "Language",
//       "Subtitles",
//       "Content Type",
//       "OTT Platforms",
//       "Region",
//       "Ratings",
//       "Age Rating",
//     ];
//
//     final Map<String, List<String>> filterOptions = {
//       "Genre": [
//         "Comedy",
//         "Action",
//         "Horror",
//         "Animation",
//         "Romance",
//         "Sci-Fi",
//         "Thriller",
//         "Documentary",
//       ],
//       "Language": [
//         "English",
//         "Hindi",
//         "Gujarati",
//         "Telugu",
//         "Korean",
//         "Malyalam",
//         "Marathi",
//         "Spanish",
//       ],
//       "Subtitles": [
//         "English",
//         "Hindi",
//         "Gujarati",
//         "Telugu",
//         "Korean",
//         "Malyalam",
//         "Marathi",
//         "Spanish",
//       ],
//       "Content Type": [
//         "Movies",
//         "Web Series",
//         "Documentary",
//       ],
//       "OTT Platforms": ["Netflix", "Amazon Prime", "Disney+"],
//       "Region": [
//         "Hollywood",
//         "Bollywood",
//         "Japanese",
//         "Korean",
//         "French",
//         "Tollywood",
//         "German",
//         "Kollywood",
//       ],
//       "Ratings": ["5 Star", "4 Star", "3 Star"],
//       "Age Rating": ["All", "13+", "18+"]
//     };
//
//     RxString selectedCategory = filterCategories.first.obs;
//     RxSet<String> selectedChips = <String>{}.obs;
//
//     return Scaffold(
//       backgroundColor: AppColors.black.withOpacity(0.2),
//       appBar: AppBar(
//         backgroundColor: AppColors.black,
//         foregroundColor: Colors.white,
//         systemOverlayStyle: SystemUiOverlayStyle.light,
//         centerTitle: true,
//         title: MyRegularText("Filters"),
//         actions: [
//           TextButton(
//             onPressed: () => selectedChips.clear(),
//             child: MyRegularText("Clear All", color: Colors.white),
//           ),
//         ],
//       ),
//       body: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Container(
//               decoration: BoxDecoration(
//                   color: AppColors.transparent,
//                   border: Border(right: BorderSide(color: AppColors.border))),
//               child: ListView.builder(
//                 itemCount: filterCategories.length,
//                 itemBuilder: (context, index) {
//                   final category = filterCategories[index];
//                   return Obx(() => ListTile(
//                         shape: Border.all(color: AppColors.border),
//                         title: MyRegularText(category,
//                             color: selectedCategory.value == category
//                                 ? AppColors.primeryTxt
//                                 : AppColors.secondaryTxt),
//                         tileColor: selectedCategory.value == category
//                             ? AppColors.lightGray1
//                             : Colors.transparent,
//                         onTap: () => selectedCategory.value = category,
//                       ));
//                 },
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 4,
//             child: Container(
//               color: AppColors.red.withOpacity(0.1),
//               padding: EdgeInsets.all(10),
//               child: Obx(() {
//                 final options = filterOptions[selectedCategory.value] ?? [];
//                 return Column(
//                   children: [
//                     Wrap(
//                       spacing: 8.0,
//                       children: options.map((option) {
//                         return Obx(() => GestureDetector(
//                               onTap: () {
//                                 if (selectedChips.contains(option)) {
//                                   selectedChips.remove(option);
//                                 } else {
//                                   selectedChips.add(option);
//                                 }
//                               },
//                               child: Container(
//                                 margin: EdgeInsets.all(5),
//                                 decoration: BoxDecoration(
//                                   color: AppColors.black.withOpacity(.5),
//                                   border: Border.all(
//                                     color: selectedChips.contains(option)
//                                         ? AppColors.red
//                                         : AppColors.primeryTxt.withOpacity(.2),
//                                   ),
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 16, vertical: 12),
//                                 child: MyRegularText(
//                                   option,
//                                   style: BaseTextStyle.textS.copyWith(
//                                     color: AppColors.primeryTxt,
//                                   ),
//                                 ),
//                               ),
//                             ));
//                       }).toList(),
//                     ),
//                   ],
//                 );
//               }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
