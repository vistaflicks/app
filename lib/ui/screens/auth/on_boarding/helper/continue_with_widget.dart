import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/values/strings.dart';
import 'package:vista_flicks/core/values/text_styles/app_textstyles.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';
import 'package:vista_flicks/framework/utils/extension/context_extension.dart';
import 'package:vista_flicks/gen/assets.gen.dart';
import 'package:vista_flicks/ui/utils/const/form_validations.dart';
import 'package:vista_flicks/ui/utils/widgets/common_form_field.dart';

import '../../../../../framework/controller/auth/on_boarding/on_boarding_controller.dart';
import '../../../../utils/helper/base_widget.dart';

class ContinueWithWidget extends ConsumerWidget with BaseConsumerWidget {
  final bool isEmail;
  final TextEditingController inputController;

  const ContinueWithWidget({
    super.key,
    required this.isEmail,
    required this.inputController,
  });

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final onBoardingWatch = ref.watch(onBoardingController);

    print("isEmail=================> $isEmail");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 60.h,
          width: 60.w,
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
              color: AppColors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(30)),
          child: Lottie.asset(
              isEmail
                  ? Assets.lottie.mailAnimation
                  : Assets.lottie.mobileIconAnimation,
              width: 36.w,
              height: 36.h),
          // child: SvgPicture.asset(isEmail
          //     ? Assets.icons.tablerIconMailOpenedFilled
          //     : Assets.icons.tablerIconDeviceMobile),
        ),
        getVerticalHeight(25.h),
        MyRegularText(
          isEmail ? AppStrings.continueWithEmail : AppStrings.continueWithPhone,
          style: AppTextstyles.continueWithPhone,
        ),
        getVerticalHeight(10.h),
        MyRegularText(
          isEmail
              ? AppStrings.signInOrSignUpWithYourEmail
              : AppStrings.signInOrSignUpWithYourPhone,
          style: AppTextstyles.signInWithPhone,
        ),
        getVerticalHeight(25),
        CommonInputFormField(
          contentPadding: EdgeInsets.all(15.r),
          backgroundColor: AppColors.black.withOpacity(0.3),
          prefixWidget: !isEmail
              ? GestureDetector(
                  onTap: () => showCountryCode(
                    context: context,
                    onSelect: (Country value) {
                      // controller.flagEmoji.value = value.flagEmoji;
                      onBoardingWatch.countryCode = value.phoneCode;
                      onBoardingWatch.countryPick(value.phoneCode);
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
                        "+${onBoardingWatch.countryCode}",
                        style: BaseTextStyle.textM,
                      ),
                      // getHorizonatlWidth(
                      //   15.w,
                      // ),
                      // const Icon(Icons.arrow_drop_down),
                      // SvgPicture.asset(Assets.icons),

                      getHorizonatlWidth(
                        10,
                      ),
                    ],
                  ),
                )
              : null,

          // validator: isEmail
          //     ? CustomTextFieldValidator.email
          //     : CustomTextFieldValidator.phoneNumber,
          textEditingController: inputController,
          hintText:
              isEmail ? AppStrings.enterEmail : AppStrings.enterPhoneNumber,
          // controller: onBoardingWatch.inputController,
          textInputType:
              isEmail ? TextInputType.emailAddress : TextInputType.phone,
          // keyboard: isEmail ? TextInputType.emailAddress : TextInputType.phone,
          // onChanged: onBoardingWatch.validateInput,
          validator: isEmail ? validateEmail : validateMobile,
          // formaters: isEmail
          //     ? []
          //     : [
          //         FilteringTextInputFormatter
          //             .digitsOnly, // Only digits for phone
          //         LengthLimitingTextInputFormatter(10), // Limit to 10 digits
          //       ],
        )
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
          borderRadius: BorderRadius.circular(11),
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
