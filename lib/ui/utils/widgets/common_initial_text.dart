import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../framework/provider/network/network.dart';
import '../helper/base_widget.dart';
import '../theme/app_colors.dart';
import '../theme/text_style.dart';
import 'common_text.dart';

String getInitials(String text) {
  String initials = '';
  for (int i = 0; i < text.length; i++) {
    if (i == 0 || text[i - 1] == ' ' && initials.length < 3) {
      initials += text[i];
    }
  }
  return initials;
}

class CommonInitialText extends StatelessWidget with BaseStatelessWidget {
  final String text;
  final FontStyle? fontStyle;
  final double? fontSize;
  final Color? containerColor;
  final TextStyle? textStyle;
  final double? height;
  final double? width;

  const CommonInitialText({
    super.key,
    required this.text,
    this.fontStyle,
    this.fontSize,
    this.containerColor,
    this.height,
    this.width,
    this.textStyle,
  });

  @override
  Widget buildPage(BuildContext context) {
    String name = getInitials(text);
    return Container(
      decoration: BoxDecoration(
        color: containerColor ?? AppColors.primary,
        borderRadius: BorderRadius.circular(1000.r),
      ),
      height: height ?? 84.h,
      width: width ?? 84.h,
      child: Center(
        child: CommonText(
          title: name.toUpperCase(),
          textStyle: textStyle ??
              TextStyles.medium.copyWith(
                fontSize: fontSize ?? 33.sp,
                color: AppColors.white,
              ),
        ),
      ),
    );
  }
}
