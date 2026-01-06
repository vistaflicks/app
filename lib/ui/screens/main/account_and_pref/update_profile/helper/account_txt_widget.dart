import 'package:flutter/material.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';

class AccountSettingTxtWidget extends StatelessWidget {
  const AccountSettingTxtWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MyRegularText(
      "Account Settings",
      style: BaseTextStyle.lableS.copyWith(color: AppColors.secondaryTxt),
    );
  }
}
