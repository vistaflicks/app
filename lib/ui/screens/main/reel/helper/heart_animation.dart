import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../../framework/provider/network/network.dart';
import '../../../../../gen/assets.gen.dart';

class HeartAnimationOverlay extends StatefulWidget {
  final Offset start;
  final Offset end;

  const HeartAnimationOverlay({required this.start, required this.end});

  @override
  State<HeartAnimationOverlay> createState() => _HeartAnimationOverlayState();
}

class _HeartAnimationOverlayState extends State<HeartAnimationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _positionAnimation = Tween<Offset>(
      begin: widget.start,
      end: widget.end,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scaleAnimation = Tween<double>(
      begin: 5,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: _positionAnimation.value.dx - 34.5.w, // Adjust for center
          top: _positionAnimation.value.dy - 35.h,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Lottie.asset(
              Assets.lottie.likeIconUpdated,
              width: 100.w,
              height: 100.h,
            ),
          ),
        );
      },
    );
  }
}
