import 'package:country_picker/country_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/values/strings.dart';
import 'package:vista_flicks/core/values/text_styles/app_textstyles.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/core/values/validator.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';
import 'package:vista_flicks/framework/utils/extension/context_extension.dart';
import 'package:vista_flicks/framework/utils/extension/extension.dart';
import 'package:vista_flicks/ui/utils/const/form_validations.dart';
import 'package:vista_flicks/ui/utils/widgets/common_form_field.dart';

import '../../../../../framework/controller/auth/on_boarding/on_boarding_controller.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../utils/helper/base_widget.dart';
import '../../../../utils/widgets/common_button.dart';

// class RegisterFormWidget extends GetView<OnBordingController> {
//   const RegisterFormWidget({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Expanded(
//               child: CustomTextFormField(
//                 radius: 10,
//                 controller: controller.firstNameController,
//                 hintText: "First Name",
//                 onChanged: (value) {},
//                 action: TextInputAction.next,
//               ),
//             ),
//             getHorizonatlWidth(20),
//             Expanded(
//               child: CustomTextFormField(
//                 radius: 10,
//                 controller: controller.lastNameController,
//                 hintText: "Last Name",
//                 onChanged: (value) {},
//                 action: TextInputAction.next,
//               ),
//             ),
//           ],
//         ),
//         CustomTextFormField(
//           radius: 10,
//           controller: controller.emailController,
//           hintText: "Enter Email",
//           validator: CustomTextFieldValidator.email,
//           onChanged: (value) {},
//           action: TextInputAction.next,
//         ),
//         CustomTextFormField(
//           radius: 10,
//           prefix: GestureDetector(
//             onTap: () => showCountryCode(
//               context: context,
//               onSelect: (Country value) {
//                 // controller.flagEmoji.value = value.flagEmoji;
//                 controller.countryCode.value = value.phoneCode;
//               },
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 getHorizonatlWidth(
//                   10,
//                 ),
//                 Obx(() => MyRegularText(
//                       "+${controller.countryCode.value}",
//                       // style: Styles.primaryF11W600,
//                     )),
//                 // getHorizonatlWidth(
//                 //   10,
//                 // ),
//                 const Icon(Icons.arrow_drop_down),
//                 // SvgPicture.asset(Assets.icons),
//                 const SizedBox(
//                   height: 24,
//                   width: 1,
//                   // color: ColorConstant.kPrimary,
//                 ),
//                 getHorizonatlWidth(
//                   10,
//                 ),
//               ],
//             ),
//           ),
//           controller: controller.phoneNumberController,
//           hintText: "Phone Number",
//           keyboard: TextInputType.phone,
//           onChanged: (value) {},
//           formaters: [
//             FilteringTextInputFormatter.digitsOnly, // Only digits for phone
//             LengthLimitingTextInputFormatter(10), // Limit to 10 digits,
//           ],
//           action: TextInputAction.next,
//         ),
//         // getVerticalHeight(15),
//
//         CustomTextFormField(
//           radius: 10,
//           controller: controller.ageController,
//           hintText: "Enter Your Age",
//           keyboard: TextInputType.number,
//           onChanged: (value) {
//             controller.selectedAge.value = value;
//             controller.validateForm();
//           },
//           formaters: [
//             FilteringTextInputFormatter.digitsOnly, // Only numbers
//             LengthLimitingTextInputFormatter(3), // Limit to 3 digits
//           ],
//           action: TextInputAction.next,
//         ),
//
//         // Obx(
//         //   () => Container(
//         //     width: double.infinity,
//         //     padding: EdgeInsets.all(16),
//         //     decoration: BoxDecoration(
//         //       borderRadius: BorderRadius.circular(10),
//         //       color: AppColors.black.withOpacity(0.3),
//         //     ),
//         //     child: DirectSelect(
//         //       mode: DirectSelectMode.tap,
//         //       itemExtent: 50.0,
//         //       itemMagnification: 1,
//         //       selectionColor: AppColors.placeholder.withOpacity(0.5),
//         //       backgroundColor: AppColors.black.withOpacity(0.7),
//         //       selectedIndex: controller.selectedAgeIndex.value,
//         //       onSelectedItemChanged: (index) {
//         //         controller.selectedAge.value = (index! + 1).toString();
//         //         controller.selectedAgeIndex.value = index;
//         //         controller.validateForm();
//         //       },
//         //       items: List.generate(
//         //           100,
//         //           (index) => Center(
//         //                 child: Text("${index + 1} years",
//         //                     style: AppTextstyles.lableStyle),
//         //               )),
//         //       child: Text(
//         //         controller.selectedAge.value.isNotEmpty
//         //             ? "${controller.selectedAge.value} years"
//         //             : "Select Your Age",
//         //         style: AppTextstyles.lableStyle,
//         //       ),
//         //     ),
//         //   ),
//         // ),
//
//         // Obx(
//         //   () => Container(
//         //     decoration: BoxDecoration(
//         //       color: AppColors.black.withOpacity(.3),
//         //       borderRadius: BorderRadius.circular(10),
//         //     ),
//         //     child: DropdownButtonHideUnderline(
//         //       child: DropdownButton2<String>(
//         //         isExpanded: true,
//         //         value: controller.selectedAge.value.isNotEmpty
//         //             ? controller.selectedAge.value
//         //             : null,
//         //         buttonStyleData: ButtonStyleData(
//         //           decoration: BoxDecoration(
//         //             borderRadius: BorderRadius.circular(10),
//         //           ),
//         //           padding: const EdgeInsets.only(right: 13, top: 4, bottom: 4),
//         //         ),
//         //         dropdownStyleData: DropdownStyleData(
//         //           elevation: 0,
//         //           offset: const Offset(0, -5),
//         //           maxHeight: Get.height * .3,
//         //           scrollPadding: EdgeInsets.all(0),
//         //           decoration: BoxDecoration(
//         //             color: AppColors.black.withOpacity(0.8),
//         //             borderRadius: BorderRadius.circular(10),
//         //           ),
//         //         ),
//         //         iconStyleData: IconStyleData(
//         //             icon: SvgPicture.asset(Assets.icons.tablerIconChevronDown,
//         //                 color: AppColors.primeryTxt),
//         //             openMenuIcon: Icon(
//         //               Icons.keyboard_arrow_up_outlined,
//         //               color: AppColors.primeryTxt,
//         //             )),
//         //         hint: Text(
//         //           "Select Your Age",
//         //           style: AppTextstyles.lableStyle,
//         //         ),
//         //         items: List.generate(100, (index) => (index + 1).toString())
//         //             .map((age) => DropdownMenuItem<String>(
//         //                   value: age,
//         //                   child: MyRegularText("$age years",
//         //                       style: AppTextstyles.lableStyle),
//         //                 ))
//         //             .toList(),
//         //         onChanged: (value) {
//         //           controller.selectedAge.value = value ?? '';
//         //           controller.validateForm(); // Validate form
//         //         },
//         //       ),
//         //     ),
//         //   ),
//         // ),
//
//         // Container(
//         //   decoration: BoxDecoration(
//         //       color: AppColors.black.withOpacity(.3),
//         //       borderRadius: BorderRadius.circular(10)),
//         //   child: DropdownButtonFormField<String>(
//         //     alignment: Alignment.bottomCenter,
//         //     menuMaxHeight: Get.height * .5,
//         //     decoration: InputDecoration(
//         //       fillColor: AppColors.black.withOpacity(.3),
//         //       hintText: "Select Your Age",
//         //       hintStyle: AppTextstyles.lableStyle,
//         //       floatingLabelStyle: AppTextstyles.hintStyle,
//         //       border: OutlineInputBorder(
//         //         borderSide: BorderSide.none,
//         //         borderRadius: BorderRadius.circular(10),
//         //       ),
//         //     ),
//         //     dropdownColor: AppColors.black.withOpacity(0.8),
//         //     items: List.generate(100, (index) => (index + 1).toString())
//         //         .map((age) => DropdownMenuItem(
//         //               value: age,
//         //               child: SizedBox(
//         //                 width: 150,
//         //                 child: MyRegularText("$age years",
//         //                     style: AppTextstyles.lableStyle),
//         //               ),
//         //             ))
//         //         .toList(),
//         //     onChanged: (value) {
//         //       controller.selectedAge.value = value ?? '';
//         //       controller.validateForm(); // Validate form
//         //     },
//         //   ),
//         // ),
//
//         getVerticalHeight(10),
//         // Obx(
//         //   () => Container(
//         //     width: double.infinity,
//         //     padding: EdgeInsets.all(16),
//         //     decoration: BoxDecoration(
//         //       borderRadius: BorderRadius.circular(10),
//         //       color: AppColors.black.withOpacity(0.3),
//         //     ),
//         //     child: DirectSelect(
//         //       mode: DirectSelectMode.tap,
//         //       itemExtent: 50.0,
//         //       itemMagnification: 1,
//         //       backgroundColor: AppColors.black.withOpacity(0.5),
//         //       selectedIndex: controller.selectedGenderIndex.value,
//         //       onSelectedItemChanged: (index) {
//         //         controller.selectedGender.value =
//         //             ["Male", "Female", "Other"][index ?? 0];
//         //         controller.selectedGenderIndex.value = index!;
//         //         controller.validateForm();
//         //       },
//         //       items: ["Male", "Female", "Other"]
//         //           .map((gender) => Center(
//         //               child: Text(gender, style: AppTextstyles.lableStyle)))
//         //           .toList(),
//         //       child: Text(
//         //         controller.selectedGender.value.isNotEmpty
//         //             ? controller.selectedGender.value
//         //             : "Select Your Gender",
//         //         style: AppTextstyles.lableStyle,
//         //       ),
//         //     ),
//         //   ),
//         // ),
//
//         Obx(
//           () => Container(
//             decoration: BoxDecoration(
//               color: AppColors.black.withOpacity(.3),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton2<String>(
//                 isExpanded: true,
//                 value: controller.selectedGender.value.isNotEmpty
//                     ? controller.selectedGender.value
//                     : null,
//                 buttonStyleData: ButtonStyleData(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   padding: const EdgeInsets.only(right: 13, top: 4, bottom: 4),
//                 ),
//                 dropdownStyleData: DropdownStyleData(
//                   // offset: const Offset(0, -5),
//                   maxHeight: Get.height * .4,
//                   scrollPadding: EdgeInsets.all(0),
//                   elevation: 0,
//                   decoration: BoxDecoration(
//                     color: AppColors.black.withOpacity(0.8),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 iconStyleData: IconStyleData(
//                     icon: SvgPicture.asset(Assets.icons.tablerIconChevronDown,
//                         color: AppColors.primeryTxt),
//                     openMenuIcon: Icon(
//                       Icons.keyboard_arrow_up_outlined,
//                       color: AppColors.primeryTxt,
//                     )),
//                 hint: Text(
//                   "Select Your Gender",
//                   style: AppTextstyles.lableStyle,
//                 ),
//                 items: ["Male", "Female", "Other"]
//                     .map((gender) => DropdownMenuItem<String>(
//                           value: gender,
//                           child: MyRegularText(gender,
//                               style: AppTextstyles.lableStyle),
//                         ))
//                     .toList(),
//                 onChanged: (value) {
//                   controller.selectedGender.value = value ?? '';
//                   controller.validateForm(); // Validate form
//                 },
//               ),
//             ),
//           ),
//         ),
//
//         // Container(
//         //   decoration: BoxDecoration(
//         //       color: AppColors.black.withOpacity(.3),
//         //       borderRadius: BorderRadius.circular(10)),
//         //   child: DropdownButtonFormField<String>(
//         //     decoration: InputDecoration(
//         //       hintText: "Select Your Gender",
//         //       hintStyle: AppTextstyles.lableStyle,
//         //       floatingLabelStyle: AppTextstyles.lableStyle,
//         //       border: OutlineInputBorder(
//         //         borderSide: BorderSide.none,
//         //         borderRadius: BorderRadius.circular(10),
//         //       ),
//         //     ),
//         //     dropdownColor: AppColors.black.withOpacity(0.8),
//         //     items: ["Male", "Female", "Other"]
//         //         .map((gender) => DropdownMenuItem(
//         //               value: gender,
//         //               child: MyRegularText(gender,
//         //                   style: AppTextstyles.lableStyle),
//         //             ))
//         //         .toList(),
//         //     onChanged: (value) {
//         //       controller.selectedGender.value = value ?? '';
//         //       controller.validateForm(); // Validate form
//         //     },
//         //   ),
//         // ),
//         getVerticalHeight(Get.height * .2),
//         Obx(() {
//           final isFormValid = controller.isFormValid.value;
//           return CustomButton(
//             style: BaseTextStyle.buttonM.copyWith(
//               color: isFormValid ? AppColors.primeryTxt : AppColors.placeholder,
//             ),
//             color:
//                 isFormValid ? AppColors.red : AppColors.black.withOpacity(0.3),
//             text: AppStrings.register,
//             fun: isFormValid
//                 ? () {
//                     // Get.toNamed(Routes.INITWATCHPREF);
//                   }
//                 : () {},
//           );
//         }),
//       ],
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

class RegisterFormWidget extends ConsumerStatefulWidget {
  final String inputController;

  const RegisterFormWidget({super.key, required this.inputController});

  @override
  ConsumerState<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends ConsumerState<RegisterFormWidget>
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
      final registerFormWatch = ref.read(onBoardingController);
      registerFormWatch.disposeController(isNotify: true);
    });
  }

  Widget buildPage(BuildContext context) {
    final registerFormWatch = ref.watch(onBoardingController);

    registerFormWatch.isEmail
        ? emailController.text = widget.inputController
        : phoneNumberController.text = widget.inputController;
    return Column(
      children: [
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
        if (registerFormWatch.isEmail)
          CommonInputFormField(
            borderRadius: BorderRadius.circular(10.r),
            contentPadding: EdgeInsets.all(15.r),
            backgroundColor: AppColors.black.withOpacity(0.3),
            textEditingController: emailController,
            readOnly: registerFormWatch.isEmail,
            hintText: "Enter Email",
            validator: validateEmail,
            onChanged: (value) {},
            textInputAction: TextInputAction.next,
          ).paddingSymmetric(vertical: 7.h),
        if (!registerFormWatch.isEmail)
          CommonInputFormField(
            // radius: 10,
            borderRadius: BorderRadius.circular(10.r),
            contentPadding: EdgeInsets.all(15.r),

            backgroundColor: AppColors.black.withOpacity(0.3),
            prefixWidget: GestureDetector(
              onTap: () => showCountryCode(
                context: context,
                onSelect: (Country value) {
                  // controller.flagEmoji.value = value.flagEmoji;
                  registerFormWatch.countryCode = value.phoneCode;
                },
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  getHorizonatlWidth(
                    15.w,
                  ),
                  MyRegularText(
                    "+${registerFormWatch.countryCode}",
                    // style: Styles.primaryF11W600,
                  ),
                  getHorizonatlWidth(
                    15.w,
                  ),
                  // getHorizonatlWidth(
                  //   10,
                  // ),
                  // const Icon(Icons.arrow_drop_down),
                  // SvgPicture.asset(Assets.icons),
                  // SizedBox(
                  //   height: 24.h,
                  //   width: 1.w,
                  //   // color: ColorConstant.kPrimary,
                  // ),
                  getHorizonatlWidth(
                    10.w,
                  ),
                ],
              ),
            ),
            textEditingController: phoneNumberController,
            hintText: "Phone Number",
            readOnly: !registerFormWatch.isEmail,
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
            int? age = int.tryParse(value);
            if (age != null && age >= 10) {
              selectedAge = value;
              registerFormWatch.validateForm(
                  firstNameController,
                  lastNameController,
                  registerFormWatch.isEmail
                      ? emailController
                      : phoneNumberController,
                  ageController,
                  selectedGender);
            }
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
              value: selectedGender.isNotEmpty ? selectedGender : null,
              buttonStyleData: ButtonStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.only(right: 13.sp, top: 4.sp, bottom: 4.sp),
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
                  icon: SvgPicture.asset(Assets.icons.tablerIconChevronDown,
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
                        value: gender,
                        child: MyRegularText(gender.capitalizeFirst(),
                            style: AppTextstyles.lableStyle),
                      ))
                  .toList(),
              onChanged: (value) {
                selectedGender = value ?? '';
                registerFormWatch.validateForm(
                    firstNameController,
                    lastNameController,
                    registerFormWatch.isEmail
                        ? emailController
                        : phoneNumberController,
                    ageController,
                    selectedGender); // Validate form
              },
            ),
          ),
        ),
        getVerticalHeight(context.height * .2),
        CommonButton(
          buttonTextStyle: BaseTextStyle.buttonM.copyWith(
            color: registerFormWatch.isFormValid
                ? AppColors.primeryTxt
                : AppColors.placeholder,
          ),
          borderRadius: BorderRadius.circular(100.r),
          buttonEnabledColor: registerFormWatch.isFormValid
              ? AppColors.red
              : AppColors.black.withOpacity(0.3),
          buttonText: AppStrings.register,
          isLoading: registerFormWatch.registerUserAPIState.isLoading,
          onTap: registerFormWatch.isFormValid
              ? () {
                  registerFormWatch.registerUserApi(
                    context,
                    ref: ref,
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    dialCode: registerFormWatch.countryCode,
                    age: ageController.text,
                    gender: selectedGender,
                    inputTxt: registerFormWatch.isEmail
                        ? emailController.text
                        : phoneNumberController.text,
                  );
                  // ref
                  //     .read(navigationStackController)
                  //     .push(NavigationStackItem.initWatchPref());
                  // Get.toNamed(Routes.INITWATCHPREF);
                }
              : () {},
        ),
      ],
    );
  }

  void showCountryCode(
      {required BuildContext context,
      required void Function(Country) onSelect}) {
    showCountryPicker(
        context: context,
        showWorldWide: false,
        showPhoneCode: true,
        showSearch: true,
        countryListTheme: CountryListThemeData(
          bottomSheetHeight: context.height * 0.75,
          borderRadius: BorderRadius.circular(11.r),
          // backgroundColor: ColorConstant.kWhite,
          // textStyle: Styles.lightGreyF14W400,
          inputDecoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            // iconColor: ColorConstant.kLightPurple,
            // prefixIconColor: ColorConstant.kLightPurple,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  // color: ColorConstant.kBGColor,
                  ),
            ),
            floatingLabelStyle: TextStyle(
                // color: ColorConstant.kBGColor,
                ),
            labelText: "Search",
            border: OutlineInputBorder(),
          ),
        ),
        onSelect: onSelect);
  }
}
