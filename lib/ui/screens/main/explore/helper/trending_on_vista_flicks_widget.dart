import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/core/utils/config.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/core/widgets/common_image_view.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';
import 'package:vista_flicks/framework/repository/search/model/explore_list_response_model.dart';
import 'package:vista_flicks/ui/routing/navigation_stack_item.dart';
import 'package:vista_flicks/ui/routing/stack.dart';

import '../../../../../framework/controller/main/explore/explore_controller.dart';

class TrendingOnVistaFlicksWidget extends ConsumerWidget {
  TitleDatum categoryList;

  TrendingOnVistaFlicksWidget({
    required this.categoryList,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exploreScreenWatch = ref.watch(exploreController);
    return Column(
      children: [
        getVerticalHeight(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyRegularText(
              categoryList.title ?? "",
              // "Trending on Vista Flicks",
              style: BaseTextStyle.headerM,
            ),
            GestureDetector(
              onTap: () {
                ref
                    .read(navigationStackController)
                    .push(NavigationStackItem.commonSeeAll(
                      title: categoryList.title,
                    ));
              },
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
            categoryList.data?.length ?? 0,
            (index) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  ref.read(navigationStackController).push(
                      NavigationStackItem.detail(
                          contentId:
                              categoryList.data?[index].contentId ?? ""));
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CommonImageView(
                        fit: BoxFit.fill,
                        radius: getRadious(6),
                        height: 140.h,
                        width: 100.w,
                        url: categoryList.data?[index].imageUrl ??
                            Config.kNoImage,
                        // imagePath: categoryList.data?[index].imageUrl,
                      ),
                      Positioned(
                        left: -13,
                        bottom: -15,
                        // child: CommonImageView(
                        //   imagePath: numb,
                        // ),
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: [
                                AppColors.primeryTxt,
                                AppColors.primeryTxt,
                                AppColors.black
                              ],
                              // Adjust gradient colors
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ).createShader(bounds);
                          },
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                                letterSpacing: 0,
                                fontWeight: FontWeight.bold,
                                fontSize: 45,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                  ),
                                  Shadow(
                                    blurRadius: 10,
                                    color: AppColors.lightGray1,
                                  ),
                                ],
                                color: AppColors.primeryTxt),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
        ),
        getVerticalHeight(10),
      ],
    );
  }
}
