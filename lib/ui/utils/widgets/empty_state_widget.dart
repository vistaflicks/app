import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/framework/utils/extension/context_extension.dart';
import 'package:vista_flicks/framework/utils/extension/string_extension.dart';

import '../helper/base_widget.dart';
import '../theme/app_colors.dart';
import '../theme/app_strings.g.dart';
import '../theme/text_style.dart';
import '../theme/theme.dart';
import 'common_text.dart';

class EmptyStateWidget extends StatelessWidget with BaseStatelessWidget {
  final String? icon;
  final String? title;
  final String? description;
  final double? svgHeight;
  final double? svgWidth;

  const EmptyStateWidget(
      {super.key,
      this.icon,
      this.title,
      this.description,
      this.svgHeight,
      this.svgWidth});

  @override
  Widget buildPage(BuildContext context) {
    return SizedBox(
      height: context.height * 0.7,
      width: context.width,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SizedBox(
                //   height: svgHeight ?? 100.h,
                //   width: svgWidth ?? 100.h,
                //   child: CommonImage(strIcon: icon ?? Assets.svgs.svgNoData.keyName),
                // ),
                SizedBox(height: 10.h),
                CommonText(
                  title: title ?? LocaleKeys.keyNoDataFound.localized,
                  textStyle: TextStyles.medium
                      .copyWith(fontSize: 18.sp, color: AppColors.black),
                ),
                SizedBox(height: 10.h),
                CommonText(
                  title: description ?? '',
                  textStyle: TextStyles.medium
                      .copyWith(fontSize: 16.sp, color: AppColors.greyMedium),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
