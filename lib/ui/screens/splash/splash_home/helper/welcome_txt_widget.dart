import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/values/size_constant.dart';
import '../../../../../core/values/strings.dart';
import '../../../../../core/values/text_styles/app_textstyles.dart';
import '../../../../../core/widgets/common_image_view.dart';
import '../../../../../core/widgets/my_regular_text.dart';
import '../../../../../gen/assets.gen.dart';

class WelcomeTxtWidget extends StatelessWidget {
  const WelcomeTxtWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonImageView(
          height: 80.h,
          imagePath: Assets.images.vistaFlicksSplashLogo.path,
        ),
        getVerticalHeight(10.h),
        MyRegularText(
          AppStrings.vistaFlicks,
          style: AppTextstyles.vista_flicks_txt,
        ),
        // getVerticalHeight(0.h),
        Opacity(
          opacity: 0.7,
          child: Column(
            children: [
              MyRegularText(
                AppStrings.knowWhatToWatch,
                style: AppTextstyles.know_what_to_watch_where_to_watch_txt,
              ),
              MyRegularText(
                AppStrings.WhereToWatch,
                style: AppTextstyles.know_what_to_watch_where_to_watch_txt,
              ),
            ],
          ),
        )
      ],
    );
  }
}
