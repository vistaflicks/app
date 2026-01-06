import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vista_flicks/core/widgets/common_image_view.dart';
import 'package:vista_flicks/gen/assets.gen.dart';
import 'package:vista_flicks/ui/utils/theme/app_colors.dart';

class BookMarkBannerShimmer extends StatelessWidget {
  const BookMarkBannerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.black.withOpacity(0.2),
      highlightColor: AppColors.black,
      child: CommonImageView(
        fit: BoxFit.contain,
        imagePath: Assets.images.banner.path,
      ),
    );
  }
}
