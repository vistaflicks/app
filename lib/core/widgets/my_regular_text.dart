import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/core/values/app_colours.dart';

class MyRegularText extends StatelessWidget {
  final String label;
  final Color? color;
  final double? fontSize;
  final double? letterSpacing;
  final FontWeight? fontWeight;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final double? stepGranularity;
  final TextStyle? style;
  final TextDecorationStyle? textDecorationStyle;

  const MyRegularText(
    this.label, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.align = TextAlign.start,
    this.maxLines,
    this.decoration = TextDecoration.none,
    this.overflow = TextOverflow.ellipsis,
    this.letterSpacing,
    this.stepGranularity,
    this.style,
    this.textDecorationStyle,
  });

  @override
  Widget build(BuildContext context) {
    /*  ThemeData theme = Get.theme; */
    return label.isNotEmpty
        ? Text(
            label.isNotEmpty ? label : '',
            textAlign: align,
            maxLines: maxLines ?? 1,
            softWrap: true,
            //minFontSize: 12,
            overflow: overflow,
            style: style ??
                TextStyle(
                  color: color ?? AppColors.primeryTxt,
                  decorationStyle: textDecorationStyle,
                  fontSize: fontSize ?? 14.sp,
                  letterSpacing: letterSpacing,
                  fontWeight: fontWeight ?? FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  decoration: decoration,
                  //decorationColor: theme.de,
                  decorationThickness: 1,
                ),
          )
        : const Text('');
  }
}
