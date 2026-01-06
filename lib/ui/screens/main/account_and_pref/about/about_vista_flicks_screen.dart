import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/core/widgets/common_bg_container.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';
import 'package:vista_flicks/ui/utils/helper/base_widget.dart';

import '../../../../../core/values/app_colours.dart';

class AboutVistaFlicksScreen extends ConsumerWidget with BaseConsumerWidget {
  const AboutVistaFlicksScreen({super.key});

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
          "About Vista Reels",
          style: BaseTextStyle.headerM,
        ),
      ),
      body: CommonBgContainer(
        padding: EdgeInsets.symmetric(
            horizontal: getWidth(16.w), vertical: getHeight(10.h)),
        child: Column(
          children: [
            Text(
              "Vista Reels – Your Gateway to Endless Entertainment",
              style:
                  BaseTextStyle.headerL.copyWith(fontWeight: FontWeight.w600),
            ),
            getVerticalHeight(10.h),
            Text(
              "At Vista Reels, we bring the world of entertainment closer to you! Our platform is designed to help movie and series enthusiasts discover the latest and most trending content across various OTT platforms. While you can't watch content directly on Vista Reels, we ensure you never miss out by seamlessly redirecting you to your favorite streaming services.",
              style: BaseTextStyle.textS.copyWith(fontWeight: FontWeight.w500),
            ),
            getVerticalHeight(10.h),
            Text(
              "With a passion for storytelling and a keen eye on the ever-evolving entertainment industry, we curate the best movies and shows, providing insights, trailers, and recommendations tailored to your preferences. Whether you're looking for the next binge-worthy series or an exciting new film, Vista Reels is your go-to destination for navigating the vast world of digital entertainment.",
              style: BaseTextStyle.textS.copyWith(fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
