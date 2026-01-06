import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../helper/base_widget.dart';
import '../../theme/app_colors.dart';

/// Common Shimmer Widget
class CommonShimmer extends StatelessWidget with BaseStatelessWidget {
  const CommonShimmer({
    super.key,
    required this.height,
    required this.width,
    this.borderRadius,
    this.decoration,
  });

  final double height;
  final double width;
  final BorderRadiusGeometry? borderRadius;
  final Decoration? decoration;

  @override
  Widget buildPage(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.baseColor,
      highlightColor: AppColors.white,
      child: Container(
        height: height,
        width: width,
        decoration: decoration ??
            BoxDecoration(borderRadius: borderRadius, color: AppColors.black),
      ),
    );
  }
}
