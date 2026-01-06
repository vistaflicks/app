import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/core/widgets/common_image_view.dart';
import 'package:vista_flicks/core/widgets/custom_button.dart';
import 'package:vista_flicks/framework/utils/extension/context_extension.dart';
import 'package:vista_flicks/framework/utils/extension/extension.dart';
import 'package:vista_flicks/framework/utils/local_storage/session.dart';
import 'package:vista_flicks/ui/utils/helper/base_widget.dart';
import 'package:vista_flicks/ui/utils/widgets/common_button.dart';
import 'package:vista_flicks/ui/utils/widgets/common_dialogs.dart';

import '../../../../core/values/app_colours.dart';
import '../../../../core/values/size_constant.dart';
import '../../../../core/widgets/common_bg_container.dart';
import '../../../../framework/controller/auth/initial_watch_preferences/initial_watch_preferences_controller.dart';
import '../../../../framework/controller/main/account_and_pref/filter/filter_controller.dart';
import '../../../../framework/controller/main/reel/reels_controller.dart';
import '../../../../framework/provider/network/network.dart';
import '../../../../framework/repository/preferences/model/get_preferences_response_model.dart';
import '../../../../gen/assets.gen.dart';
import '../../../routing/navigation_stack_item.dart';
import '../../../routing/stack.dart';
import '../../../utils/const/app_enums.dart';

class InitialWatchPreferencesScreen extends ConsumerStatefulWidget {
  const InitialWatchPreferencesScreen({super.key});

  @override
  ConsumerState<InitialWatchPreferencesScreen> createState() =>
      _InitialWatchPreferencesScreenState();
}

class _InitialWatchPreferencesScreenState
    extends ConsumerState<InitialWatchPreferencesScreen>
    with BaseConsumerStatefulWidget {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final initialWatchPreferencesWatch =
          ref.watch(initialWatchPreferencesController);
      final filterWatch = ref.watch(filterController);
      filterWatch.genreList.every((e) => e.isPreferred == false);
      filterWatch.languageList.every((e) => e.isPreferred == false);
      filterWatch.subTitleLanguageList.every((e) => e.isPreferred == false);
      filterWatch.contentTypeList.every((e) => e.isPreferred == false);
      filterWatch.ottPlatformsList.every((e) => e.isPreferred == false);
      filterWatch.regionList.every((e) => e.isPreferred == false);

      filterWatch.imdbRatingList.every((e) => e.isPreferred == false);
      filterWatch.ageRatingList.every((e) => e.isPreferred == false);
      filterWatch.preferencesList.every((e) => e.isPreferred == false);

      // initialWatchPreferencesWatch.disposeController(isNotify: true);
      initialWatchPreferencesWatch.selectedApps.clear();
      initialWatchPreferencesWatch.selectedSubtitleLanguage.clear();
      initialWatchPreferencesWatch.selectedContentType.clear();
      initialWatchPreferencesWatch.selectedGenres.clear();
      initialWatchPreferencesWatch.selectedLanguages.clear();
      initialWatchPreferencesWatch.currentStep = 0;
    });
  }

  @override
  Widget buildPage(BuildContext context) {
    double commonBottomPadding = 70.h;
    double commonContainerHeight = 60.h;
    final initialWatchPreferencesWatch =
        ref.watch(initialWatchPreferencesController);
    final reelsWatch = ref.watch(reelsController);

    final filterWatch = ref.watch(filterController);
    void goToPage(int page) {
      initialWatchPreferencesWatch.pageController.animateToPage(
        page,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      initialWatchPreferencesWatch.currentStep = page;
      initialWatchPreferencesWatch.updateWidget();
    }

    return Scaffold(
      body: CommonBgContainer(
        child: Column(
          children: [
            SizedBox(height: 40), // Top padding for safe area
            ProgressBar(),
            Expanded(
              child: PageView.builder(
                controller: initialWatchPreferencesWatch.pageController,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 4,
                onPageChanged: (value) {
                  initialWatchPreferencesWatch.currentStep = value;
                },
                itemBuilder: (_, index) {
                  if (index == 0) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Lottie.asset(
                                height: getHeight(50.h),
                                Assets.lottie.animation1737368859751,
                              ),
                              getHorizonatlWidth(10.h),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Text(
                                        "Hey ${Session.userFirstName}, let's create your watch preference to help us suggest your favourite movies & shows.",
                                        style: BaseTextStyle.lableMl),
                                    getVerticalHeight(10.h),
                                    Text(
                                        "You can always update your watch preference from your profile.",
                                        style: BaseTextStyle.textM),
                                  ],
                                ),
                              ),
                            ],
                          ).paddingOnly(top: 40.h),
                          getVerticalHeight(10.h),
                          SafeArea(
                            child: Column(
                              children: [
                                Text("It won't take more than 2 mins, promise!",
                                    style: BaseTextStyle.textXs),
                                getVerticalHeight(10.h),
                                CommonButton(
                                  borderRadius: BorderRadius.circular(50),
                                  buttonTextStyle: BaseTextStyle.buttonM,
                                  buttonEnabledColor: AppColors.red,
                                  buttonText: "Let's Get Started",
                                  onTap: () async {
                                    await filterWatch.getPreferencesAPI(context,
                                        ref: ref, type: FilterType.genre.name);
                                    goToPage(1);
                                  },
                                ),
                                getVerticalHeight(10.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (index == 1) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                height: getHeight(50.h),
                                Assets.lottie.animation1737368859751,
                              ),
                              getHorizonatlWidth(10.h),
                              Expanded(
                                  child: Text("Choose your favorite genres",
                                      style: BaseTextStyle.lableMl)),
                            ],
                          ).paddingOnly(top: 30.h),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              crossAxisCount: 2,
                              childAspectRatio: 2.2,
                            ),
                            itemCount: filterWatch.genreList.length,
                            // padding: EdgeInsets.all(16),
                            itemBuilder: (context, index) {
                              final genre = filterWatch.genreList[index];

                              final imagePath = filterWatch.genreImageMap[
                                      genre.name?.toLowerCase() ?? ""] ??
                                  Assets.images.action; // Default fallback

                              final isSelected = initialWatchPreferencesWatch
                                  .selectedGenres
                                  .contains(genre);

                              return GestureDetector(
                                onTap: () {
                                  ref
                                      .read(initialWatchPreferencesController
                                          .notifier)
                                      .toggleGenre(genre);
                                },
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      height: commonContainerHeight,
                                      // padding: EdgeInsets.symmetric(
                                      //   horizontal: 16.w,
                                      // ),
                                      decoration: BoxDecoration(
                                        color: AppColors.black.withOpacity(0.6),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.red
                                              : AppColors.border
                                                  .withOpacity(0.5),
                                          width: 1.5,
                                        ),
                                        image: DecorationImage(
                                            image: AssetImage(
                                                imagePath.toString()),
                                            fit: BoxFit.cover),
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      child: Container(
                                        width: context.width,
                                        color: AppColors.black.withOpacity(0.1),
                                      ),
                                      // child: Align(
                                      //   alignment: Alignment.centerLeft,
                                      //   child: Padding(
                                      //     padding: EdgeInsets.symmetric(
                                      //       horizontal: 16.w,
                                      //     ),
                                      //     child: Text(
                                      //       genre.name?.capitalizeFirst() ?? "",
                                      //       style: BaseTextStyle.lableXs,
                                      //       textAlign: TextAlign.center,
                                      //     ),
                                      //   ),
                                      // ),
                                    ),
                                    // CommonImageView(
                                    //   imagePath: Assets.images.ayushman.path,
                                    // ),

                                    SizedBox(
                                      height: commonContainerHeight,
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.w, vertical: 8.h),
                                          child: Text(
                                            genre.name?.capitalizeFirst() ?? "",
                                            style: BaseTextStyle.lableS
                                                .copyWith(shadows: [
                                              Shadow(
                                                color: AppColors.lightGray2,
                                                blurRadius: 10,
                                                // offset: Offset(2, 0),
                                              )
                                            ]),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(height: commonBottomPadding),
                        ],
                      ),
                    );
                  } else if (index == 2) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Lottie.asset(
                                height: getHeight(50.h),
                                Assets.lottie.animation1737368859751,
                              ),
                              getHorizonatlWidth(10.h),
                              Expanded(
                                  child: Text(
                                      "Choose your preferred streaming apps",
                                      style: BaseTextStyle.lableMl)),
                            ],
                          ).paddingOnly(top: 30.h),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              // mainAxisSpacing: 30.h,
                              // crossAxisSpacing: 10,
                              crossAxisCount: 3,
                              childAspectRatio: .8,
                            ),
                            itemCount: filterWatch.ottPlatformsList.length,
                            // padding: EdgeInsets.all(16),
                            itemBuilder: (context, index) {
                              final app = filterWatch.ottPlatformsList;
                              PreferenceResult appName = app[index];
                              final appAsset = app[index].icon;
                              bool isSelected = initialWatchPreferencesWatch
                                  .selectedApps
                                  .contains(appName);

                              return GestureDetector(
                                onTap: () {
                                  ref
                                      .read(initialWatchPreferencesController
                                          .notifier)
                                      .toggleApp(appName);
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(200),
                                        border: Border.all(
                                          width: 2,
                                          color: isSelected
                                              ? AppColors.red
                                              : Colors.transparent,
                                        ),
                                      ),
                                      child: CommonImageView(
                                        fit: BoxFit.cover,
                                        width: 80.w,
                                        height: 80.h,
                                        borderRadius:
                                            BorderRadius.circular(200),
                                        url: appAsset,
                                      ),
                                    ),
                                    getVerticalHeight(10.h),
                                    Text(
                                      appName.name?.capitalizeFirst() ?? "",
                                      style: BaseTextStyle.lableXs,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(height: commonBottomPadding),
                        ],
                      ),
                    );
                    // final selectedOtts = ref.watch(
                    //     initialWatchPreferencesWatch.selectedOttsProvider);
                    // return buildSelectableGrid(
                    //   title: "Select OTT Platforms",
                    //   items: filterWatch.ottPlatformsList,
                    //   selectedItems: selectedOtts,
                    //   onSelect: (item) {
                    //     initialWatchPreferencesWatch.toggleApp(item);
                    //     final updated = [...selectedOtts];
                    //     updated.contains(item)
                    //         ? updated.remove(item)
                    //         : updated.add(item);
                    //     ref
                    //         .read(initialWatchPreferencesWatch
                    //             .selectedOttsProvider.notifier)
                    //         .state = updated;
                    //   },
                    //   onPrevious: () => goToPage(1),
                    //   onNext: () => goToPage(3),
                    // );
                  } else if (index == 3) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Lottie.asset(
                                height: getHeight(50.h),
                                Assets.lottie.animation1737368859751,
                              ),
                              getHorizonatlWidth(10.h),
                              Text("Pick your preferred language",
                                  style: BaseTextStyle.lableMl),
                            ],
                          ).paddingOnly(top: 30.h),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              crossAxisCount: 2,
                              childAspectRatio: 2.2,
                            ),
                            itemCount: filterWatch.languageList.length,
                            // padding: EdgeInsets.all(16),
                            itemBuilder: (context, index) {
                              final lang = filterWatch.languageList[index];
                              bool isSelected = initialWatchPreferencesWatch
                                  .selectedLanguages
                                  .contains(lang);

                              return GestureDetector(
                                onTap: () {
                                  ref
                                      .read(initialWatchPreferencesController
                                          .notifier)
                                      .toggleLanguage(lang);
                                },
                                child: Stack(
                                  clipBehavior: Clip.hardEdge,
                                  alignment: Alignment.centerRight,
                                  children: [
                                    Container(
                                      height: commonContainerHeight,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      decoration: BoxDecoration(
                                        color: AppColors.black.withOpacity(0.6),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.red
                                              : AppColors.border
                                                  .withOpacity(0.5),
                                          width: 1.5,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              lang.name?.capitalizeFirst() ??
                                                  "",
                                              style: BaseTextStyle.lableXs,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Positioned(
                                            right: -8.w,
                                            bottom: -15.h,
                                            child: Align(
                                              alignment: Alignment.bottomRight,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: 4.w, bottom: 4.h),
                                                child: Text(
                                                  filterWatch.languageAbMap[lang
                                                              .name
                                                              ?.toLowerCase() ??
                                                          ""] ??
                                                      "",
                                                  style: BaseTextStyle.lableXl
                                                      .copyWith(
                                                    color: AppColors.primeryTxt
                                                        .withOpacity(0.05),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(height: commonBottomPadding),
                        ],
                      ),
                    );
                    // final selectedLanguages = ref.watch(
                    //     initialWatchPreferencesWatch.selectedLanguagesProvider);
                    // return buildSelectableGrid(
                    //   title: "Select Languages",
                    //   items: filterWatch.languageList,
                    //   selectedItems: selectedLanguages,
                    //   onSelect: (item) {
                    //     initialWatchPreferencesWatch.toggleLanguage(item);
                    //     final updated = [...selectedLanguages];
                    //     updated.contains(item)
                    //         ? updated.remove(item)
                    //         : updated.add(item);
                    //     ref
                    //         .read(initialWatchPreferencesWatch
                    //             .selectedLanguagesProvider.notifier)
                    //         .state = updated;
                    //   },
                    //   onPrevious: () => goToPage(2),
                    //   onSubmit: () {
                    //     // Handle submission
                    //     showDialog(
                    //       context: context,
                    //       builder: (_) => AlertDialog(
                    //         content: Text("Submitted!"),
                    //       ),
                    //     );
                    //   },
                    // );
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Consumer(
        builder: (context, ref, child) => Container(
          width: double.maxFinite,
          // color: AppColors.black,
          padding: const EdgeInsets.all(8.0),
          child: initialWatchPreferencesWatch.currentStep == 1
              ? CustomButton(
                  isLoading: filterWatch.getPreferenceState.isLoading,
                  text: "Next",
                  fun: () async {
                    if (initialWatchPreferencesWatch.selectedGenres.isEmpty) {
                      showMessageDialog(
                          context, "Please Select at least one genre", null);

                      return;
                    }
                    await filterWatch.getPreferencesAPI(context,
                        ref: ref, type: FilterType.ottPlatforms.name);
                    goToPage(2);
                  },
                  // height: 120,
                )
              : initialWatchPreferencesWatch.currentStep == 2
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            initialWatchPreferencesWatch.currentStep = 1;
                            goToPage(1);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40.w, vertical: 13.h),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: AppColors.black.withOpacity(0.3)),
                            child: SvgPicture.asset(
                              Assets.icons.tablerIconArrowLeft,
                              color: AppColors.primeryTxt,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CustomButton(
                            isLoading: filterWatch.getPreferenceState.isLoading,
                            text: "Next",
                            fun: () async {
                              if (initialWatchPreferencesWatch
                                  .selectedApps.isEmpty) {
                                showMessageDialog(context,
                                    "Please Select at least one OTT App", null);

                                return;
                              }
                              // initialWatchPreferencesWatch.currentStep = 3;
                              await filterWatch.getPreferencesAPI(context,
                                  ref: ref, type: FilterType.language.name);
                              await filterWatch.getPreferencesAPI(context,
                                  ref: ref, type: FilterType.contentType.name);
                              initialWatchPreferencesWatch.currentStep = 3;

                              goToPage(3);
                            },
                            // height: 120,
                          ),
                        ),
                      ],
                    )
                  : initialWatchPreferencesWatch.currentStep == 3
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                initialWatchPreferencesWatch.currentStep = 2;
                                goToPage(2);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40.w, vertical: 13.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: AppColors.black.withOpacity(0.3)),
                                child: SvgPicture.asset(
                                  Assets.icons.tablerIconArrowLeft,
                                  color: AppColors.primeryTxt,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: CustomButton(
                                isLoading:
                                    filterWatch.updatePreferenceState.isLoading,
                                text: "Submit",
                                fun: () async {
                                  if (initialWatchPreferencesWatch
                                      .selectedLanguages.isEmpty) {
                                    showMessageDialog(
                                        context,
                                        "Please Select at least one Language",
                                        null);

                                    return;
                                  }
                                  for (var element
                                      in filterWatch.contentTypeList) {
                                    element.isPreferred = true;
                                  }
                                  for (var element
                                      in filterWatch.subTitleLanguageList) {
                                    element.isPreferred = true;
                                  }

                                  await filterWatch
                                      .updatePreferencesAPI(
                                          ref: ref,
                                          context,
                                          genre: initialWatchPreferencesWatch
                                              .selectedGenres,
                                          language: initialWatchPreferencesWatch
                                              .selectedLanguages,
                                          ott: initialWatchPreferencesWatch
                                              .selectedApps)
                                      .whenComplete(
                                    () {
                                      initialWatchPreferencesWatch.currentStep =
                                          0;
                                      ref
                                          .read(navigationStackController)
                                          .pushAndRemoveAll(
                                            NavigationStackItem.blank(),
                                          );
                                      reelsWatch.getReels(context, ref: ref);
                                    },
                                  );
                                },
                                // height: 120,
                              ),
                            )
                            // Expanded(
                            //   child: GestureDetector(
                            //     onTap: () async {
                            //       // if (initialWatchPreferencesWatch
                            //       //     .selectedLanguages.isEmpty) {
                            //       //   showMessageDialog(
                            //       //       context,
                            //       //       "Please Select at least one Language",
                            //       //       null);
                            //       //
                            //       //   return;
                            //       // }
                            //       // for (var element
                            //       //     in filterWatch.contentTypeList) {
                            //       //   element.isPreferred = true;
                            //       // }
                            //       // for (var element
                            //       //     in filterWatch.subTitleLanguageList) {
                            //       //   element.isPreferred = true;
                            //       // }
                            //       //
                            //       // await filterWatch
                            //       //     .updatePreferencesAPI(
                            //       //         ref: ref,
                            //       //         context,
                            //       //         genre: initialWatchPreferencesWatch
                            //       //             .selectedGenres,
                            //       //         language: initialWatchPreferencesWatch
                            //       //             .selectedLanguages,
                            //       //         ott: initialWatchPreferencesWatch
                            //       //             .selectedApps)
                            //       //     .whenComplete(
                            //       //   () {
                            //       //     initialWatchPreferencesWatch.currentStep =
                            //       //         0;
                            //       //     ref
                            //       //         .read(navigationStackController)
                            //       //         .pushAndRemoveAll(
                            //       //           NavigationStackItem.blank(),
                            //       //         );
                            //       //     reelsWatch.getReels(context, ref: ref);
                            //       //   },
                            //       // );
                            //     },
                            //     child: Container(
                            //       padding: EdgeInsets.symmetric(
                            //           horizontal: 20.w, vertical: 13.h),
                            //       decoration: BoxDecoration(
                            //         color: AppColors.red,
                            //         borderRadius: BorderRadius.circular(100),
                            //       ),
                            //       width: context.width * .6,
                            //       child: filterWatch
                            //               .updatePreferenceState.isLoading
                            //           ? SizedBox(
                            //               height: 20,
                            //               child: CircularProgressIndicator())
                            //           : Text(
                            //               "Submit",
                            //               textAlign: TextAlign.center,
                            //               style: BaseTextStyle.buttonM,
                            //             ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        )
                      : SizedBox.shrink(),
        ),
      ),
    );
  }

  //
  // @override
  // void initState() {
  //   super.initState();
  //   SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
  //     final initialWatchPreferencesWatch =
  //         ref.watch(initialWatchPreferencesController);
  //     initialWatchPreferencesWatch.disposeController(isNotify: true);
  //   });
  // }
  //
  // @override
  // Widget buildPage(BuildContext context) {
  //   return Scaffold(
  //     extendBodyBehindAppBar: true,
  //     appBar: AppBar(
  //       centerTitle: true,
  //       backgroundColor: AppColors.black.withOpacity(.5),
  //       foregroundColor: AppColors.primeryTxt,
  //       systemOverlayStyle: SystemUiOverlayStyle.light,
  //       // titleSpacing: 0,
  //       leading: SizedBox(),
  //       title: Stack(children: [
  //         Row(
  //           mainAxisSize: MainAxisSize.min,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             MyRegularText(
  //               "Flixy AI",
  //               style: BaseTextStyle.headerMl,
  //             ),
  //             getHorizonatlWidth(5),
  //             MyRegularText(
  //               "BETA",
  //               style: BaseTextStyle.headerMl
  //                   .copyWith(fontSize: 10, color: AppColors.red),
  //             ),
  //           ],
  //         ),
  //       ]),
  //     ),
  //     body: CommonBgContainer(
  //       child: ChatScreen(),
  //     ),
  //   );
  // }
}

class ProgressBar extends ConsumerWidget {
  const ProgressBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep =
        ref.watch(initialWatchPreferencesController).currentStep;

    // ref.watch(initialWatchPreferencesController).currentPageProvider.notifier
    double progressFraction = (currentStep + 1.0) / 4.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Stack(
        children: [
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          FractionallySizedBox(
            widthFactor: progressFraction.clamp(0.0, 1.0),
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
