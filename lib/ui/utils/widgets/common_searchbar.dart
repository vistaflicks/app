import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../framework/provider/network/network.dart';
import '../const/app_constants.dart';
import '../helper/base_widget.dart';
import '../theme/app_colors.dart';
import '../theme/text_style.dart';
import 'common_image.dart';

class CommonSearchBar extends StatelessWidget with BaseStatelessWidget {
  final double? height;
  final double? width;
  final String rightIcon;
  final Function()? onTap;
  final Widget? suffix;
  final Function(PointerDownEvent)? onTapOutside;
  final ValueChanged<String>? onChanged;
  final double? elevation;
  final double? circularValue;
  final Color? clrSplash;
  final Color? clrSearchIcon;
  final Color? textColor;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final double? borderRadius;
  final String placeholder;
  final String leftIcon;
  final Function()? onClearSearch;
  final Color? borderColor;
  final Color? bgColor;
  final Color? cursorColor;
  final double? borderWidth;
  final ValueChanged<String>? onFieldSubmitted;

  const CommonSearchBar({
    super.key,
    required this.controller,
    this.onTap,
    this.onClearSearch,
    this.height,
    this.width,
    this.rightIcon = '',
    this.leftIcon = '',
    this.onChanged,
    this.elevation,
    this.circularValue,
    this.clrSplash,
    this.clrSearchIcon,
    this.textColor,
    this.borderRadius,
    this.focusNode,
    this.placeholder = '',
    this.bgColor,
    this.borderColor,
    this.borderWidth,
    this.cursorColor,
    this.onTapOutside,
    this.onFieldSubmitted,
    this.suffix,
    this.hintStyle,
    this.labelStyle,
  });

  @override
  Widget buildPage(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor ?? AppColors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? 20.r),
        border: Border.all(
          color: borderColor ?? AppColors.transparent,
          width: (borderWidth ?? 0.5).w,
        ),
      ),
      width: width ?? double.infinity,
      constraints: BoxConstraints(maxHeight: height ?? 48.h),
      height: height ?? 48.h,
      child: InkWell(
        splashColor: clrSplash ?? AppColors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(circularValue ?? 7.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(left: 10.w, right: 0.w),
          child: Center(
            child: TextFormField(
              controller: controller,
              focusNode: focusNode,
              cursorColor: cursorColor ?? AppColors.black,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyles.regular.copyWith(
                  color: textColor ?? AppColors.primary, fontSize: 14.sp),
              textInputAction: TextInputAction.search,
              onChanged: onChanged,
              onFieldSubmitted: onFieldSubmitted,
              maxLines: 1,
              onTapOutside: (v) {
                hideKeyboard(context);
              },
              inputFormatters: [
                LengthLimitingTextInputFormatter(100),
              ],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                isDense: true,
                border: InputBorder.none,
                hintStyle: hintStyle ??
                    TextStyles.regular
                        .copyWith(color: AppColors.greyLight, fontSize: 14.sp),
                prefixIcon: (leftIcon.isNotEmpty)
                    ? Padding(
                        padding: EdgeInsets.only(
                            top: 10.h, bottom: 10.h, right: 16.w),
                        child: (leftIcon.contains('.svg'))
                            ? CommonImage(
                                strIcon: leftIcon,
                                boxFit: BoxFit.scaleDown,
                                height: 18.h,
                                width: 18.w,
                                imgColor: clrSearchIcon ?? AppColors.primary,
                              )
                            : Image.asset(
                                leftIcon,
                                height: 18.h,
                                width: 18.w,
                                fit: BoxFit.scaleDown,
                                color: clrSearchIcon ?? AppColors.primary,
                              ),
                      )
                    : const Offstage(),
                prefixIconConstraints:
                    BoxConstraints(minHeight: 10.h, minWidth: 20.w),
                hintText: placeholder,
                suffixIcon: (rightIcon.isNotEmpty)
                    ? Padding(
                        padding: EdgeInsets.only(
                            top: 10.h, bottom: 10.h, right: 16.w),
                        child: (rightIcon.contains('.svg'))
                            ? CommonImage(
                                strIcon: rightIcon,
                              )
                            : Image.asset(
                                rightIcon,
                                height: 18.h,
                                width: 18.w,
                                color: clrSearchIcon ?? AppColors.primary,
                              ),
                      )
                    : suffix ?? const Offstage(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*  Widget Usage
*
CommonSearchBar(leftIcon: AppAssets.svgDrawerMenu, controller: txtSearch)
* */
