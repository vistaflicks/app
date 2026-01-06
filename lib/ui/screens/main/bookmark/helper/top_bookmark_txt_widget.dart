import 'package:flutter/material.dart';

import '../../../../../core/values/app_colours.dart';
import '../../../../../core/values/text_styles/base_textstyle.dart';
import '../../../../../core/widgets/my_regular_text.dart';

class TopBookmarkTxtWidget extends StatelessWidget {
  const TopBookmarkTxtWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MyRegularText("Bookmarks", style: BaseTextStyle.headerMl),
        MyRegularText("Find all your saved movies & shows",
            style: BaseTextStyle.textM.copyWith(
              fontSize: 16,
              color: AppColors.secondaryTxt,
            )),
      ],
    );
  }
}
