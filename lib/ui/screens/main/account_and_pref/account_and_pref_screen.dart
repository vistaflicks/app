import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vista_flicks/framework/controller/auth/on_boarding/on_boarding_controller.dart';
import 'package:vista_flicks/framework/controller/main/account_and_pref/account_and_pref_controller.dart';
import 'package:vista_flicks/framework/controller/main/account_and_pref/filter/filter_controller.dart';
import 'package:vista_flicks/framework/utils/extension/string_extension.dart';
import 'package:vista_flicks/ui/routing/navigation_stack_item.dart';
import 'package:vista_flicks/ui/routing/stack.dart';
import 'package:vista_flicks/ui/screens/main/account_and_pref/update_profile/helper/account_txt_widget.dart';
import 'package:vista_flicks/ui/screens/main/account_and_pref/update_profile/helper/common_menu_tile_widget.dart';
import 'package:vista_flicks/ui/screens/main/account_and_pref/update_profile/helper/user_info_tile_widget.dart';
import 'package:vista_flicks/ui/utils/const/app_enums.dart';

import '../../../../core/values/app_colours.dart';
import '../../../../core/values/size_constant.dart';
import '../../../../core/values/text_styles/base_textstyle.dart';
import '../../../../core/widgets/common_bg_container.dart';
import '../../../../core/widgets/my_regular_text.dart';
import '../../../../framework/utils/local_storage/session.dart';
import '../../../../gen/assets.gen.dart';
import '../../../utils/theme/app_strings.g.dart';
import '../../../utils/widgets/common_dialogs.dart';

class AccountAndPrefScreen extends ConsumerStatefulWidget {
  const AccountAndPrefScreen({super.key});

  @override
  ConsumerState<AccountAndPrefScreen> createState() =>
      _AccountAndPrefScreenState();
}

class _AccountAndPrefScreenState extends ConsumerState<AccountAndPrefScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final accountAndPrefScreenWatch = ref.watch(accountAndPrefController);
      final onBoardingWatch = ref.watch(onBoardingController);
      final filerScreenWatch = ref.read(filterController);
      onBoardingWatch.getProfileApi(context);
      accountAndPrefScreenWatch.disposeController(isNotify: true);
      filerScreenWatch.disposeController(isNotify: true);
      filerScreenWatch.clearAllList();

      // Future.delayed(Duration(milliseconds: 300), () async {
      //   if (mounted) {
      //     /// Genre
      //     await filerScreenWatch.getPreferencesAPI(context,
      //         ref: ref, type: FilterType.genre.name);
      //   }
      //
      //   /// Language
      //   if (mounted) {
      //     await filerScreenWatch.getPreferencesAPI(context,
      //         ref: ref, type: FilterType.language.name);
      //   }
      //
      //   /// Subtitle Language
      //   if (mounted) {
      //     await filerScreenWatch.getPreferencesAPI(context,
      //         ref: ref, type: FilterType.subTitleLanguage.name);
      //   }
      //
      //   /// Content Type
      //   if (mounted) {
      //     await filerScreenWatch.getPreferencesAPI(context,
      //         ref: ref, type: FilterType.contentType.name);
      //   }
      //
      //   /// OTT Platforms
      //   if (mounted) {
      //     await filerScreenWatch.getPreferencesAPI(context,
      //         ref: ref, type: FilterType.ottPlatforms.name);
      //   }
      //
      //   /// Region
      //   if (mounted) {
      //     await filerScreenWatch.getPreferencesAPI(context,
      //         ref: ref, type: FilterType.region.name);
      //   }
      //
      //   /// IMDB Rating
      //   if (mounted) {
      //     await filerScreenWatch.getPreferencesAPI(context,
      //         ref: ref, type: FilterType.imdbRating.name);
      //   }
      //
      //   /// Age Rating
      //   if (mounted) {
      //     await filerScreenWatch.getPreferencesAPI(context,
      //         ref: ref, type: FilterType.ageRating.name);
      //   }
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    final accountAndPrefScreenWatch = ref.watch(accountAndPrefController);
    final onBoardingWatch = ref.watch(onBoardingController);

    final filerScreenWatch = ref.watch(filterController);
    log("accountAndPrefScreenWatch => ${Session.userId}");
    return Stack(
      children: [
        Scaffold(
          body: IgnorePointer(
            ignoring: filerScreenWatch.getPreferenceState.isLoading,
            child: CommonBgContainer(
              boxDecoration:
                  BoxDecoration(color: AppColors.bgColor.withOpacity(.5)),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getVerticalHeight(Platform.isAndroid ? 20 : 60),
                    const UserInfoTileWidget(),
                    getVerticalHeight(20),
                    const AccountSettingTxtWidget(),
                    getVerticalHeight(10),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            ref
                                .read(navigationStackController)
                                .push(NavigationStackItem.updateProfile());
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: getHeight(18),
                                horizontal: getWidth(16)),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    topLeft: Radius.circular(10)),
                                border: Border(
                                  top: BorderSide(color: AppColors.border),
                                  right: BorderSide(color: AppColors.border),
                                  left: BorderSide(color: AppColors.border),
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      Assets.icons.tablerIconUserCircle,
                                      color: AppColors.primeryTxt,
                                    ),
                                    getHorizonatlWidth(10),
                                    const MyRegularText(
                                      "Update Profile",
                                      style: BaseTextStyle.lableM,
                                    ),
                                  ],
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 20,
                                  color: AppColors.primeryTxt,
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: getHeight(10),
                              horizontal: getWidth(16)),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)),
                              border: Border.all(color: AppColors.border)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    Assets.icons.tablerIconBell,
                                    color: AppColors.primeryTxt,
                                  ),
                                  getHorizonatlWidth(10),
                                  const MyRegularText(
                                    "Notifications",
                                    style: BaseTextStyle.lableM,
                                  ),
                                ],
                              ),
                              Transform.scale(
                                scale: 0.7,
                                child: Switch(
                                  trackOutlineWidth:
                                      const WidgetStatePropertyAll(0),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  inactiveThumbColor: AppColors.primeryTxt,
                                  activeColor: AppColors.green,
                                  activeTrackColor: AppColors.green,
                                  thumbColor: const WidgetStatePropertyAll(
                                      AppColors.primeryTxt),
                                  value: accountAndPrefScreenWatch
                                      .notificationToggle,
                                  onChanged: (value) {
                                    accountAndPrefScreenWatch
                                        .toggleNotification(value);
                                    // accountAndPrefScreenWatch.notificationToggle =
                                    //     value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    getVerticalHeight(20),
                    MyRegularText(
                      "Watch Preferences",
                      style: BaseTextStyle.lableS
                          .copyWith(color: AppColors.secondaryTxt),
                    ),
                    getVerticalHeight(20),
                    Column(
                      children: [
                        CommonMenuTileWidget(
                          onTap: () {
                            final filterWatch = ref.watch(filterController);
                            filterWatch.updateSelectedCategory(
                                'Genre', context, ref);
                            ref.read(navigationStackController).push(
                                NavigationStackItem.filter(
                                    type: FilterType.genre.name));
                          },
                          txt: 'Genre',
                          isTop: true,
                        ),
                        CommonMenuTileWidget(
                          onTap: () {
                            final filterWatch = ref.watch(filterController);
                            filterWatch.updateSelectedCategory(
                                'Language', context, ref);
                            ref.read(navigationStackController).push(
                                NavigationStackItem.filter(
                                    type: FilterType.language.name));
                            // Get.toNamed(Routes.FILTER);
                          },
                          txt: 'Language',
                        ),
                        CommonMenuTileWidget(
                          onTap: () {
                            final filterWatch = ref.watch(filterController);
                            filterWatch.updateSelectedCategory(
                                'OTT Platforms', context, ref);
                            ref.read(navigationStackController).push(
                                NavigationStackItem.filter(
                                    type: FilterType.ottPlatforms.name));
                            // Get.toNamed(Routes.FILTER);
                          },
                          txt: 'OTT Platforms',
                        ),
                        CommonMenuTileWidget(
                          onTap: () {
                            final filterWatch = ref.watch(filterController);
                            filterWatch.updateSelectedCategory(
                                'Region', context, ref);
                            ref.read(navigationStackController).push(
                                NavigationStackItem.filter(
                                    type: FilterType.region.name));
                            // Get.toNamed(Routes.FILTER);
                          },
                          txt: "Region",
                        ),
                        CommonMenuTileWidget(
                          isIMDB: true,
                          onTap: () {
                            final filterWatch = ref.watch(filterController);
                            filterWatch.updateSelectedCategory(
                                'Ratings', context, ref);
                            ref.read(navigationStackController).push(
                                NavigationStackItem.filter(
                                    type: FilterType.imdbRating.name));
                            // Get.toNamed(Routes.FILTER);
                          },
                          txt: "Rating",
                        ),
                        CommonMenuTileWidget(
                          onTap: () {
                            final filterWatch = ref.watch(filterController);
                            filterWatch.updateSelectedCategory(
                                'Age Rating', context, ref);
                            ref.read(navigationStackController).push(
                                NavigationStackItem.filter(
                                    type: FilterType.ageRating.name));
                            // Get.toNamed(Routes.FILTER);
                          },
                          txt: "Age Rating",
                          isBottom: true,
                        ),
                      ],
                    ),
                    getVerticalHeight(20),
                    CommonMenuTileWidget(
                      onTap: () {
                        ref
                            .read(navigationStackController)
                            .push(NavigationStackItem.about());
                        // Get.toNamed(Routes.ABOUT);
                      },
                      txt: "About",
                      isTop: true,
                    ),
                    CommonMenuTileWidget(
                      onTap: () {
                        ref
                            .read(navigationStackController)
                            .push(NavigationStackItem.contact());
                        // Get.toNamed(Routes.CONTACT);
                      },
                      txt: "Contact",
                    ),
                    CommonMenuTileWidget(
                      onTap: () {
                        ref
                            .read(navigationStackController)
                            .push(NavigationStackItem.privacyPolicy());
                        // Get.toNamed(Routes.PRIVACYPOLICY);
                      },
                      txt: "Privacy Policy",
                    ),
                    CommonMenuTileWidget(
                      onTap: () {
                        ref
                            .read(navigationStackController)
                            .push(NavigationStackItem.termsOfUse());
                        // Get.toNamed(Routes.TERMSOFUSE);
                      },
                      txt: "Terms of Use",
                      isBottom: true,
                    ),
                    getVerticalHeight(20),
                    CommonMenuTileWidget(
                      onTap: () async {
                        await showConfirmationDialog(
                          context,
                          "Sign Out".localized,
                          "Are you sure want to Sign Out",
                          "Sign Out".localized,
                          LocaleKeys.keyCancel.localized,
                          (isPositive) async {
                            if (isPositive) {
                              /// Logout
                              // await onBoardingWatch.logoutApi(context, ref);
                              // if (onBoardingWatch
                              //         .logoutApiState.success?.status ==
                              //     ApiEndPoints.apiStatus_200) {
                              //   await Session.sessionLogout(ref);
                              // }
                              await Session.sessionLogout(ref);
                            }
                          },
                        );
                        // onBoardingWatch.logoutApi(context, ref);
                        // if (onBoardingWatch.logoutApiState.success?.status ==
                        //     ApiEndPoints.apiStatus_200) {
                        // await Session.sessionLogout(ref);
                        // }
                      },
                      txt: "Sign Out",
                      isBottom: onBoardingWatch.verifyOtpAPIState.success?.data
                                  ?.user?.userType
                                  ?.toLowerCase() !=
                              "cd-user"
                          ? false
                          : true,
                      isTop: true,
                      isLast: true,
                    ),
                    if (onBoardingWatch
                            .verifyOtpAPIState.success?.data?.user?.userType
                            ?.toLowerCase() !=
                        "cd-user")
                      CommonMenuTileWidget(
                        onTap: () async {
                          await showConfirmationDialog(
                            context,
                            "Delete Account".localized,
                            "Are you sure want to Delete Account",
                            "Delete".localized,
                            LocaleKeys.keyCancel.localized,
                            (isPositive) async {
                              if (isPositive) {
                                /// Logout
                                // await onBoardingWatch.logoutApi(context, ref);
                                // if (onBoardingWatch
                                //         .logoutApiState.success?.status ==
                                //     ApiEndPoints.apiStatus_200) {
                                //   await Session.sessionLogout(ref);
                                // }
                                onBoardingWatch.deleteAccount(context, ref);
                                // await Session.sessionLogout(ref);
                              }
                            },
                          );
                        },
                        txt: "Delete Account",
                        isBottom: true,
                        isLast: true,
                        isDelete: true,
                      ),
                    getVerticalHeight(100),
                  ],
                ),
              ),
            ),
          ),
        ),
        // DialogProgressBar(
        //     isLoading: filerScreenWatch.getPreferenceState.isLoading)
      ],
    );
  }
}
//
// class AccountAndPrefScreen extends GetView<AccountAndPrefController> {
//   const AccountAndPrefScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CommonBgContainer(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               getVerticalHeight(60),
//               const UserInfoTileWidget(),
//               getVerticalHeight(20),
//               const AccountSettingTxtWidget(),
//               getVerticalHeight(10),
//               Column(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Get.toNamed(Routes.UPDATEPROFILE);
//                     },
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                           vertical: getHeight(18), horizontal: getWidth(16)),
//                       decoration: BoxDecoration(
//                           borderRadius: const BorderRadius.only(
//                               topRight: Radius.circular(10),
//                               topLeft: Radius.circular(10)),
//                           border: Border.all(color: AppColors.border)),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               SvgPicture.asset(
//                                 Assets.icons.tablerIconUserCircle,
//                                 color: AppColors.primeryTxt,
//                               ),
//                               getHorizonatlWidth(10),
//                               const MyRegularText(
//                                 "Update Profile",
//                                 style: BaseTextStyle.lableM,
//                               ),
//                             ],
//                           ),
//                           const Icon(
//                             Icons.arrow_forward_ios_rounded,
//                             size: 20,
//                             color: AppColors.primeryTxt,
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   Obx(
//                         () => Container(
//                       padding: EdgeInsets.symmetric(
//                           vertical: getHeight(18), horizontal: getWidth(16)),
//                       decoration: BoxDecoration(
//                           borderRadius: const BorderRadius.only(
//                               bottomRight: Radius.circular(10),
//                               bottomLeft: Radius.circular(10)),
//                           border: Border.all(color: AppColors.border)),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               SvgPicture.asset(
//                                 Assets.icons.tablerIconBell,
//                                 color: AppColors.primeryTxt,
//                               ),
//                               getHorizonatlWidth(10),
//                               const MyRegularText(
//                                 "Notifications",
//                                 style: BaseTextStyle.lableM,
//                               ),
//                             ],
//                           ),
//                           Switch(
//                             trackOutlineWidth: const WidgetStatePropertyAll(0),
//                             materialTapTargetSize:
//                             MaterialTapTargetSize.shrinkWrap,
//                             inactiveThumbColor: AppColors.primeryTxt,
//                             activeColor: AppColors.green,
//                             activeTrackColor: AppColors.green,
//                             thumbColor: const WidgetStatePropertyAll(
//                                 AppColors.primeryTxt),
//                             value: controller.notificationToggle.value,
//                             onChanged: (value) {
//                               controller.notificationToggle.value = value;
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               getVerticalHeight(20),
//               MyRegularText(
//                 "Watch Preferences",
//                 style: BaseTextStyle.lableS
//                     .copyWith(color: AppColors.secondaryTxt),
//               ),
//               getVerticalHeight(20),
//               Column(
//                 children: [
//                   CommonMenuTileWidget(
//                     onTap: () {
//                       // Get.toNamed(Routes.FILTER);
//                     },
//                     txt: 'Genre',
//                     isTop: true,
//                   ),
//                   CommonMenuTileWidget(
//                     onTap: () {
//                       // Get.toNamed(Routes.FILTER);
//                     },
//                     txt: 'Language',
//                   ),
//                   CommonMenuTileWidget(
//                     onTap: () {
//                       // Get.toNamed(Routes.FILTER);
//                     },
//                     txt: 'OTT Platforms',
//                   ),
//                   CommonMenuTileWidget(
//                     onTap: () {
//                       // Get.toNamed(Routes.FILTER);
//                     },
//                     txt: "Region",
//                   ),
//                   CommonMenuTileWidget(
//                     isIMDB: true,
//                     onTap: () {
//                       // Get.toNamed(Routes.FILTER);
//                     },
//                     txt: "Rating",
//                   ),
//                   CommonMenuTileWidget(
//                     onTap: () {
//                       // Get.toNamed(Routes.FILTER);
//                     },
//                     txt: "App Rating",
//                     isBottom: true,
//                   ),
//                 ],
//               ),
//               getVerticalHeight(20),
//               CommonMenuTileWidget(
//                 onTap: () {
//                   // Get.toNamed(Routes.ABOUT);
//                 },
//                 txt: "About",
//                 isTop: true,
//               ),
//               CommonMenuTileWidget(
//                 onTap: () {
//                   // Get.toNamed(Routes.CONTACT);
//                 },
//                 txt: "Contact",
//               ),
//               CommonMenuTileWidget(
//                 onTap: () {
//                   // Get.toNamed(Routes.PRIVACYPOLICY);
//                 },
//                 txt: "Privacy Policy",
//               ),
//               CommonMenuTileWidget(
//                 onTap: () {
//                   // Get.toNamed(Routes.TERMSOFUSE);
//                 },
//                 txt: "Terms of Use",
//                 isBottom: true,
//               ),
//               getVerticalHeight(20),
//               CommonMenuTileWidget(
//                 onTap: () {},
//                 txt: "Sign Out",
//                 isTop: true,
//                 isLast: true,
//               ),
//               CommonMenuTileWidget(
//                 onTap: () {},
//                 txt: "Delete Account",
//                 isBottom: true,
//                 isLast: true,
//                 isDelete: true,
//               ),
//               getVerticalHeight(100),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
