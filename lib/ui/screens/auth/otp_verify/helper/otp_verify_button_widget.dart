import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/strings.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/core/widgets/custom_button.dart';

import '../../../../../framework/controller/auth/on_boarding/on_boarding_controller.dart';
import '../../../../utils/helper/base_widget.dart';

class OtpVerifyButtonWidget extends ConsumerWidget with BaseConsumerWidget {
  const OtpVerifyButtonWidget({
    super.key,
    required this.isOtpFilled,
  });

  final bool isOtpFilled;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final onBoardingWatch = ref.watch(onBoardingController);

    return CustomButton(
      style: BaseTextStyle.buttonM.copyWith(
        color: onBoardingWatch.isOtpFilled
            ? AppColors.primeryTxt
            : AppColors.placeholder,
      ),
      color: onBoardingWatch.isOtpFilled
          ? AppColors.red
          : AppColors.black.withOpacity(.6),
      // Invalid input, default color
      text: AppStrings.verify,
      fun: onBoardingWatch.isOtpFilled
          ? () {
              // onBoardingWatch.otpVerifyApi(context, ref: ref, dialCode: dialCode, inputTxt: inputTxt, otp: otp, orderId: orderId)
              // ref
              //     .read(navigationStackController)
              //     .push(NavigationStackItem.registerForm());
              // Get.toNamed(Routes.REGISTER);
            }
          : () {},
    );
  }
}
