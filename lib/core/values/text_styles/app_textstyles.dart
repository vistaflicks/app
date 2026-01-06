import 'package:flutter/material.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';

class AppTextstyles {
  static TextStyle vista_flicks_txt = BaseTextStyle.headerXl.copyWith(
    color: AppColors.primeryTxt,
  );
  static TextStyle know_what_to_watch_where_to_watch_txt =
      BaseTextStyle.textMl.copyWith(
    fontFamily: "poppins",
    color: AppColors.primeryTxt,
  );
  static TextStyle hintStyle = BaseTextStyle.textXs.copyWith(
    fontSize: 16,
    color: AppColors.placeholder,
  );
  static TextStyle lableStyle = BaseTextStyle.textXs.copyWith(
    fontSize: 16,
    color: AppColors.primeryTxt,
  );
  static TextStyle continueWithPhone = BaseTextStyle.headerL.copyWith(
    fontWeight: FontWeight.w600,
    color: AppColors.primeryTxt,
  );
  static TextStyle signInWithPhone = BaseTextStyle.textM.copyWith(
    fontSize: 16,
    color: AppColors.placeholder,
  );
  static TextStyle welcomeToVistaFlicks = BaseTextStyle.headerL.copyWith(
    fontWeight: FontWeight.w600,
    color: AppColors.primeryTxt,
  );
  static TextStyle letsCreateYourAccount = BaseTextStyle.textM.copyWith(
    fontSize: 16,
    color: AppColors.secondaryTxt,
  );
}
