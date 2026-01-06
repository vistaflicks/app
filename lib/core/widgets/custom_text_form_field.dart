import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/text_styles/app_textstyles.dart';
import 'package:vista_flicks/core/values/validator.dart';

enum CustomTextFieldValidator {
  nullCheck,
  phoneNumber,
  email,
  password,
  maxFifty,
  name,
  link
}

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final TextAlign? textAlign;
  final int? minLine;
  final int? maxLine;
  final AutovalidateMode? autovalidate;
  final bool? isReadOnly;
  final List<TextInputFormatter>? formaters;
  final CustomTextFieldValidator? validator;
  final Color? fillColor;
  final Color? borderColor;
  // final ValueChanged<String>? onChange;
  final Widget? prefix;
  final void Function(String value) onChanged;
  final TextInputAction? action;
  final TextInputType? keyboard;
  final Widget? suffix;
  final bool? dense;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? mainPadding;
  final double? radius;
  final TextStyle? hintStyle;
  final bool isEnable;

  final Function(dynamic value)? onSaved;

  const CustomTextFormField({
    super.key,
    this.hintText,
    this.controller,
    this.minLine,
    this.maxLine,
    this.formaters,
    this.isReadOnly,
    this.validator,
    this.fillColor,
    // this.onChange,
    this.prefix,
    this.keyboard,
    this.action,
    this.suffix,
    this.dense,
    this.autovalidate,
    this.borderColor,
    this.textAlign,
    this.contentPadding,
    this.radius,
    this.mainPadding,
    this.labelText,
    this.hintStyle,
    required this.onChanged,
    this.onSaved,
    this.isEnable = true,
  });

  get paddingV16H20 => null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: mainPadding ?? const EdgeInsets.symmetric(vertical: 10),
      child: IgnorePointer(
        ignoring: isReadOnly ?? false,
        child: TextFormField(
          controller: controller,
          autovalidateMode: autovalidate,
          enabled: isEnable,
          inputFormatters: formaters,
          textInputAction: action,
          textAlign: textAlign ?? TextAlign.start,
          keyboardAppearance: Brightness.light,
          readOnly: isReadOnly ?? false,
          style: AppTextstyles.lableStyle,
          minLines: minLine ?? 1,
          maxLines: maxLine ?? 1,
          onChanged: onChanged,
          validator: (String? value) {
            if (validator == CustomTextFieldValidator.nullCheck) {
              return Validator.nullCheckValidator(value);
            }
            if (validator == CustomTextFieldValidator.link) {
              if (value?.isNotEmpty ?? false) {
                return Validator.validateUrl(value!);
              } else {
                return null;
              }
            }
            if (validator == CustomTextFieldValidator.maxFifty) {
              if ((value ??= "").length > 50) {
                return "You can enter 50 letters max";
              } else {
                return null;
              }
            }
            if (validator == CustomTextFieldValidator.email) {
              return Validator.validateEmail(value);
            }
            if (validator == CustomTextFieldValidator.phoneNumber) {
              return Validator.validatePhoneNumber(value);
            }
            if (validator == CustomTextFieldValidator.password) {
              return Validator.validatePassword(value);
            }
            if (validator == CustomTextFieldValidator.name) {
              return Validator.validateName(value);
            }
            return null;
          },
          onSaved: onSaved,
          onFieldSubmitted: (value) => onSaved!(value),
          keyboardType: keyboard,
          cursorColor: AppColors.red,
          decoration: InputDecoration(
              prefixIcon: prefix,
              isDense: dense,
              suffixIcon: suffix,
              hintText: hintText,
              hintStyle: hintStyle ?? AppTextstyles.hintStyle,
              filled: true,
              labelText: labelText,
              labelStyle: AppTextstyles.lableStyle,
              fillColor: fillColor ?? AppColors.black.withOpacity(.3),
              contentPadding: contentPadding ?? paddingV16H20,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: AppColors.transparent),
                borderRadius: BorderRadius.circular(radius ?? 16.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 1.5, color: borderColor ?? AppColors.transparent),
                borderRadius: BorderRadius.circular(radius ?? 16.r),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 1.5, color: borderColor ?? AppColors.transparent),
                borderRadius: BorderRadius.circular(radius ?? 16.r),
              )),
        ),
      ),
    );
  }
}
