import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/core/values/app_colours.dart';

import '../../../../../core/values/size_constant.dart';
import '../../../../../core/values/text_styles/base_textstyle.dart';
import '../../../../../core/widgets/common_bg_container.dart';
import '../../../../../core/widgets/my_regular_text.dart';
import '../../../../utils/helper/base_widget.dart';

class ContactVistaFlicksScreen extends ConsumerWidget with BaseConsumerWidget {
  const ContactVistaFlicksScreen({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.black.withOpacity(0.2),
      appBar: AppBar(
        backgroundColor: AppColors.black,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        centerTitle: true,
        foregroundColor: AppColors.primeryTxt,
        title: MyRegularText(
          "Contact Vista Reels",
          style: BaseTextStyle.headerM,
        ),
      ),
      body: CommonBgContainer(
        padding: EdgeInsets.symmetric(
            horizontal: getWidth(20.w), vertical: getHeight(10.h)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "We’d love to hear from you! Whether you have a question, feedback, or need support, our team is here to help.",
              style: BaseTextStyle.textS.copyWith(fontWeight: FontWeight.w500),
            ),
            getVerticalHeight(10.h),
            Text(
              "Email: support@vistaflicks.com",
              style: BaseTextStyle.textS.copyWith(fontWeight: FontWeight.w500),
            ),
            getVerticalHeight(10.h),
            Text(
              "Phone: +91 2345678900",
              style: BaseTextStyle.textS.copyWith(fontWeight: FontWeight.w500),
            ),
            getVerticalHeight(10.h),
            Text(
              "For quick assistance, visit our terms of use,Let’s stay connected!",
              style: BaseTextStyle.textS.copyWith(fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
