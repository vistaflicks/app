import 'package:vista_flicks/framework/utils/extension/string_extension.dart';

import '../theme/app_strings.g.dart';
import 'app_constants.dart';

String? validateText(String? value, String error, {int? minLength}) {
  if (value == null || value.trim().isEmpty) {
    return error;
  } else {
    return null;
  }
}

String? validateNewText(String? value, String error, {int? minLength}) {
  if (value == null ||
      value.trim().isEmpty ||
      value.trim().length < (minLength ?? 3)) {
    return error;
  } else {
    return null;
  }
}

String? validateDropDown(String? value, String error) {
  if (value == null) {
    return error;
  } else {
    return null;
  }
}

String? validatePhoneNumber(String? value) {
  if (value == null || value.trim().isEmpty) {
    return LocaleKeys.keyPhoneNumberRequired.localized;
  } else if (value.trim().length < maxMobileLength) {
    return LocaleKeys.keyPhoneNumberInvalid.localized;
  }
  return null;
}

String? validateTextIgnoreLength(String? value, String error) {
  if (value == null || value.trim().isEmpty) {
    return error;
  } else {
    return null;
  }
}

RegExp mobileRegEx = RegExp(r'[0-9]');
Pattern emailRegex =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

String? validateMobile(String? value) {
  if (value == null || value == '') {
    return LocaleKeys.keyContactNumberValidation.localized;
  } else if (value.trim().length > 3 && value.trim().length < maxMobileLength) {
    return LocaleKeys.keyContactNumberLengthValidation.localized;
  } else {
    return null;
  }
}

/// Validation function for the validate email
String? validateEmail(String? value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern.toString());
  if (value == null || value.trim().isEmpty) {
    return LocaleKeys.keyEmailRequired.localized;
  } else if (!regex.hasMatch(value)) {
    return LocaleKeys.keyInvalidEmailValidation.localized;
  } else {
    return null;
  }
}

String? validateOtp(String? value) {
  if (value == null ||
      value.trim().isEmpty ||
      value.trim().length < otpLength) {
    return LocaleKeys.keyOtpInvalid.localized;
  } else {
    return null;
  }
}

String? validatePassword(
    {String? value,
    bool forPass = false,
    bool forCurrentPass = false,
    bool changePassword = false}) {
  String removeWhiteSpace = value!.replaceAll(' ', '');

  bool hasUppercase = removeWhiteSpace.contains(RegExp(r'[A-Z]'));
  bool hasDigits = removeWhiteSpace.contains(RegExp(r'[0-9]'));
  bool hasLowercase = removeWhiteSpace.contains(RegExp(r'[a-z]'));
  bool hasSpecialCharacters =
      removeWhiteSpace.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  if (value.removeWhiteSpace.isEmpty) {
    return forPass
        ? changePassword
            ? LocaleKeys.keyNewPasswordRequiredValidation.localized
            : LocaleKeys.keyPasswordRequiredValidation.localized
        : forCurrentPass
            ? LocaleKeys.keyCurrentPasswordRequiredValidation.localized
            : LocaleKeys.keyConfirmPasswordRequiredValidation.localized;
  } else if (value.removeWhiteSpace.length > 16 ||
      value.removeWhiteSpace.length < 8) {
    return forPass
        ? changePassword
            ? LocaleKeys.keyNewPasswordRangeValidation.localized
            : LocaleKeys.keyPasswordRangeValidation.localized
        : forCurrentPass
            ? LocaleKeys.keyCurrentPasswordRangeValidation.localized
            : LocaleKeys.keyConfirmPasswordRangeValidation.localized;
  } else if (!hasUppercase) {
    return forPass
        ? changePassword
            ? LocaleKeys.keyNewPasswordUpperCaseValidation.localized
            : LocaleKeys.keyPasswordUpperCaseValidation.localized
        : forCurrentPass
            ? LocaleKeys.keyCurrentPasswordUpperCaseValidation.localized
            : LocaleKeys.keyConfirmPasswordUpperCaseValidation.localized;
  } else if (!hasLowercase) {
    return forPass
        ? changePassword
            ? LocaleKeys.keyNewPasswordLowerCaseValidation.localized
            : LocaleKeys.keyPasswordLowerCaseValidation.localized
        : forCurrentPass
            ? LocaleKeys.keyCurrentPasswordLowerCaseValidation.localized
            : LocaleKeys.keyConfirmPasswordLowerCaseValidation.localized;
  } else if (!hasDigits) {
    return forPass
        ? changePassword
            ? LocaleKeys.keyNewPasswordNumericValueValidation.localized
            : LocaleKeys.keyPasswordNumericValueValidation.localized
        : forCurrentPass
            ? LocaleKeys.keyCurrentPasswordNumericValueValidation.localized
            : LocaleKeys.keyConfirmPasswordNumericValueValidation.localized;
  } else if (!hasSpecialCharacters) {
    return forPass
        ? changePassword
            ? LocaleKeys.keyNewPasswordSpecialCharacterValidation.localized
            : LocaleKeys.keyPasswordSpecialCharacterValidation.localized
        : forCurrentPass
            ? LocaleKeys.keyCurrentPasswordSpecialCharacterValidation.localized
            : LocaleKeys.keyConfirmPasswordSpecialCharacterValidation.localized;
  } else {
    return null;
  }
}
