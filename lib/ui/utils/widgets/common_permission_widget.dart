import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/framework/utils/extension/extension.dart';
import 'package:vista_flicks/framework/utils/extension/string_extension.dart';

import '../../../framework/provider/network/network.dart';
import '../helper/base_widget.dart';
import '../theme/app_colors.dart';
import '../theme/app_strings.g.dart';
import '../theme/text_style.dart';
import 'common_button.dart';
import 'common_text.dart';

class CommonPermissionWidget extends ConsumerWidget with BaseConsumerWidget {
  final Function() onPositiveButtonTap;

  const CommonPermissionWidget({
    super.key,
    required this.onPositiveButtonTap,
  });

  @override
  Widget buildPage(BuildContext context, ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //   Lottie.asset(
        //     Assets.anim.animCameraStorage.keyName,
        //     height: 145.h,
        //     width: 145.h,
        //     fit: BoxFit.scaleDown,
        // ).paddingOnly(top: 30.h),

        ///title
        CommonText(
          title: LocaleKeys.keyCameraStoragePermissionRequiredMessage.localized,
          textStyle: TextStyles.medium
              .copyWith(color: AppColors.black, fontSize: 18.sp),
          textAlign: TextAlign.center,
          maxLines: 3,
        ).paddingOnly(bottom: 15.h, left: 40.h, right: 40.h),

        ///Sub title
        CommonText(
          title: LocaleKeys.keyCameraStoragePermissionGrantMessage.localized,
          textStyle: TextStyles.regular
              .copyWith(color: AppColors.grey, fontSize: 14.sp),
          maxLines: 3,
          textAlign: TextAlign.center,
        ).paddingOnly(left: 40.h, right: 40.h, bottom: 30.h),

        ///Bottom Buttons
        Row(
          children: [
            Expanded(
              child: CommonButton(
                  height: 55.h,
                  buttonText: LocaleKeys.keyNotNow.localized,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  buttonEnabledColor: AppColors.primary,
                  buttonTextColor: AppColors.white),
            ),
            SizedBox(
              width: 15.w,
            ),
            Expanded(
              child: CommonButton(
                  height: 55.h,
                  buttonText: LocaleKeys.keyContinue.localized,
                  onTap: onPositiveButtonTap,
                  buttonEnabledColor: AppColors.primary,
                  buttonTextColor: AppColors.white),
            ),
          ],
        ).paddingSymmetric(horizontal: 15.w, vertical: 15.h)
      ],
    );
  }
}
