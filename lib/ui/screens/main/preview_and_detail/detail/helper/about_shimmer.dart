import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';
import 'package:vista_flicks/framework/controller/main/preview_and_detail/model/get_about_content_model.dart';
import 'package:vista_flicks/gen/assets.gen.dart';
import 'package:vista_flicks/ui/screens/main/preview_and_detail/detail/helper/about_tab_widget.dart';
import 'package:vista_flicks/ui/utils/theme/theme.dart';

import '../../../../../../core/values/app_colours.dart';
import '../../../../../../core/values/text_styles/base_textstyle.dart';

class AboutShimmer extends StatelessWidget {
  const AboutShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.primeryTxt.withOpacity(0.2),
      highlightColor: AppColors.black,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      // height: 50,
                      // width: 50,
                      Assets.images.imdb,
                    ),
                    getHorizonatlWidth(10),
                    MyRegularText(
                      "0.00",
                      // "7.7/10 350k Reviews",
                      style: BaseTextStyle.textM,
                    ),
                  ],
                ),
                SvgPicture.asset(
                  Assets.icons.tablerIconArrowDownLeft,
                  color: AppColors.secondaryTxt,
                )
              ],
            ),
            getVerticalHeight(20),
            Row(
              children: [
                SvgPicture.asset(
                  height: getHeight(18),
                  Assets.icons.tablerIconClockHour7,
                  color: AppColors.primeryTxt,
                ),
                getHorizonatlWidth(10),
                MyRegularText(
                  "00:00",
                  style: BaseTextStyle.textM,
                ),
                getHorizonatlWidth(40),
                SvgPicture.asset(
                  height: getHeight(18),
                  Assets.icons.tablerIconCalendarEvent,
                  color: AppColors.primeryTxt,
                ),
                getHorizonatlWidth(10),
                MyRegularText(
                  "01/01/2024",
                  // "24 Mar 2024",
                  style: BaseTextStyle.textM,
                ),
              ],
            ),
            getVerticalHeight(20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  10,
                  (index) {
                    return Container(
                      decoration: BoxDecoration(color: AppColors.lightGray2),
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.symmetric(horizontal: getWidth(5)),
                      child: MyRegularText(
                        'genre?.name ?? ""',
                        style: BaseTextStyle.lableXs,
                      ),
                    );
                  },
                ),
              ),
            ),
            getVerticalHeight(20),
            MyRegularText(
              "About",
              style:
                  BaseTextStyle.lableM.copyWith(color: AppColors.secondaryTxt),
            ),
            Column(
              children: List.generate(4, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: getHeight(2)),
                  height: 10.h,
                  color: AppColors.lightGray2,
                );
              }),
            ),
            getVerticalHeight(10),
            CastCrewWidget(
              items: List.generate(10, (index) => Cast()).toList(),
              title: "Cast",
            ),
            CastCrewWidget(
              items: List.generate(10, (index) => Cast()).toList(),
              title: "Team",
            ),
          ],
        ),
      ),
    );
  }
}
