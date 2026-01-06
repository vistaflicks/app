import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/values/strings.dart';
import 'package:vista_flicks/core/values/text_styles/app_textstyles.dart';
import 'package:vista_flicks/core/widgets/common_bg_container.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';
import 'package:vista_flicks/framework/controller/auth/on_boarding/on_boarding_controller.dart';
import 'package:vista_flicks/framework/utils/extension/extension.dart';
import 'package:vista_flicks/gen/assets.gen.dart';
import 'package:vista_flicks/ui/utils/helper/base_widget.dart';
import 'package:vista_flicks/ui/utils/widgets/common_button.dart';

import '../../../../core/values/text_styles/base_textstyle.dart';
import 'helper/otp_verify_pin_widget.dart';

class OtpVerifyScreen extends ConsumerStatefulWidget {
  final bool isEmail;
  final String inputController;

  const OtpVerifyScreen({
    required this.isEmail,
    required this.inputController,
    super.key,
  });

  @override
  ConsumerState<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends ConsumerState<OtpVerifyScreen>
    with BaseConsumerStatefulWidget {
  final TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    print(
        "inputTxt from checkUserApi ==============> ${widget.inputController}");
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final onBoardingWatch = ref.watch(onBoardingController);
      onBoardingWatch.disposeController(isNotify: true);
      onBoardingWatch.startTimer();
    });
  }

  @override
  Widget buildPage(BuildContext context) {
    final onBoardingWatch = ref.watch(onBoardingController);

    // " controller.inputController.text.toString() =============> : ${Get.arguments[1].inputController.text.toString()}");

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: CommonBgContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                getVerticalHeight(100.h),
                verifyCredTextWidget(onBoardingWatch.isEmail),
                OtpVerifyPinsWidget(
                  otpController: otpController,
                ),
                getVerticalHeight(10.h),
                Center(
                  child: onBoardingWatch.countdown > 0
                      ? MyRegularText(
                          "Didn't get the code? Please wait ${onBoardingWatch.countdown}s",
                          style: AppTextstyles.signInWithPhone,
                        )
                      : IgnorePointer(
                          ignoring:
                              onBoardingWatch.generateOtpAPIState.isLoading,
                          child: GestureDetector(
                            onTap: () {
                              onBoardingWatch.startTimer();
                              onBoardingWatch.resendOtpApi(context,
                                  ref: ref,
                                  orderId: onBoardingWatch.generateOtpAPIState
                                      .success!.data!.orderId
                                      .toString());
                            },
                            // onTap: onBoardingWatch.resendCode,
                            child: MyRegularText(
                              "Resend Code",
                              style: AppTextstyles.signInWithPhone,
                            ),
                          ),
                        ),
                ),
              ],
            ),
            // getVerticalHeight(329.h),

            // OtpVerifyButtonWidget(isOtpFilled: onBoardingWatch.isOtpFilled),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CommonButton(
        borderRadius: BorderRadius.circular(100.r),
        isLoading: onBoardingWatch.verifyOtpAPIState.isLoading,

        buttonTextStyle: BaseTextStyle.buttonM.copyWith(
          color: onBoardingWatch.isOtpFilled
              ? AppColors.primeryTxt
              : AppColors.placeholder,
        ),
        buttonEnabledColor: onBoardingWatch.isOtpFilled
            ? AppColors.red
            : AppColors.black.withOpacity(.6),
        // Invalid input, default color
        buttonText: AppStrings.verify,
        onTap: onBoardingWatch.isOtpFilled
            ? () {
                onBoardingWatch.otpVerifyApi(context,
                    ref: ref,
                    dialCode: onBoardingWatch.countryCode,
                    inputTxt: widget.inputController,
                    otp: otpController.text,
                    orderId: onBoardingWatch
                        .generateOtpAPIState.success!.data!.orderId
                        .toString());
                // ref
                //     .read(navigationStackController)
                //     .push(NavigationStackItem.registerForm());
                // Get.toNamed(Routes.REGISTER);
              }
            : () {},
      ).paddingSymmetric(horizontal: 16.w, vertical: 16.h),
    );
  }

  verifyCredTextWidget(bool isEmail) {
    final onBoardingWatch = ref.watch(onBoardingController);
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
          isEmail ? AppStrings.welcomeBack : AppStrings.verifyPhoneNumber,
          style: AppTextstyles.continueWithPhone,
        ),
        getVerticalHeight(10.h),
        MyRegularText(
          isEmail
              ? AppStrings.enterTheVerificationCodeSentToYourEmail
              : AppStrings.enterTheVerificationCodeSentToYourPhone,
          style: AppTextstyles.signInWithPhone,
        ),
        getVerticalHeight(10.h),
        MyRegularText(
          isEmail
              ? "${widget.inputController}"
              : "+${onBoardingWatch.countryCode} ${widget.inputController}",
          style: AppTextstyles.signInWithPhone
              .copyWith(color: AppColors.primeryTxt),
        ),
        getVerticalHeight(25.h),
      ],
    );
  }
}
