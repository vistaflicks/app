import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/values/strings.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';
import 'package:vista_flicks/ui/utils/helper/base_widget.dart';

import '../../../../../framework/controller/auth/on_boarding/on_boarding_controller.dart';
import '../../../../utils/widgets/common_button.dart';

class SentButtonsWidget extends ConsumerWidget with BaseConsumerWidget {
  const SentButtonsWidget({
    super.key,
    required this.isEmail,
    required this.inputController,
  });

  final bool isEmail;
  final TextEditingController inputController;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final onBoardingWatch = ref.watch(onBoardingController);
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: MyRegularText(
            isEmail ? AppStrings.usePhone : AppStrings.useEmail,
            style: BaseTextStyle.buttonM.copyWith(color: AppColors.placeholder),
          ),
        ),
        getVerticalHeight(20.h),
        CommonButton(
          buttonTextStyle: BaseTextStyle.buttonM.copyWith(
            color: onBoardingWatch.isInputValid
                ? AppColors.primeryTxt
                : AppColors.placeholder,
          ),
          borderRadius: BorderRadius.circular(100.r),
          buttonEnabledColor: onBoardingWatch.isInputValid
              ? AppColors.red
              : AppColors.black.withOpacity(.6),
          buttonText: AppStrings.sendCode,
          isLoading: onBoardingWatch.generateOtpAPIState.isLoading,
          onTap: onBoardingWatch.isInputValid
              ? () {
                  print("inputController===========$inputController");
                  if (onBoardingWatch.isInputValid) {
                    // onBoardingWatch.checkUserApi(context,
                    //     ref: ref,
                    //     dialCode: onBoardingWatch.countryCode,
                    //     inputTxt: inputController);
                    onBoardingWatch.generateOtpApi(context,
                        ref: ref,
                        dialCode: onBoardingWatch.countryCode,
                        inputTxt: inputController.text);

                    // ref.read(navigationStackController).push(
                    //     NavigationStackItem.verifyOtp(
                    //         isEmail: isEmail,
                    //         inputController: inputController));
                    // Get.toNamed(Routes.OTP_VERIFY,
                    //     arguments: [isEmail, controller]);
                  }
                }
              : () {},
        )
      ],
    );
  }
}
