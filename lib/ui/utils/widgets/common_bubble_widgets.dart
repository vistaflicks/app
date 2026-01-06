import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../framework/provider/network/network.dart';
import '../helper/base_widget.dart';
import '../theme/app_colors.dart';

class CommonBubbleWidget extends StatelessWidget with BaseStatelessWidget {
  final bool isBubbleFromLeft;
  final double? height;
  final double? width;
  final double? borderRadius;
  final double? positionFromLeft;
  final double? positionFromRight;
  final double? positionFromTop;
  final Widget child;
  final Color? bubbleColor;

  const CommonBubbleWidget(
      {super.key,
      required this.isBubbleFromLeft,
      this.height,
      required this.child,
      this.positionFromLeft,
      this.positionFromRight,
      this.width,
      this.borderRadius,
      this.positionFromTop,
      this.bubbleColor});

  @override
  Widget buildPage(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: height != null ? ((height ?? 0) + 0.02.h) : null,
      width: width,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: positionFromTop ?? 0.02.h,
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(borderRadius ?? 15.r),
              ),
              child: child,
            ),
          ),
          isBubbleFromLeft
              ? Positioned(
                  left: positionFromLeft ?? 50.w,
                  child: const Icon(Icons.arrow_circle_left_rounded),
                )
              : Positioned(
                  right: positionFromRight ?? 50.w,
                  child: const Icon(Icons.arrow_circle_right_rounded),
                )
        ],
      ),
    );
  }
}
