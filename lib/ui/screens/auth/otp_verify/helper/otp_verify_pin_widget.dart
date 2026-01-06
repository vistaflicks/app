import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';

import '../../../../../framework/controller/auth/on_boarding/on_boarding_controller.dart';
import '../../../../utils/helper/base_widget.dart';

class OtpVerifyPinsWidget extends ConsumerWidget with BaseConsumerWidget {
  const OtpVerifyPinsWidget({
    required this.otpController,
    super.key,
  });

  final TextEditingController otpController;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final onBoardingWatch = ref.watch(onBoardingController);

    // ref.listen(onBoardingController.select((state) => state.otpController.text),
    //     (previous, next) {
    //   onBoardingWatch.isOtpFilled = next.length == 6;
    // });
    return Container(
      padding: EdgeInsets.only(
        top: getHeight(15.h),
        bottom: getHeight(10.h),
        left: getWidth(45.w),
        right: getWidth(45.w),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.black.withOpacity(0.3)),
      child: Center(
        child: PinCodeTextField(
          onCompleted: (value) {
            print("onCompleted ========> $otpController ");
            print(
                "onCompleted onBoardingWatch.isOtpFilled ========> ${onBoardingWatch.isOtpFilled} ");
            // print(
            //     "onCompleted ========> ${onBoardingWatch.checkOTPValidation} ");
            onBoardingWatch.checkOTPValidation(value);
          },
          onSubmitted: (value) {
            print("onSubmitted ========> ${otpController.text}");
            print(
                "onSubmitted onBoardingWatch.isOtpFilled ========> ${onBoardingWatch.isOtpFilled} ");
          },

          autoUnfocus: true,
          autoDismissKeyboard: true,
          enablePinAutofill: true,
          controller: otpController,
          autoFocus: true,
          pinTheme: PinTheme(
            // fieldOuterPadding: EdgeInsets.all(7),
            shape: PinCodeFieldShape.underline,

            // disabledColor: AppColours.primeryTxt,
            activeColor: Colors.transparent,
            inactiveColor: AppColors.placeholder,
            selectedColor: AppColors.primeryTxt,
            fieldHeight: getHeight(30.w),
            fieldWidth: getWidth(16.w),
            // activeFillColor: Colors.white,
            // inactiveFillColor: Colors.white,
            // selectedFillColor: Colors.white,
          ),
          onChanged: (value) {
            print("onChanged ========> ${otpController.text}");
            print(
                "onChanged onBoardingWatch.isOtpFilled ========> ${onBoardingWatch.isOtpFilled} ");
            onBoardingWatch.checkOTPValidation(value);
          },
          cursorColor: Colors.transparent,
          appContext: context,
          length: 6,
          keyboardType: TextInputType.number,
          textStyle: BaseTextStyle.buttonL,
          // For displaying '0' as a default value in each field, use a custom `TextEditingController`
        ),
      ),
    );
  }
}
