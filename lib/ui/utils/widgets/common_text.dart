import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../framework/provider/network/network.dart';
import '../helper/base_widget.dart';
import '../theme/app_colors.dart';
import '../theme/text_style.dart';

class CommonText extends StatelessWidget with BaseStatelessWidget {
  final String title;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final double? fontSize;
  final Color? clrfont;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextDecoration? textDecoration;
  final TextStyle? textStyle;
  final TextOverflow? textOverflow;
  final String? fontFamily;

  const CommonText({
    super.key,
    required this.title,
    this.fontWeight,
    this.fontStyle,
    this.fontSize,
    this.clrfont,
    this.maxLines,
    this.textAlign,
    this.textDecoration,
    this.textStyle,
    this.textOverflow,
    this.fontFamily,
  });

  @override
  Widget buildPage(BuildContext context) {
    return Text(
      title,
      textScaler: const TextScaler.linear(1.0),
      maxLines: maxLines ?? 1,
      textAlign: textAlign ?? TextAlign.start,
      overflow: textOverflow ?? TextOverflow.ellipsis,
      style: textStyle ??
          TextStyle(
            fontFamily: fontFamily ?? TextStyles.fontFamily,
            fontWeight: fontWeight ?? TextStyles.fwRegular,
            fontSize: fontSize ?? 14.sp,
            color: clrfont ?? AppColors.fontBlack,
            fontStyle: fontStyle ?? FontStyle.normal,
            decoration: textDecoration ?? TextDecoration.none,
          ),
    );
  }
}
