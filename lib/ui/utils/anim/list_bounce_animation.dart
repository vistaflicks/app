import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/common_mouse_region.dart';

class ListBounceAnimation extends ConsumerStatefulWidget {
  final Widget child;
  final int? delay;
  final Function(AnimationController animationController)? onPopCall;
  final Function() onTap;
  final double? transformSize;
  final bool animate;

  const ListBounceAnimation(
      {super.key,
      required this.child,
      this.onPopCall,
      this.delay,
      required this.onTap,
      this.transformSize,
      this.animate = true});

  @override
  ConsumerState<ListBounceAnimation> createState() => _DialogTransitionState();
}

class _DialogTransitionState extends ConsumerState<ListBounceAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 70), vsync: this);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.reset();
      _controller.addListener(() {
        setState(() {});
      });
      widget.onPopCall?.call(_controller);
    });
  }

  @override
  void dispose() {
    _controller.stop(canceled: true);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomMouseRegion(
      cursor: SystemMouseCursors.click,
      child: Transform.scale(
        scale:
            1 + ((_controller.value / 4) * (1 - (widget.transformSize ?? 0))),
        child: GestureDetector(
          onLongPressDown: (longPresDown) {
            if (widget.animate) {
              _controller.forward(from: _controller.value);
            }
          },
          onLongPressUp: () {
            if (widget.animate) {
              _controller.reverse(from: _controller.value);
            }
          },
          onLongPressCancel: () {
            if (widget.animate) {
              _controller.reverse(from: _controller.value);
            }
          },
          onTapCancel: () {
            if (widget.animate) {
              _controller.reverse(from: _controller.value);
            }
          },
          onTap: () {
            widget.onTap.call();
            HapticFeedback.heavyImpact();
            if (widget.animate) {
              Future.delayed(const Duration(milliseconds: 20), () {
                _controller.forward(from: _controller.value).then(
                    (value) => _controller.reverse(from: _controller.value));
              });
            }
          },
          child: widget.child,
        ),
      ),
    );
  }
}
