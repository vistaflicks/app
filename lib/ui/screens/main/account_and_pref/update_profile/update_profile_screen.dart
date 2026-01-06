import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vista_flicks/framework/controller/auth/on_boarding/on_boarding_controller.dart';
import 'package:vista_flicks/framework/utils/extension/context_extension.dart';
import 'package:vista_flicks/framework/utils/extension/extension.dart';
import 'package:vista_flicks/framework/utils/local_storage/session.dart';
import 'package:vista_flicks/ui/routing/stack.dart';
import 'package:vista_flicks/ui/utils/helper/image_picker_manager.dart';

import '../../../../../core/values/app_colours.dart';
import '../../../../../core/values/size_constant.dart';
import '../../../../../core/values/strings.dart';
import '../../../../../core/values/text_styles/app_textstyles.dart';
import '../../../../../core/values/text_styles/base_textstyle.dart';
import '../../../../../core/values/validator.dart';
import '../../../../../core/widgets/common_bg_container.dart';
import '../../../../../core/widgets/my_regular_text.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../utils/const/form_validations.dart';
import '../../../../utils/helper/base_widget.dart';
import '../../../../utils/widgets/common_button.dart';
import '../../../../utils/widgets/common_form_field.dart';
import '../../../../utils/widgets/common_image.dart';
import '../../../../utils/widgets/dialog_progressbar.dart';
import '../../../../utils/widgets/dropdown/dropdown_button2.dart';

class UpdateProfileScreen extends ConsumerStatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  ConsumerState<UpdateProfileScreen> createState() =>
      _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends ConsumerState<UpdateProfileScreen>
    with BaseConsumerStatefulWidget {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();
  final phoneNumberController = TextEditingController();
  var selectedAge = '';
  var selectedGender = '';

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final updateProfileScreenWatch = ref.read(onBoardingController);
      updateProfileScreenWatch.disposeController(isNotify: true);
      await updateProfileScreenWatch.getProfileApi(context);
      // firstNameController.text = Session.userFirstName;
      // lastNameController.text = Session.userLastName;
      // emailController.text = Session.userEmail;
      // phoneNumberController.text = Session.userMobileNo;
      // ageController.text = Session.userAge;
      // selectedGender = Session.userGender;
      final userData =
          updateProfileScreenWatch.getProfileApiState.success!.data;
      firstNameController.text = userData?.firstName ?? "";
      lastNameController.text = userData?.lastName ?? "";
      emailController.text = userData?.email ?? "";
      phoneNumberController.text =
          userData!.primaryContact?.number.toString() ?? "";
      ageController.text = userData.age.toString();
      updateProfileScreenWatch.profileImage = null;
      selectedGender = userData.gender?.capitalizeFirst().toString() ?? "";
    });
  }

  @override
  Widget buildPage(BuildContext context) {
    final updateProfileScreenWatch = ref.watch(onBoardingController);
    print(
        "updateProfileScreenWatch.isEmail=======>${updateProfileScreenWatch.isEmail}");
    // return PopScope(
    //
    //   canPop: false,
    //   onPopInvokedWithResult: (didPop, result) {
    //     if (Session.userProfileImage.isNotEmpty &&
    //         updateProfileScreenWatch.profileImage == null) {
    //       log("updateProfileScreenWatch.profileImage == null");
    //       // Navigator.pop(context);
    //     } else {
    //       // showDialog(
    //       //   context: context,
    //       //   builder: (context) {
    //       //     return Dialog(
    //       //       backgroundColor: AppColors.primeryTxt,
    //       //       shape: RoundedRectangleBorder(
    //       //         borderRadius: BorderRadius.circular(10),
    //       //       ),
    //       //       child: Padding(
    //       //         padding: const EdgeInsets.all(16.0),
    //       //         child: Column(
    //       //           mainAxisSize: MainAxisSize.min,
    //       //           children: [
    //       //             MyRegularText(
    //       //               "Are you sure you want to discard your uploaded image?",
    //       //               align: TextAlign.center,
    //       //               maxLines: 2,
    //       //               style: BaseTextStyle.lableM
    //       //                   .copyWith(color: AppColors.black),
    //       //             ),
    //       //             getVerticalHeight(20),
    //       //             Row(
    //       //               mainAxisAlignment: MainAxisAlignment.spaceAround,
    //       //               children: [
    //       //                 Expanded(
    //       //                   child: CustomButton(
    //       //                       text: "No, keep it",
    //       //                       fun: () {
    //       //                         Navigator.pop(context);
    //       //                       }),
    //       //                 ),
    //       //                 SizedBox(
    //       //                   width: getWidth(10),
    //       //                 ),
    //       //                 Expanded(
    //       //                   child: CustomButton(
    //       //                     text: "Yes",
    //       //                     isLoading: updateProfileScreenWatch
    //       //                         .updateUserProfileAPIState.isLoading,
    //       //                     fun: () async {
    //       //                       updateProfileScreenWatch.profileImage = null;
    //       //                       Navigator.pop(context);
    //       //                       Navigator.pop(context);
    //       //                     },
    //       //                   ),
    //       //                 ),
    //       //               ],
    //       //             ),
    //       //           ],
    //       //         ),
    //       //       ),
    //       //     );
    //       //   },
    //       // );
    //       log("updateProfileScreenWatch.profileImage != null");
    //     }
    //   },
    //   child:
    return Scaffold(
      backgroundColor: AppColors.black,
      resizeToAvoidBottomInset: false,
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: AppColors.black,
        centerTitle: true,
        title: MyRegularText(
          "Update Profile",
          style: BaseTextStyle.headerM,
        ),
        leading: IconButton(
            onPressed: () {
              ref.read(navigationStackController).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.primeryTxt,
            )),
      ),
      body: CommonBgContainer(
        child: updateProfileScreenWatch.getProfileApiState.isLoading
            ? DialogProgressBar(
                isLoading:
                    updateProfileScreenWatch.getProfileApiState.isLoading)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getVerticalHeight(15),
                  Stack(
                    children: [
                      SizedBox(
                        width: getWidth(100.h),
                        height: getHeight(100.h),
                        child: CommonImage(
                          strIcon: updateProfileScreenWatch.profileImage != null
                              ? updateProfileScreenWatch.profileImage?.path ??
                                  Session.userProfileImage
                              : Session.userProfileImage,
                          isFileImage:
                              updateProfileScreenWatch.profileImage != null,
                          bottomRightRadius: 100.r,
                          topRightRadius: 100.r,
                          topLeftRadius: 100.r,
                          bottomLeftRadius: 100.r,
                          boxFit: BoxFit.cover,
                          // radius: 50.r,
                          // url: profileWatch.profileImage != null ? profileWatch.profileImage?.path ?? Session.userProfileImage : Session.userProfileImage,,
                          // imagePath: Assets.images.profileImg.path,
                        ),
                      ),
                      Positioned(
                          bottom: 0.h,
                          right: 0.w,
                          child: updateProfileScreenWatch
                                  .uploadToS3APIState.isLoading
                              ? CircularProgressIndicator()
                              : GestureDetector(
                                  onTap: () async {
                                    final fileResult = await ImagePickerManager
                                        .instance
                                        .openPicker(
                                      context,
                                      onRemoveCallBack: () {
                                        updateProfileScreenWatch.profileImage =
                                            null;
                                        Session.userProfileImage = "";
                                        updateProfileScreenWatch
                                            .updateScreenState();
                                      },
                                    );
                                    if (fileResult?.file.path != null &&
                                        fileResult?.file.path != "") {
                                      updateProfileScreenWatch
                                          .updateProfileImage(fileResult!);
                                      await updateProfileScreenWatch.uploadToS3(
                                          context,
                                          ref: ref,
                                          file: fileResult.file);
                                    }
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          // borderRadius: BorderRadius.circular(10),
                                          color: AppColors.primeryTxt),
                                      child: Icon(
                                        Icons.edit,
                                        size: 16.sp,
                                        color: AppColors.black.withOpacity(0.7),
                                      ))))
                    ],
                  ),
                  getVerticalHeight(10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: CommonInputFormField(
                          borderRadius: BorderRadius.circular(10.r),
                          contentPadding: EdgeInsets.all(15.r),
                          backgroundColor: AppColors.black.withOpacity(0.3),
                          textEditingController: firstNameController,
                          hintText: "First Name",
                          onChanged: (value) {},
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      getHorizonatlWidth(20.w),
                      Expanded(
                        child: CommonInputFormField(
                          borderRadius: BorderRadius.circular(10.r),
                          contentPadding: EdgeInsets.all(15.r),
                          backgroundColor: AppColors.black.withOpacity(0.3),
                          textEditingController: lastNameController,
                          hintText: "Last Name",
                          onChanged: (value) {},
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ],
                  ).paddingSymmetric(vertical: 7.h),
                  if (updateProfileScreenWatch
                          .getProfileApiState.success?.data!.isEmailVerified ==
                      true)
                    CommonInputFormField(
                      readOnly: true,
                      borderRadius: BorderRadius.circular(10.r),
                      contentPadding: EdgeInsets.all(15.r),
                      backgroundColor: AppColors.black.withOpacity(0.3),
                      textEditingController: emailController,
                      // readOnly: updateProfileScreenWatch.isEmail,
                      hintText: "Enter Email",
                      validator: validateEmail,
                      onChanged: (value) {},
                      textInputAction: TextInputAction.next,
                    ).paddingSymmetric(vertical: 7.h),
                  if (updateProfileScreenWatch
                          .getProfileApiState.success?.data!.isPhoneVerified ==
                      true)
                    CommonInputFormField(
                      readOnly: true,
                      // radius: 10,
                      borderRadius: BorderRadius.circular(10.r),
                      contentPadding: EdgeInsets.all(15.r),
                      backgroundColor: AppColors.black.withOpacity(0.3),
                      prefixWidget: GestureDetector(
                        onTap: () {},
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            getHorizonatlWidth(
                              15.w,
                            ),
                            MyRegularText(
                              "+${updateProfileScreenWatch.countryCode}",
                              // style: Styles.primaryF11W600,
                            ),
                            getHorizonatlWidth(
                              15.w,
                            ),
                            getHorizonatlWidth(
                              10.w,
                            ),
                          ],
                        ),
                      ),
                      textEditingController: phoneNumberController,
                      hintText: "Phone Number",
                      // readOnly: updateProfileScreenWatch.isEmail,
                      textInputType: TextInputType.phone,
                      validator: Validator.validatePhoneNumber,
                      onChanged: (value) {},
                      // formaters: [
                      //   FilteringTextInputFormatter.digitsOnly, // Only digits for phone
                      //   LengthLimitingTextInputFormatter(10), // Limit to 10 digits,
                      // ],
                      textInputAction: TextInputAction.next,
                    ).paddingSymmetric(vertical: 7.h),
                  // getVerticalHeight(15),

                  CommonInputFormField(
                    borderRadius: BorderRadius.circular(10.r),
                    contentPadding: EdgeInsets.all(15.r),
                    backgroundColor: AppColors.black.withOpacity(0.3),
                    textEditingController: ageController,
                    hintText: "Enter Your Age",
                    textInputType: TextInputType.number,
                    onChanged: (value) {
                      selectedAge = value;
                      updateProfileScreenWatch.validateForm(
                          firstNameController,
                          lastNameController,
                          updateProfileScreenWatch.isEmail
                              ? emailController
                              : phoneNumberController,
                          ageController,
                          selectedGender.toLowerCase());
                    },
                    textInputFormatter: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    // formaters: [
                    //   FilteringTextInputFormatter.digitsOnly, // Only numbers
                    //   LengthLimitingTextInputFormatter(3), // Limit to 3 digits
                    // ],
                    textInputAction: TextInputAction.next,
                  ).paddingSymmetric(vertical: 7.h),

                  getVerticalHeight(10.h),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.black.withOpacity(.3),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        value: selectedGender.isNotEmpty
                            ? selectedGender.capitalizeFirst()
                            : null,
                        buttonStyleData: ButtonStyleData(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          padding: EdgeInsets.only(
                              right: 13.sp, top: 4.sp, bottom: 4.sp),
                        ),
                        dropdownStyleData: DropdownStyleData(
                          // offset: const Offset(0, -5),
                          maxHeight: context.height * .4,
                          scrollPadding: EdgeInsets.all(0),
                          elevation: 0,
                          decoration: BoxDecoration(
                            color: AppColors.black.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        iconStyleData: IconStyleData(
                            icon: SvgPicture.asset(
                                Assets.icons.tablerIconChevronDown,
                                color: AppColors.primeryTxt),
                            openMenuIcon: Icon(
                              Icons.keyboard_arrow_up_outlined,
                              color: AppColors.primeryTxt,
                            )),
                        hint: Text(
                          "Select Your Gender",
                          style: AppTextstyles.lableStyle,
                        ),
                        items: ["male", "female", "other"]
                            .map((gender) => DropdownMenuItem<String>(
                                  value: gender.capitalizeFirst(),
                                  child: MyRegularText(gender.capitalizeFirst(),
                                      style: AppTextstyles.lableStyle),
                                ))
                            .toList(),
                        onChanged: (value) {
                          selectedGender = value ?? '';
                          updateProfileScreenWatch.validateForm(
                              firstNameController,
                              lastNameController,
                              updateProfileScreenWatch.isEmail
                                  ? emailController
                                  : phoneNumberController,
                              ageController,
                              selectedGender.toLowerCase()); // Validate form
                        },
                      ),
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.all(20.sp),
        child: CommonButton(
          buttonTextStyle: BaseTextStyle.buttonM.copyWith(
            color: AppColors.primeryTxt,
          ),
          buttonEnabledColor: AppColors.red,
          borderRadius: BorderRadius.circular(100.r),
          isLoading:
              updateProfileScreenWatch.updateUserProfileAPIState.isLoading,
          buttonText: AppStrings.update,
          onTap: () async {
            await updateProfileScreenWatch.updateUserProfileApi(
              context,
              ref: ref,
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              dialCode: updateProfileScreenWatch.countryCode,
              age: ageController.text,
              gender: selectedGender.toLowerCase(),
              inputFieldTxt: updateProfileScreenWatch.isEmail
                  ? emailController.text
                  : phoneNumberController.text,
            );
            await updateProfileScreenWatch.getProfileApi(context);
          },
        ),
      ),
    );
    // );
  }

  void showCountryCode({
    required BuildContext context,
    required void Function(Country) onSelect,
  }) {
    showCountryPicker(
      context: context,
      showWorldWide: false,
      showPhoneCode: true,
      showSearch: true,
      countryListTheme: CountryListThemeData(
        bottomSheetHeight: 400.h,
        borderRadius: BorderRadius.circular(11.r),
        inputDecoration: const InputDecoration(
          prefixIcon: Icon(Icons.search),
          labelText: "Search",
          border: OutlineInputBorder(),
        ),
      ),
      onSelect: onSelect,
    );
  }
}

// import 'package:country_picker/country_picker.dart';
// import 'package:direct_select/direct_select.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:vista_flicks/core/widgets/common_bg_container.dart';
//
// class UpdateProfileScreen extends GetView<UpdateProfileController> {
//   const UpdateProfileScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.black,
//       resizeToAvoidBottomInset: false,
//       // extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         systemOverlayStyle: SystemUiOverlayStyle.light,
//         backgroundColor: AppColors.black,
//         centerTitle: true,
//         title: MyRegularText(
//           "Update Profile",
//           style: BaseTextStyle.headerM,
//         ),
//         leading: IconButton(
//             onPressed: () {
//               Get.back();
//             },
//             icon: Icon(
//               Icons.arrow_back,
//               color: AppColors.primeryTxt,
//             )),
//       ),
//       body: CommonBgContainer(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             getVerticalHeight(15),
//             SizedBox(
//               width: getWidth(100),
//               height: getHeight(100),
//               child: CommonImageView(
//                 radius: 50,
//                 imagePath: Assets.images.profileImg.path,
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Expanded(
//                   child: CustomTextFormField(
//                     controller: controller.firstNameController,
//                     hintText: "First Name",
//                     contentPadding: EdgeInsets.symmetric(
//                         vertical: getHeight(15), horizontal: getWidth(15)),
//                     onChanged: (value) {},
//                     action: TextInputAction.next,
//                   ),
//                 ),
//                 getHorizonatlWidth(20),
//                 Expanded(
//                   child: CustomTextFormField(
//                     controller: controller.lastNameController,
//                     hintText: "Last Name",
//                     contentPadding: EdgeInsets.symmetric(
//                         vertical: getHeight(15), horizontal: getWidth(15)),
//                     onChanged: (value) {},
//                     action: TextInputAction.next,
//                   ),
//                 ),
//               ],
//             ),
//             CustomTextFormField(
//               controller: controller.emailController,
//               hintText: "Enter Email",
//               contentPadding: EdgeInsets.symmetric(
//                   vertical: getHeight(15), horizontal: getWidth(15)),
//               validator: CustomTextFieldValidator.email,
//               onChanged: (value) {},
//               action: TextInputAction.next,
//             ),
//             CustomTextFormField(
//               prefix: GestureDetector(
//                 onTap: () => showCountryCode(
//                   context: context,
//                   onSelect: (Country value) {
//                     // controller.flagEmoji.value = value.flagEmoji;
//                     controller.countryCode.value = value.phoneCode;
//                   },
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     getHorizonatlWidth(
//                       10,
//                     ),
//                     Obx(() => MyRegularText(
//                           "+${controller.countryCode.value}",
//                           // style: Styles.primaryF11W600,
//                         )),
//                     // getHorizonatlWidth(
//                     //   10,
//                     // ),
//                     const Icon(Icons.arrow_drop_down),
//                     // SvgPicture.asset(Assets.icons),
//                     const SizedBox(
//                       height: 24,
//                       width: 1,
//                       // color: ColorConstant.kPrimary,
//                     ),
//                     getHorizonatlWidth(
//                       10,
//                     ),
//                   ],
//                 ),
//               ),
//               controller: controller.phoneNumberController,
//               hintText: "Phone Number",
//               keyboard: TextInputType.phone,
//               contentPadding: EdgeInsets.symmetric(
//                   vertical: getHeight(15), horizontal: getWidth(15)),
//               onChanged: (value) {},
//               formaters: [
//                 FilteringTextInputFormatter.digitsOnly, // Only digits for phone
//                 LengthLimitingTextInputFormatter(10), // Limit to 10 digits,
//               ],
//               action: TextInputAction.next,
//             ),
//             getVerticalHeight(15),
//             CustomTextFormField(
//               radius: 10,
//               controller: controller.ageController,
//               hintText: "Enter Your Age",
//               keyboard: TextInputType.number,
//               onChanged: (value) {
//                 controller.selectedAge.value = value;
//               },
//               formaters: [
//                 FilteringTextInputFormatter.digitsOnly, // Only numbers
//                 LengthLimitingTextInputFormatter(3), // Limit to 3 digits
//               ],
//               action: TextInputAction.next,
//             ),
//             getVerticalHeight(15),
//             // Container(
//             //   decoration: BoxDecoration(
//             //       color: AppColors.black.withOpacity(.3),
//             //       borderRadius: BorderRadius.circular(10)),
//             //   child: Builder(builder: (context) {
//             //     return DropdownButtonFormField<String>(
//             //       decoration: InputDecoration(
//             //         contentPadding: EdgeInsets.symmetric(
//             //             vertical: getHeight(15), horizontal: getWidth(15)),
//             //         hintText: "Select Your Gender",
//             //         hintStyle: AppTextstyles.lableStyle,
//             //         floatingLabelStyle: AppTextstyles.lableStyle,
//             //         border: OutlineInputBorder(
//             //           borderSide: BorderSide.none,
//             //           borderRadius: BorderRadius.circular(10),
//             //         ),
//             //       ),
//             //       dropdownColor: AppColors.black.withOpacity(0.8),
//             //       items: ["Male", "Female", "Other"]
//             //           .map((gender) => DropdownMenuItem(
//             //                 value: gender,
//             //                 child: MyRegularText(gender,
//             //                     style: AppTextstyles.lableStyle),
//             //               ))
//             //           .toList(),
//             //       onChanged: (value) {
//             //         controller.selectedGender.value = value ?? '';
//             //       },
//             //     );
//             //   }),
//             // ),
//             Obx(
//               () => Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: AppColors.black.withOpacity(0.3),
//                 ),
//                 child: DirectSelect(
//                   mode: DirectSelectMode.tap,
//                   itemExtent: 50.0,
//                   itemMagnification: 1,
//                   backgroundColor: AppColors.black.withOpacity(0.5),
//                   selectedIndex: controller.selectedGenderIndex.value,
//                   onSelectedItemChanged: (index) {
//                     controller.selectedGender.value =
//                         ["Male", "Female", "Other"][index ?? 0];
//                     controller.selectedGenderIndex.value = index!;
//                   },
//                   items: ["Male", "Female", "Other"]
//                       .map((gender) => Center(
//                           child: Text(gender, style: AppTextstyles.lableStyle)))
//                       .toList(),
//                   child: Text(
//                     controller.selectedGender.value.isNotEmpty
//                         ? controller.selectedGender.value
//                         : "Select Your Gender",
//                     style: AppTextstyles.lableStyle,
//                   ),
//                 ),
//               ),
//             ),
//             getVerticalHeight(Get.height * .15),
//             CustomButton(
//               style: BaseTextStyle.buttonM.copyWith(
//                 color: AppColors.primeryTxt,
//               ),
//               color: AppColors.red,
//               text: AppStrings.update,
//               fun: () {},
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   void showCountryCode(
//       {required BuildContext context,
//       required void Function(Country) onSelect}) {
//     showCountryPicker(
//         context: context,
//         showWorldWide: false,
//         showPhoneCode: true,
//         showSearch: true,
//         countryListTheme: CountryListThemeData(
//           bottomSheetHeight: Get.height * 0.75,
//           borderRadius: BorderRadius.circular(11),
//           // backgroundColor: ColorConstant.kWhite,
//           // textStyle: Styles.lightGreyF14W400,
//           inputDecoration: const InputDecoration(
//             prefixIcon: Icon(Icons.search),
//             // iconColor: ColorConstant.kLightPurple,
//             // prefixIconColor: ColorConstant.kLightPurple,
//             focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(
//                   // color: ColorConstant.kBGColor,
//                   ),
//             ),
//             floatingLabelStyle: TextStyle(
//                 // color: ColorConstant.kBGColor,
//                 ),
//             labelText: "Search",
//             border: OutlineInputBorder(),
//           ),
//         ),
//         onSelect: onSelect);
//   }
// }
