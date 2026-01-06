import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vista_flicks/ui/utils/anim/animation_extension.dart';

import 'custom_animation_controller.dart';

class FadeBoxTransition extends ConsumerStatefulWidget {
  final Widget child;
  final int? delay;
  final Function(AnimationController animationController)? onPopCall;

  const FadeBoxTransition(
      {super.key, required this.child, this.onPopCall, this.delay});

  @override
  ConsumerState<FadeBoxTransition> createState() => _DialogTransitionState();
}

class _DialogTransitionState extends ConsumerState<FadeBoxTransition>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _controller, curve: Curves.fastLinearToSlowEaseIn));
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.reset();
      _controller.addListener(() {
        ref.watch(customAnimationController).notifyListeners();
      });
      Future.delayed(Duration(milliseconds: widget.delay ?? 0), () {
        if (_controller.isDisposed == false) {
          _controller.forward();
        }
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
    return Transform.scale(
      scale: _animation.value,
      child: widget.child,
    );
  }
}
