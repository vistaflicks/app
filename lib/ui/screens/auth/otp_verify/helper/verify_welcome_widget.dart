import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/values/strings.dart';
import 'package:vista_flicks/core/values/text_styles/app_textstyles.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';
import 'package:vista_flicks/gen/assets.gen.dart';

import '../../../../../framework/controller/auth/on_boarding/on_boarding_controller.dart';
import '../../../../utils/helper/base_widget.dart';

class VerifyOtpAndWelcomeContainerWidget extends ConsumerWidget
    with BaseConsumerWidget {
  const VerifyOtpAndWelcomeContainerWidget({
    super.key,
    required this.isEmail,
    required this.inputController,
  });

  final bool isEmail;
  final TextEditingController inputController;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final onBoardingWatch = ref.watch(onBoardingController);
    print("isEmail=================> $isEmail");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(isEmail
            ? Assets.icons.tablerIconMailOpenedFilled
            : Assets.icons.tablerIconDeviceMobile),
        getVerticalHeight(25),
        MyRegularText(
          isEmail ? AppStrings.welcomeBack : AppStrings.verifyPhoneNumber,
          style: AppTextstyles.continueWithPhone,
        ),
        MyRegularText(
          isEmail
              ? AppStrings.enterTheVerificationCodeSentToYourEmail
              : AppStrings.enterTheVerificationCodeSentToYourPhone,
          style: AppTextstyles.signInWithPhone,
        ),
        MyRegularText(
          inputController.text,
          style: AppTextstyles.signInWithPhone,
        ),
        // CustomTextFormField(
        //   validator: CustomTextFieldValidator.phoneNumber,
        //   hintText: isPhoneLogin
        //       ? AppStrings.enterPhoneNumber
        //       : AppStrings.enterEmail,
        //   controller: controller.inputController,
        //   keyboard: TextInputType.number,
        //   onChanged: controller.validatePhoneNumber,
        //   formaters: [
        //     FilteringTextInputFormatter.digitsOnly, // Allow only digits
        //     LengthLimitingTextInputFormatter(10), // Limit input to 10 digits
        //   ],
        // )
        // CustomTextFormField(
        //     validator: isEmail
        //         ? CustomTextFieldValidator.email
        //         : CustomTextFieldValidator.phoneNumber,
        //     hintText:
        //         isEmail ? AppStrings.enterEmail : AppStrings.enterPhoneNumber,
        //     controller: onBoardingWatch.inputController,
        //     keyboard:
        //         isEmail ? TextInputType.emailAddress : TextInputType.phone,
        //     onChanged: onBoardingWatch.validateInput,
        //     formaters: isEmail
        //         ? []
        //         : [
        //             FilteringTextInputFormatter
        //                 .digitsOnly, // Only digits for phone
        //             LengthLimitingTextInputFormatter(10), // Limit to 10 digits
        //           ])
      ],
    );
  }
}
