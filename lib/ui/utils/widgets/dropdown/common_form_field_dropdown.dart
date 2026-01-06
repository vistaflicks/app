import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/framework/utils/extension/context_extension.dart';

import '../../../../framework/provider/network/network.dart';
import '../../helper/base_widget.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_style.dart';
import '../common_text.dart';
import 'custom_input_decorator.dart';
import 'dropdown_button2.dart';

class CommonDropdownInputFormField<T> extends StatefulWidget {
  final List? menuItems;
  final double? borderWidth;
  final double? height;
  final String? Function(T?)? validator;
  final T? defaultValue;
  final Color? borderColor;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final TextStyle? labelTextStyle;
  final TextStyle? textStyle;
  final Widget? suffixWidget;
  final double? borderRadius;
  final double? iconWidth;
  final double? iconHeight;
  final bool? isEnabled;
  final EdgeInsetsGeometry? contentPadding;
  final void Function(T? value)? onChanged;
  final void Function(bool? value)? onStateChanged;
  final List<DropdownMenuItem<T>>? items;
  final DropdownButtonBuilder? selectedItemBuilder;
  final TextEditingController? textEditingController;
  final Function(String value)? searchMatchFn;
  final List<DropdownMenuItem<T>>? itemListBuilder;
  final bool isFilled;

  const CommonDropdownInputFormField({
    super.key,
    this.menuItems,
    this.itemListBuilder,
    this.isEnabled,
    this.borderWidth,
    this.validator,
    this.borderColor,
    this.hintText,
    this.hintTextStyle,
    this.labelTextStyle,
    this.textStyle,
    this.defaultValue,
    this.borderRadius,
    this.suffixWidget,
    this.onChanged,
    this.onStateChanged,
    this.height,
    this.iconWidth,
    this.iconHeight,
    this.contentPadding,
    this.items,
    this.selectedItemBuilder,
    this.textEditingController,
    this.searchMatchFn,
    this.isFilled = false,
  });

  @override
  State<CommonDropdownInputFormField<T>> createState() =>
      _CommonDropdownInputFormFieldState<T>();
}

class _CommonDropdownInputFormFieldState<T>
    extends State<CommonDropdownInputFormField<T>> with BaseStatefulWidget {
  @override
  Widget buildPage(BuildContext context) {
    return AbsorbPointer(
      absorbing: !(widget.isEnabled ?? true),
      child: DropdownButtonFormField2<T>(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        value: widget.defaultValue,
        onMenuStateChange: widget.onStateChanged,
        decoration: CustomInputDecoration(
          alignLabelWithHint: true,
          fillColor: AppColors.white,
          filled: widget.isFilled,
          suffixIconColor: AppColors.grey,
          isDense: true,
          contentPadding: widget.contentPadding ??
              EdgeInsets.symmetric(vertical: 19.h, horizontal: 0),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.greyLight,
              width: widget.borderWidth ?? 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.borderColor ?? AppColors.greyLight,
              width: widget.borderWidth ?? 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.r),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.redDark,
              width: widget.borderWidth ?? 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.borderColor ?? AppColors.greyLight,
              width: widget.borderWidth ?? 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.r),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: AppColors.redDark,
                width: widget.borderWidth ?? 1,
                style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.r),
          ),
          errorStyle: TextStyles.regular
              .copyWith(color: AppColors.errorColor, fontSize: 16.sp),
          errorPadding: EdgeInsets.only(left: 11.w),
          border: InputBorder.none,
          labelText: widget.hintText,
          hintText: widget.hintText,
          labelStyle: widget.labelTextStyle ??
              TextStyles.medium
                  .copyWith(fontSize: 14.sp, color: AppColors.greyLight),
        ),
        isExpanded: true,
        hint: CommonText(
          title: widget.hintText ?? '',
          textStyle: widget.hintTextStyle ??
              TextStyles.medium.copyWith(color: AppColors.greyLight),
        ),
        style: widget.hintTextStyle ??
            TextStyles.medium.copyWith(color: AppColors.greyLight),
        items: widget.itemListBuilder ??
            widget.items ??
            ((widget.menuItems != null)
                ? widget.menuItems!
                    .map(
                      (item) => DropdownMenuItem<T>(
                        value: item,
                        child: Text(item,
                            style: widget.textStyle ??
                                TextStyles.medium
                                    .copyWith(color: AppColors.black)),
                      ),
                    )
                    .toList()
                : []),
        selectedItemBuilder: widget.selectedItemBuilder,
        validator: widget.validator,
        onChanged: (value) {
          widget.onChanged?.call(value);
        },
        onSaved: (value) {},
        buttonStyleData: ButtonStyleData(
            height: widget.height,
            padding: EdgeInsets.only(right: 18.w),
            decoration: const BoxDecoration(
              color: AppColors.transparent,
            )),
        iconStyleData: IconStyleData(
          icon: widget.suffixWidget ?? const Icon(Icons.arrow_drop_down),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: context.height * 0.4,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
      ),
    );
  }
}
