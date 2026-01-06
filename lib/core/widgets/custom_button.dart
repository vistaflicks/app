import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/core/utils/build_context.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/core/widgets/common_image_view.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final String? icon;
  final String? leftIcon;
  final VoidCallback fun;
  final double? iconSize;
  final double? width;
  final double? radius;
  final double? height;
  final bool? isLoading;
  final Color? color;
  final Color? borderColor;
  final Color? iconColor;
  final Color? leftIconColor;
  final EdgeInsetsGeometry? padding;
  final bool isDisabled;

  final TextStyle? style;
  const CustomButton({
    super.key,
    required this.text,
    required this.fun,
    this.color,
    this.borderColor,
    this.iconSize,
    this.isLoading = false,
    this.width,
    this.height,
    this.icon,
    this.style,
    this.iconColor,
    this.leftIcon,
    this.leftIconColor,
    this.radius,
    this.padding,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? context.screenWidth,
      height: height ?? 50.h,
      child: ElevatedButton(
        onPressed: isLoading == true
            ? () {
                print("loading");
              }
            : () async {
                // if (await Vibration.hasVibrator() == true) {
                //   Vibration.vibrate(duration: 1);
                // }
                fun.call();
              },
        style: ElevatedButton.styleFrom(
          textStyle: style ?? BaseTextStyle.buttonM,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 100.r),
          ),
          enableFeedback: true,
          backgroundColor: color ??
              (isDisabled ? AppColors.black.withOpacity(.6) : AppColors.red),
        ),
        child: isLoading == true
            ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 4,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Visibility(
                    visible: leftIcon != null,
                    child: leftIcon?.endsWith(".svg") == true
                        ? CommonImageView(
                            svgPath: leftIcon ?? '',
                            width: iconSize ?? 20.h,
                            height: iconSize ?? 20.h,
                            color: leftIconColor ?? AppColors.primeryTxt,
                          )
                        : CommonImageView(
                            imagePath: leftIcon ?? '',
                            width: iconSize ?? 20.h,
                            height: iconSize ?? 20.h,
                            color: leftIconColor ?? AppColors.primeryTxt,
                          ),
                  ),
                  Visibility(
                    visible: leftIcon != null,
                    child: SizedBox(width: 6.w),
                  ),
                  MyRegularText(
                    text,
                    style: style ?? BaseTextStyle.buttonM,
                  ),
                  Visibility(
                    visible: icon != null,
                    child: SizedBox(width: 6.w),
                  ),
                  Visibility(
                    visible: icon != null,
                    child: icon?.endsWith(".svg") == true
                        ? CommonImageView(
                            svgPath: icon ?? '',
                            width: 20.h,
                            height: 20.h,
                            color: iconColor ?? AppColors.primeryTxt,
                          )
                        : CommonImageView(
                            imagePath: icon ?? '',
                            width: 20.h,
                            height: 20.h,
                            color: iconColor ?? AppColors.primeryTxt,
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
