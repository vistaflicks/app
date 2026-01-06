import 'package:flutter/material.dart';
import 'package:vista_flicks/core/widgets/common_image_view.dart';
import 'package:vista_flicks/framework/utils/extension/context_extension.dart';

import '../../gen/assets.gen.dart';
import '../values/app_colours.dart';
import '../values/size_constant.dart';

class CommonBgContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final BoxDecoration? boxDecoration;
  final double? horizontalPadding;

  const CommonBgContainer({
    super.key,
    this.padding,
    this.boxDecoration,
    this.horizontalPadding,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: context.width,
          height: context.height,
          child: CommonImageView(
            imagePath: Assets.background.bgImage.path,
          ),
        ),

        Container(
          width: context.width,
          height: context.height,
          color: AppColors.bgColor.withOpacity(.6),
        ),
        // Positioned(
        //   child: Stack(
        //     children: [
        //       Positioned(
        //         top: -context.height * .05,
        //         child: Opacity(
        //           opacity: 0.6,
        //           child: SvgPicture.asset(
        //             Assets.images.bgOvel,
        //             fit: BoxFit.cover,
        //           ),
        //         ),
        //       ),
        //       Positioned.fill(
        //         child: BackdropFilter(
        //           filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
        //           // Adjust blur intensity
        //           child: Container(
        //             color: AppColors.transparent,
        //             // color: AppColors.black.withOpacity(
        //             //     0.2), // Required for BackdropFilter to work
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        Container(
            decoration: boxDecoration,
            padding: padding ??
                EdgeInsets.symmetric(
                  horizontal: getWidth(horizontalPadding ?? 16),
                ),
            child: child),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:vista_flicks/core/values/app_colours.dart';
// import 'package:vista_flicks/core/values/size_constant.dart';
//
// import '../../gen/assets.gen.dart';
//
// class CommonBgContainer extends StatelessWidget {
//   final Widget child;
//
//   const CommonBgContainer({super.key, required this.child});
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           width: Get.width,
//           height: Get.height,
//           padding: EdgeInsets.symmetric(horizontal: getWidth(16)),
//           decoration: BoxDecoration(
//             color: AppColors.bgColor,
//             // image: DecorationImage(
//             //   fit: BoxFit.cover,
//             //   image: AssetImage(
//             //     Assets.images.bgOvel,
//             //   ),
//             // ),
//           ),
//           // child: ,
//         ),
//         Opacity(
//             opacity: 0.5,
//             child: SvgPicture.asset(
//               Assets.images.bgOvel,
//             )),
//         child,
//       ],
//     );
//   }
// }
