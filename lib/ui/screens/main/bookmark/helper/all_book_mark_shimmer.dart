import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/widgets/common_image_view.dart';
import 'package:vista_flicks/gen/assets.gen.dart';

class AllBookMarkShimmer extends StatelessWidget {
  final Color? color;
  const AllBookMarkShimmer({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: (color ?? AppColors.black).withOpacity(0.2),
      highlightColor: color ?? AppColors.black,
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, mainAxisExtent: 170.h),
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        // itemCount: movies.length,
        itemCount: 30,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.all(3.r),
          child: CommonImageView(
            radius: 6.r,
            height: getHeight(140.h),
            width: getWidth(100.w),
            fit: BoxFit.contain,
            imagePath: Assets.images.p13.path,

            // imagePath: Assets.images.p9.path,
          ),
        ),
      ),
    );
  }
}
