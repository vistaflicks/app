import 'package:flutter/material.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/core/widgets/common_image_view.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';

import '../../framework/controller/main/explore/explore_controller.dart';

class CommonMoviePosterListWidget extends StatelessWidget {
  const CommonMoviePosterListWidget({
    super.key,
    required this.exploreController,
    required this.posterImg,
    required this.title,
    required this.viewAll,
  });

  final ExploreController exploreController;
  final List<String> posterImg;
  final String title;
  final VoidCallback viewAll;

  @override
  Widget build(BuildContext context) {
    // print("View All ==========> pressed");
    return Column(
      children: [
        getVerticalHeight(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyRegularText(
              title,
              style: BaseTextStyle.headerM,
            ),
            GestureDetector(
              onTap: viewAll,
              child: MyRegularText(
                "VIEW ALL",
                style: BaseTextStyle.lableXs.copyWith(color: AppColors.red),
              ),
            ),
          ],
        ),
        getVerticalHeight(10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              posterImg.length,
              (index) {
                var img = posterImg[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: CommonImageView(
                    fit: BoxFit.cover,
                    radius: getRadious(6),
                    imagePath: img,
                    url: img,
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
