import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../../framework/provider/network/network.dart';
import '../helper/base_widget.dart';
import '../theme/app_colors.dart';
import '../theme/text_style.dart';
import 'common_image.dart';
import 'common_text.dart';

class CommonButton extends StatefulWidget {
  final double? height;
  final double? width;
  final Color? borderColor;
  final double? borderWidth;
  final BorderRadius? borderRadius;
  final String? leftImage;
  final double? leftImageHeight;
  final double? leftImageWidth;
  final double? leftImageHorizontalPadding;
  final Widget? rightIcon;
  final String? rightImage;
  final double? rightImageHeight;
  final double? rightImageWidth;
  final double? rightImageHorizontalPadding;
  final String? buttonText;
  final int? buttonMaxLine;
  final TextStyle? buttonTextStyle;
  final double? buttonHorizontalPadding;
  final bool isButtonEnabled;
  final GestureTapCallback? onTap;
  final TextAlign? buttonTextAlignment;
  final Color? buttonTextColor;
  final Color? buttonEnabledColor;
  final Color? buttonDisabledColor;
  final double? buttonTextSize;
  final bool? isLoading;
  final bool isShowLoader;
  final Color? loadingAnimationColor;
  final Widget? leftIcon;

  const CommonButton({
    super.key,
    this.height,
    this.width,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.leftImage,
    this.leftImageHeight,
    this.leftImageWidth,
    this.leftImageHorizontalPadding,
    this.rightImage,
    this.rightImageHeight,
    this.rightImageWidth,
    this.rightImageHorizontalPadding,
    this.buttonText,
    this.buttonMaxLine,
    this.buttonTextStyle,
    this.buttonHorizontalPadding,
    this.onTap,
    this.buttonTextAlignment,
    this.buttonTextColor,
    this.isButtonEnabled = true,
    this.buttonEnabledColor,
    this.buttonDisabledColor,
    this.buttonTextSize,
    this.rightIcon,
    this.isLoading,
    this.isShowLoader = true,
    this.loadingAnimationColor,
    this.leftIcon,
  });

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> with BaseStatefulWidget {
  @override
  Widget buildPage(BuildContext context) {
    Color buttonColor = widget.isButtonEnabled
        ? (widget.buttonEnabledColor ?? AppColors.primary)
        : (widget.buttonDisabledColor ?? AppColors.clrEFEFEF);
    return /*(widget.isLoading ?? false) ? shimmerLoader() : */ AbsorbPointer(
      absorbing: widget.isLoading ?? false,
      child: InkWell(
        onTap: () {
          if (widget.isButtonEnabled && !(widget.isLoading ?? false)) {
            widget.onTap?.call();
          }
        },
        child: Container(
          height: widget.height ?? 48.h,
          width: widget.width ?? double.infinity,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12.r),
            border: Border.all(
                color: widget.borderColor ?? AppColors.transparent,
                width: widget.borderWidth ?? 0),
          ),
          child: widget.isShowLoader && (widget.isLoading ?? false)
              ? Center(
                  child: LoadingAnimationWidget.waveDots(
                    color: widget.loadingAnimationColor ?? AppColors.white,
                    size: widget.height ?? 48.h,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if ((widget.leftImage ?? '').isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                widget.leftImageHorizontalPadding ?? 12.w),
                        child: CommonImage(
                          strIcon: widget.leftImage!,
                          height: widget.leftImageHeight,
                          width: widget.leftImageWidth,
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: widget.buttonHorizontalPadding ?? 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if ((widget.leftIcon != null &&
                              widget.leftImage == null))
                            widget.leftIcon ?? const Offstage(),
                          CommonText(
                            title: widget.buttonText ?? '',
                            textAlign:
                                widget.buttonTextAlignment ?? TextAlign.center,
                            maxLines: widget.buttonMaxLine ?? 1,
                            textStyle: widget.buttonTextStyle ??
                                TextStyles.bold.copyWith(
                                  fontSize: widget.buttonTextSize ?? 15.sp,
                                  color: widget.buttonTextColor ??
                                      (widget.isButtonEnabled
                                          ? AppColors.white
                                          : AppColors.black),
                                ),
                          ),
                          if ((widget.rightIcon != null &&
                              widget.rightImage == null))
                            widget.rightIcon ?? const Offstage()
                        ],
                      ),
                    ),
                    if ((widget.rightImage ?? '').isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                widget.rightImageHorizontalPadding ?? 12.w),
                        child: CommonImage(
                          strIcon: widget.rightImage!,
                          height: widget.rightImageHeight,
                          width: widget.rightImageWidth,
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget shimmerLoader() {
    return Shimmer.fromColors(
        highlightColor: AppColors.highlightColor,
        baseColor: AppColors.baseColor,
        direction: ShimmerDirection.ltr,
        period: const Duration(seconds: 2),
        child: Container(
          height: widget.height ?? 82.h,
          width: widget.width ?? 233.w,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(40.r),
            color: AppColors.black,
          ),
        ));
  }
}

/*
Widget Usage
CommonButton(
          buttonText: "Login",
          onTap: () {

          },
        )
* */
