import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/values/strings.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/core/widgets/common_image_view.dart';
import 'package:vista_flicks/core/widgets/custom_button.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';
import 'package:vista_flicks/framework/controller/auth/initial_watch_preferences/initial_watch_preferences_controller.dart';
import 'package:vista_flicks/framework/controller/main/account_and_pref/filter/filter_controller.dart';
import 'package:vista_flicks/framework/controller/main/reel/reels_controller.dart';
import 'package:vista_flicks/framework/repository/preferences/model/get_preferences_response_model.dart';
import 'package:vista_flicks/framework/utils/extension/context_extension.dart';
import 'package:vista_flicks/framework/utils/extension/string_extension.dart';
import 'package:vista_flicks/framework/utils/local_storage/session.dart';
import 'package:vista_flicks/gen/assets.gen.dart';
import 'package:vista_flicks/ui/utils/helper/base_widget.dart';

import '../../../../../core/utils/config.dart';
import '../../../../routing/navigation_stack_item.dart';
import '../../../../routing/stack.dart';
import '../../../../utils/const/app_enums.dart';
import 'chat_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen>
    with BaseConsumerStatefulWidget {
  final ScrollController _scrollController = ScrollController();

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
    final initialWatchPreferencesWatch =
        ref.watch(initialWatchPreferencesController);
    final reelsWatch = ref.watch(reelsController);
    final filterWatch = ref.watch(filterController);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                controller: _scrollController,
                children: [
                  if (initialWatchPreferencesWatch.currentStep >= 0) ...[
                    ChatBubble(
                        animationCompleted: false,
                        text: "Hey ${Session.userFirstName} 👋🏻",
                        isUser: false),
                    ChatBubble(
                      animationCompleted: false,
                      text:
                          "Let's create your watch preference to help us suggest your favourite movies & shows.",
                      isUser: false,
                    ),
                    if (initialWatchPreferencesWatch.currentStep == 0 &&
                        initialWatchPreferencesWatch.isLoading)
                      _buildLoadingWidget(),
                  ],
                  if (initialWatchPreferencesWatch.currentStep >= 1) ...[
                    ChatBubble(
                        animationCompleted: false,
                        text: "OK, let's start",
                        isUser: true),
                    ChatBubble(
                      animationCompleted: false,
                      text:
                          "Choose your favorite genres and press submit button.",
                      isUser: false,
                    ),
                    if (initialWatchPreferencesWatch.currentStep == 1)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(3, (columnIndex) {
                            int total = filterWatch.genreList.length;
                            int baseCount = total ~/ 3;
                            int remainder = total % 3;

                            List<List<PreferenceResult>> columns = [];
                            int start = 0;

                            for (int i = 0; i < 3; i++) {
                              int count = baseCount + (i < remainder ? 1 : 0);
                              int end = start + count;
                              columns.add(
                                  filterWatch.genreList.sublist(start, end));
                              start = end;
                            }

                            // var startIndex = columnIndex * 3;
                            return Row(
                              children: List.generate(
                                columns[columnIndex].length,
                                (index) {
                                  var genre = columns[columnIndex][index];
                                  bool isSelected = initialWatchPreferencesWatch
                                      .selectedGenres
                                      .contains(genre);

                                  return GestureDetector(
                                    onTap: () {
                                      ref
                                          .read(
                                              initialWatchPreferencesController
                                                  .notifier)
                                          .toggleGenre(genre);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 4.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.black.withOpacity(0.6),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.red
                                              : AppColors.primeryTxt
                                                  .withOpacity(0.2),
                                          width: 1.5,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w, vertical: 12.h),
                                      child: MyRegularText(
                                        genre.name?.capitalize ?? "",
                                        style: BaseTextStyle.textS.copyWith(
                                          color: AppColors.primeryTxt,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                        ),
                      ),
                    SizedBox(height: 16.h),
                    if (initialWatchPreferencesWatch.currentStep == 1 &&
                        initialWatchPreferencesWatch.isLoading)
                      _buildLoadingWidget(),
                  ],
                  if (initialWatchPreferencesWatch.currentStep >= 2) ...[
                    Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 8.w,
                      runSpacing: 10.w,
                      children: [
                        ...initialWatchPreferencesWatch.selectedGenres.map(
                          (genre) =>
                              // ChatBubble(
                              //     text: genre.name ?? "", isUser: true,),
                              Container(
                            // margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.border),
                              color: AppColors.primeryTxt.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              genre.name?.capitalize ?? "",
                              style: BaseTextStyle.textM,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    ChatBubble(
                      animationCompleted: false,
                      text: "Choose your preferred language",
                      isUser: false,
                    ),
                    SizedBox(height: 16.h),
                    if (initialWatchPreferencesWatch.currentStep == 2)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(3, (columnIndex) {
                            int total = filterWatch.languageList.length;
                            int baseCount = total ~/ 3;
                            int remainder = total % 3;

                            List<List<PreferenceResult>> columns = [];
                            int start = 0;

                            for (int i = 0; i < 3; i++) {
                              int count = baseCount + (i < remainder ? 1 : 0);
                              int end = start + count;
                              columns.add(
                                  filterWatch.languageList.sublist(start, end));
                              start = end;
                            }

                            // var startIndex = columnIndex * 3;
                            return Row(
                              children: List.generate(
                                columns[columnIndex].length,
                                (index) {
                                  var genre = columns[columnIndex][index];
                                  bool isSelected = initialWatchPreferencesWatch
                                      .selectedLanguages
                                      .contains(genre);

                                  return GestureDetector(
                                    onTap: () {
                                      ref
                                          .read(
                                              initialWatchPreferencesController
                                                  .notifier)
                                          .toggleLanguage(genre);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 4.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.black.withOpacity(0.6),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.red
                                              : AppColors.primeryTxt
                                                  .withOpacity(0.2),
                                          width: 1.5,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w, vertical: 12.h),
                                      child: MyRegularText(
                                        genre.name?.capitalize ?? "",
                                        style: BaseTextStyle.textS.copyWith(
                                          color: AppColors.primeryTxt,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                        ),
                      ),
                    // SizedBox(
                    //   height: 180.h,
                    //   child: SingleChildScrollView(
                    //     scrollDirection: Axis.horizontal,
                    //     child: Wrap(
                    //       direction: Axis.vertical,
                    //       crossAxisAlignment: WrapCrossAlignment.center,
                    //       spacing: 5.w,
                    //       runSpacing: 5.h,
                    //       children: filterWatch.genreList.map((genre) {
                    //         bool isSelected = initialWatchPreferencesWatch
                    //             .selectedGenres
                    //             .contains(genre);

                    //         return GestureDetector(
                    //           onTap: () {
                    //             ref
                    //                 .read(initialWatchPreferencesController
                    //                     .notifier)
                    //                 .toggleGenre(genre);
                    //           },
                    //           child: Container(
                    //             margin: EdgeInsets.zero,
                    //             decoration: BoxDecoration(
                    //               color: AppColors.black.withOpacity(0.6),
                    //               border: Border.all(
                    //                 color: isSelected
                    //                     ? AppColors.red
                    //                     : AppColors.primeryTxt.withOpacity(0.2),
                    //                 width: 1.5,
                    //               ),
                    //               borderRadius: BorderRadius.circular(12.r),
                    //             ),
                    //             padding: EdgeInsets.symmetric(
                    //                 horizontal: 16.w, vertical: 10.h),
                    //             child: MyRegularText(
                    //               genre.name?.capitalize ?? "",
                    //               style: BaseTextStyle.textS.copyWith(
                    //                 color: AppColors.primeryTxt,
                    //               ),
                    //             ),
                    //           ),
                    //         );
                    //       }).toList(),
                    //     ),
                    //   ),
                    // ),

                    // Wrap(
                    //   runAlignment: WrapAlignment.center,
                    //   direction: Axis.horizontal,
                    //   verticalDirection: VerticalDirection.down,
                    //   crossAxisAlignment: WrapCrossAlignment.start,
                    //   // direction: Axis.horizontal,
                    //   spacing: 8,
                    //   runSpacing: 8,
                    //   children: filterWatch.genreList.map((entry) {
                    //     // int index = entry.key;
                    //     PreferenceResult? genre = entry;
                    //     bool isSelected = initialWatchPreferencesWatch
                    //         .selectedGenres
                    //         .contains(genre);
                    //
                    //     return GestureDetector(
                    //       onTap: () {
                    //         ref
                    //             .read(initialWatchPreferencesController
                    //                 .notifier)
                    //             .toggleGenre(genre);
                    //       },
                    //       child: Container(
                    //         decoration: BoxDecoration(
                    //           color: AppColors.black.withOpacity(.5),
                    //           border: Border.all(
                    //             color: isSelected
                    //                 ? AppColors.red
                    //                 : AppColors.primeryTxt.withOpacity(.2),
                    //           ),
                    //           borderRadius: BorderRadius.circular(8.r),
                    //         ),
                    //         padding: EdgeInsets.symmetric(
                    //             horizontal: 16.w, vertical: 12.h),
                    //         child: MyRegularText(
                    //           genre.name?.capitalize ?? "",
                    //           style: BaseTextStyle.textS.copyWith(
                    //             color: AppColors.primeryTxt,
                    //           ),
                    //         ),
                    //       ),
                    //     );
                    //   }).toList(),
                    // ),
                    // SizedBox(height: 16.h),
                    if (initialWatchPreferencesWatch.currentStep == 2 &&
                        initialWatchPreferencesWatch.isLoading)
                      _buildLoadingWidget(),
                  ],
                  if (initialWatchPreferencesWatch.currentStep >= 3) ...[
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 10.w,
                      alignment: WrapAlignment.end,
                      children: [
                        ...initialWatchPreferencesWatch.selectedLanguages.map(
                          (language) => Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.border),
                              color: AppColors.primeryTxt.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              language.name?.capitalize ?? "",
                              style: BaseTextStyle.textM,
                            ),
                          ),
                          // ChatBubble(
                          //     text: language.name ?? "", isUser: true)
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    ChatBubble(
                      animationCompleted: false,
                      text: "Choose your preferred streaming apps",
                      isUser: false,
                    ),
                    if (initialWatchPreferencesWatch.currentStep == 3)
                      SizedBox(
                        height: context.height * .35,
                        child: GridView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 0,
                            childAspectRatio: 1.9,
                            crossAxisCount: 2,
                          ),
                          itemCount: filterWatch.ottPlatformsList.length,
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
                                // if (!isSelected) {
                                //   initialWatchPreferencesWatch.selectedApps.add(
                                //       initialWatchPreferencesWatch.apps[index]
                                //           ['name']!);
                                // } else {
                                //   initialWatchPreferencesWatch.selectedApps
                                //       .remove(appName);
                                // }
                                // initialWatchPreferencesWatch.selectedApps;
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 64.h,
                                    width: 64.w,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.red
                                            : Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.circular(200),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(
                                          appAsset ?? Config.kNoImage,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    appName.name?.capitalize ?? "",
                                    textAlign: TextAlign.center,
                                    style: BaseTextStyle.lableXs,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 16),
                    if (initialWatchPreferencesWatch.currentStep == 3 &&
                        initialWatchPreferencesWatch.isLoading)
                      _buildLoadingWidget(),
                  ],
                  if (initialWatchPreferencesWatch.currentStep >= 4) ...[
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 10.w,
                      alignment: WrapAlignment.end,
                      children: [
                        ...initialWatchPreferencesWatch.selectedApps.map(
                          (language) => Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.border),
                              color: AppColors.primeryTxt.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              language.name?.capitalize ?? "",
                              style: BaseTextStyle.textM,
                            ),
                          ),
                          // ChatBubble(
                          //     text: language.name ?? "", isUser: true)
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    ChatBubble(
                        animationCompleted: false,
                        text: "Great choice 👌🏻👌🏻",
                        isUser: false),
                    Stack(
                      children: [
                        ChatBubble(
                          animationCompleted: false,
                          text:
                              "Remember, you can always update your watch preference from",
                          isUser: false,
                        ),
                        Positioned(
                          bottom: context.height * .03,
                          right: context.width * .17,
                          child: SvgPicture.asset(
                            Assets.icons.tablerIconFilter,
                            height: 18.h,
                            width: 18.w,
                            color: AppColors.primeryTxt,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 16.h),
                    if (initialWatchPreferencesWatch.currentStep == 4 &&
                        initialWatchPreferencesWatch.isLoading)
                      _buildLoadingWidget(),
                  ],
                ],
              ),
              getVerticalHeight(80.h)
            ],
          ),
        ),
        getVerticalHeight(getHeight(80.h)),
        if (!initialWatchPreferencesWatch.isLoading)
          Padding(
            padding: EdgeInsets.only(bottom: getHeight(20.h)),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Consumer(
                builder: (context, ref, child) {
                  final initialWatchPreferencesWatch =
                      ref.watch(initialWatchPreferencesController);

                  bool isButtonEnabled = false;
                  if (initialWatchPreferencesWatch.currentStep == 0) {
                    isButtonEnabled = true;
                  } else if (initialWatchPreferencesWatch.currentStep == 1) {
                    // _scrollController.animateTo(
                    //   _scrollController.position.maxScrollExtent,
                    //   duration: const Duration(milliseconds: 300),
                    //   curve: Curves.easeOut,
                    // );
                    isButtonEnabled =
                        initialWatchPreferencesWatch.selectedGenres.isNotEmpty;
                  } else if (initialWatchPreferencesWatch.currentStep == 2) {
                    // _scrollController.animateTo(
                    //   _scrollController.position.maxScrollExtent,
                    //   duration: const Duration(milliseconds: 300),
                    //   curve: Curves.easeOut,
                    // );
                    isButtonEnabled = initialWatchPreferencesWatch
                        .selectedLanguages.isNotEmpty;
                  } else if (initialWatchPreferencesWatch.currentStep == 3) {
                    // _scrollController.animateTo(
                    //   _scrollController.position.maxScrollExtent,
                    //   duration: const Duration(milliseconds: 300),
                    //   curve: Curves.easeOut,
                    // );
                    // filterWatch.getPreferencesAPI(context,
                    //     ref: ref, type: FilterType.ottPlatforms.name);
                    isButtonEnabled =
                        initialWatchPreferencesWatch.selectedApps.isNotEmpty;
                  } else if (initialWatchPreferencesWatch.currentStep == 4) {
                    isButtonEnabled = true;
                  }

                  return CustomButton(
                    width: initialWatchPreferencesWatch.currentStep == 4
                        ? MediaQuery.of(context).size.width
                        : initialWatchPreferencesWatch.currentStep == 0
                            ? getWidth(157.h)
                            : getWidth(111.h),
                    style: BaseTextStyle.buttonM,
                    color: isButtonEnabled ? AppColors.red : Colors.grey,
                    text: initialWatchPreferencesWatch.currentStep == 4
                        ? AppStrings.letsGetStarted
                        : initialWatchPreferencesWatch.currentStep == 0
                            ? AppStrings.okLetsStart
                            : AppStrings.submit,
                    fun: isButtonEnabled
                        ? () async {
                            if (initialWatchPreferencesWatch.currentStep == 0) {
                              await filterWatch.getPreferencesAPI(context,
                                  ref: ref, type: FilterType.genre.name);
                              await filterWatch.getPreferencesAPI(context,
                                  ref: ref, type: FilterType.contentType.name);
                              ref
                                  .read(initialWatchPreferencesController
                                      .notifier)
                                  .nextStep();
                              await Future.delayed(Duration(seconds: 2));
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            }
                            if (initialWatchPreferencesWatch.currentStep == 1) {
                              await filterWatch.getPreferencesAPI(context,
                                  ref: ref, type: FilterType.language.name);
                              ref
                                  .read(initialWatchPreferencesController
                                      .notifier)
                                  .nextStep();
                              await Future.delayed(Duration(seconds: 2));
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            }
                            if (initialWatchPreferencesWatch.currentStep == 2) {
                              await filterWatch.getPreferencesAPI(context,
                                  ref: ref, type: FilterType.ottPlatforms.name);
                              ref
                                  .read(initialWatchPreferencesController
                                      .notifier)
                                  .nextStep();
                              await Future.delayed(Duration(seconds: 2));
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            }

                            if (initialWatchPreferencesWatch.currentStep == 3) {
                              ref
                                  .read(initialWatchPreferencesController
                                      .notifier)
                                  .nextStep();
                              await Future.delayed(Duration(seconds: 2));
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                              return;
                            }
                            if (initialWatchPreferencesWatch.currentStep == 4) {
                              for (var element in filterWatch.contentTypeList) {
                                element.isPreferred = true;
                              }
                              for (var element
                                  in filterWatch.subTitleLanguageList) {
                                element.isPreferred = true;
                              }
                              initialWatchPreferencesWatch.selectedContentType
                                  .addAll(filterWatch.contentTypeList);
                              await filterWatch
                                  .updatePreferencesAPI(
                                      isFromFilter: false,
                                      ref: ref,
                                      context,
                                      subtitleLanguage:
                                          initialWatchPreferencesWatch
                                              .selectedSubtitleLanguage,
                                      contentType: initialWatchPreferencesWatch
                                          .selectedContentType,
                                      genre: initialWatchPreferencesWatch
                                          .selectedGenres,
                                      language: initialWatchPreferencesWatch
                                          .selectedLanguages,
                                      ott: initialWatchPreferencesWatch
                                          .selectedApps)
                                  .whenComplete(
                                () {
                                  ref
                                      .read(navigationStackController)
                                      .pushAndRemoveAll(
                                        NavigationStackItem.blank(),
                                      );
                                  reelsWatch.getReels(context, ref: ref);
                                },
                              );
                            }

                            // if (initialWatchPreferencesWatch.currentStep ==
                            //         0 ||
                            //     initialWatchPreferencesWatch
                            //         .selectedGenres.isNotEmpty) {
                            //   filterWatch.getPreferencesAPI(context,
                            //       ref: ref, type: FilterType.genre.name);
                            //   if (initialWatchPreferencesWatch.currentStep !=
                            //       4) {
                            //     ref
                            //         .read(initialWatchPreferencesController
                            //             .notifier)
                            //         .nextStep();
                            //
                            //     // Scroll to bottom after frame build
                            //     //   WidgetsBinding.instance
                            //     //       .addPostFrameCallback((_) {
                            //     //     if (_scrollController.hasClients) {
                            //     //       _scrollController.animateTo(
                            //     //         _scrollController
                            //     //             .position.maxScrollExtent,
                            //     //         duration:
                            //     //             const Duration(milliseconds: 300),
                            //     //         curve: Curves.easeOut,
                            //     //       );
                            //     //     }
                            //     //   });
                            //   }
                            // }
                            // if (initialWatchPreferencesWatch.currentStep ==
                            //         1 ||
                            //     initialWatchPreferencesWatch
                            //         .selectedGenres.isNotEmpty) {
                            //   filterWatch.getPreferencesAPI(context,
                            //       ref: ref,
                            //       type: FilterType.ottPlatforms.name);
                            // }
                            // if (initialWatchPreferencesWatch.currentStep ==
                            //         2 ||
                            //     initialWatchPreferencesWatch
                            //         .selectedGenres.isNotEmpty) {
                            //   filterWatch.getPreferencesAPI(context,
                            //       ref: ref, type: FilterType.language.name);
                            // }
                            //
                            // if (initialWatchPreferencesWatch.currentStep ==
                            //     4) {
                            //   ref
                            //       .read(navigationStackController)
                            //       .pushAndRemoveAll(
                            //         NavigationStackItem.blank(),
                            //       );
                            // }
                          }
                        : () {},
                    // fun: isButtonEnabled
                    //     ? () {
                    //         if (initialWatchPreferencesWatch.currentStep ==
                    //                 0 ||
                    //             initialWatchPreferencesWatch
                    //                 .selectedGenres.isNotEmpty) {
                    //           if (initialWatchPreferencesWatch.currentStep !=
                    //               4) {
                    //             ref
                    //                 .read(initialWatchPreferencesController
                    //                     .notifier)
                    //                 .nextStep();
                    //           }
                    //         }
                    //         if (initialWatchPreferencesWatch.currentStep ==
                    //             4) {
                    //           ref
                    //               .read(navigationStackController)
                    //               .pushAndRemoveAll(
                    //                   NavigationStackItem.blank());
                    //         }
                    //       }
                    //     : () {},
                  );
                },
              ),
            ),

            // child: Align(
            //   alignment: Alignment.bottomRight,
            //   child: CustomButton(
            //     width: controller.currentStep.value == 4
            //         ? Get.width
            //         : controller.currentStep.value == 0
            //             ? getWidth(157)
            //             : getWidth(111),
            //     style: BaseTextStyle.buttonM,
            //     color: AppColors.red,
            //     text: controller.currentStep.value == 4
            //         ? AppStrings.letsGetStarted
            //         : controller.currentStep.value == 0
            //             ? AppStrings.okLetsStart
            //             : AppStrings.submit,
            //     fun: () {
            //       if (controller.currentStep.value == 0 ||
            //           controller.selectedGenres.isNotEmpty) {
            //         if (controller.currentStep.value != 4)
            //           controller.nextStep();
            //         // if (controller.currentStep.value == 4) {
            //         //   Get.toNamed(Routes.EXPLORE);
            //         // }
            //       }
            //     },
            //   ),
            // ),
          ),
      ],
    );
  }

  Widget _buildLoadingWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Lottie.asset(
          height: getHeight(50.h),
          Assets.lottie.animation1737368859751,
        ),
        SizedBox(width: 8.w),
        CommonImageView(
          height: getHeight(50.h),
          imagePath: Assets.background.loading.path,
        ),
      ],
    );
  }
}

//================================================================================================================

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:gif/gif.dart';
// import 'package:lottie/lottie.dart';
// import 'package:vista_flicks/core/values/app_colours.dart';
// import 'package:vista_flicks/core/values/size_constant.dart';
// import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
// import 'package:vista_flicks/core/widgets/common_image_view.dart';
// import 'package:vista_flicks/core/widgets/custom_button.dart';
// import 'package:vista_flicks/gen/assets.gen.dart';
// import 'package:vista_flicks/pages/auth/initial_watch_preferences/initial_watch_preferences_controller.dart';
// import 'package:vista_flicks/pages/auth/initial_watch_preferences/initial_watch_preferences_screen.dart';

// class ChatScreen2 extends GetView<InitialWatchPreferencesController> {
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final currentQuestion =
//           controller.questions[controller.currentQuestionIndex.value];
//       return Column(
//         children: [
//           getVerticalHeight(getHeight(100)),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Display answered questions as chat bubbles
//                   if (controller.answeredQuestions.isNotEmpty)
//                     ...controller.answeredQuestions.map((qa) {
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               // Gif(
//                               //   image:
//                               //       AssetImage(Assets.background.chatBot.path),
//                               //   height: getHeight(50),
//                               //   duration: Duration(seconds: 1),
//                               // ),
//                               Lottie.asset(
//                                   height: getHeight(50),
//                                   Assets.lottie.animation1737368859751),
//                               SizedBox(width: 8),
//                               Flexible(
//                                 child: ChatBubble(
//                                   text: " ${qa['question']}" ?? "",
//                                   isUser: false,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Container(
//                                 padding: EdgeInsets.all(12),
//                                 margin: EdgeInsets.symmetric(vertical: 8),
//                                 decoration: BoxDecoration(
//                                   color: AppColours.primeryTxt.withOpacity(0.2),
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: Text(
//                                   qa['answer'] ?? "",
//                                   style: BaseTextStyle.textM,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       );
//                     }),

//                   // Show loading indicator while waiting for the next question
//                   if (controller.isLoading.value)
//                     // SvgPicture.asset(Assets.background.chatBot.path),
//                     Row(
//                       children: [
//                         Lottie.asset(
//                             height: getHeight(50),
//                             Assets.lottie.animation1737368859751),
//                         SizedBox(width: 8),
//                         CommonImageView(
//                             height: getHeight(50),
//                             imagePath: Assets.background.loading.path)
//                       ],
//                     ),

//                   SizedBox(height: 20),

//                   // Show current question and options only when not loading
//                   if (!controller.isLoading.value) ...[
//                     // Current question
//                     Row(
//                       children: [
//                         Lottie.asset(
//                             height: getHeight(50),
//                             Assets.lottie.animation1737368859751),
//                         SizedBox(width: 8),
//                         Flexible(
//                           child: Container(
//                             padding: EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: AppColours.black.withOpacity(0.5),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Text(
//                               currentQuestion['question'] ?? "",
//                               style: BaseTextStyle.textM,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),

//                     // Options
//                     Wrap(
//                       spacing: 8,
//                       runSpacing: 8,
//                       children: List.generate(
//                         (currentQuestion['options'] as List).length,
//                         (index) {
//                           final option =
//                               (currentQuestion['options'] as List)[index];
//                           return GestureDetector(
//                             onTap: () => controller.selectOption(option),
//                             child: Obx(() {
//                               final isSelected =
//                                   controller.selectedOption.value == option;
//                               return Container(
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 12, horizontal: 16),
//                                 decoration: BoxDecoration(
//                                     color: AppColours.black.withOpacity(0.5),
//                                     borderRadius: BorderRadius.circular(12),
//                                     border: Border.all(
//                                       color: isSelected
//                                           ? AppColours.red
//                                           : AppColours.placeholder
//                                               .withOpacity(0.5),
//                                     )),
//                                 child: Text(
//                                   option,
//                                   style: BaseTextStyle.lableS,
//                                 ),
//                               );
//                             }),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ),

//           // Submit Button at the bottom
//           BottomAppBar(
//             color: Colors.transparent,
//             child: Align(
//               alignment: Alignment.centerRight,
//               child: CustomButton(
//                   width: getWidth(111),
//                   text: "Submit",
//                   fun: controller.submitAnswer),
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:vista_flicks/pages/auth/initial_watch_preferences/initial_watch_preferences_controller.dart';
// import 'package:vista_flicks/pages/auth/initial_watch_preferences/initial_watch_preferences_screen.dart';

// class ChatScreen2 extends GetView<InitialWatchPreferencesController> {
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final currentQuestion =
//           controller.questions[controller.currentQuestionIndex.value];
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Display answered questions
//           if (controller.answeredQuestions.isNotEmpty)
//             ...controller.answeredQuestions.map((qa) {
//               return Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ChatBubble(text: "${qa['question']}", isUser: false),
//                     ChatBubble(text: " ${qa['answer']}", isUser: true),
//                   ],
//                 ),
//               );
//             }),

//           // Show the loading indicator below the answered questions
//           if (controller.isLoading.value)
//             Center(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 16.0),
//                 child: CircularProgressIndicator(),
//               ),
//             ),

//           SizedBox(height: 20),

//           // Display the current question

//           Text(
//             currentQuestion['question'] as String,
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 20),

//           // Display selectable options
//           ...List.generate(
//             (currentQuestion['options'] as List).length,
//             (index) {
//               final option = (currentQuestion['options'] as List)[index];
//               return GestureDetector(
//                 onTap: () => controller.selectOption(option),
//                 child: Obx(() {
//                   final isSelected = controller.selectedOption.value == option;
//                   return Container(
//                     margin: EdgeInsets.symmetric(vertical: 8),
//                     padding: EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: isSelected ? Colors.blue : Colors.grey[200],
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: Colors.grey),
//                     ),
//                     child: Text(
//                       option,
//                       style: TextStyle(
//                         color: isSelected ? Colors.white : Colors.black,
//                       ),
//                     ),
//                   );
//                 }),
//               );
//             },
//           ),

//           Spacer(),

//           // Submit Button
//           ElevatedButton(
//             onPressed: controller.submitAnswer,
//             child: Text("Submit"),
//           ),
//         ],
//       );
//     });
//   }
// }
