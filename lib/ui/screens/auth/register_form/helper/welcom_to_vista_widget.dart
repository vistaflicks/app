import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/core/values/strings.dart';
import 'package:vista_flicks/core/values/text_styles/app_textstyles.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';

import '../../../../../core/values/size_constant.dart';

class WelcomeToVistaFlicksWidget extends StatelessWidget {
  const WelcomeToVistaFlicksWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyRegularText(
          AppStrings.welcomeToVistaFlicks,
          style: AppTextstyles.welcomeToVistaFlicks,
        ),
        getVerticalHeight(10.h),
        MyRegularText(
          AppStrings.letsCreateYourAccount,
          style: AppTextstyles.letsCreateYourAccount,
        ),
      ],
    );
  }
}
