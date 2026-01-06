import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';

import '../../../../../../gen/assets.gen.dart';

class CommonMenuTileWidget extends StatelessWidget {
  final String txt;
  final bool isTop;
  final bool isBottom;
  final bool isLast;
  final bool isDelete;
  final bool isIMDB;
  final VoidCallback onTap;

  const CommonMenuTileWidget({
    required this.txt,
    this.isTop = false,
    this.isBottom = false,
    this.isLast = false,
    this.isDelete = false,
    this.isIMDB = false,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: getHeight(18), horizontal: getWidth(16)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(isTop ? 10 : 0),
                topLeft: Radius.circular(isTop ? 10 : 0),
                bottomRight: Radius.circular(isBottom ? 10 : 0),
                bottomLeft: Radius.circular(isBottom ? 10 : 0)),
            border: Border.all(color: AppColors.border)),
        child: Row(
          mainAxisAlignment: isLast
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceBetween,
          children: [
            isIMDB
                ? Row(
                    children: [
                      SvgPicture.asset(width: getWidth(40), Assets.images.imdb),
                      getHorizonatlWidth(getWidth(5)),
                      MyRegularText(
                        txt,
                        style: BaseTextStyle.lableM.copyWith(
                            color: isDelete && isLast
                                ? AppColors.red
                                : AppColors.primeryTxt),
                      ),
                    ],
                  )
                : MyRegularText(
                    txt,
                    style: BaseTextStyle.lableM.copyWith(
                        color: isDelete && isLast
                            ? AppColors.red
                            : AppColors.primeryTxt),
                  ),
            if (!isLast)
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
                color: AppColors.primeryTxt,
              )
          ],
        ),
      ),
    );
  }
}
