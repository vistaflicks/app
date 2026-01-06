import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DialogTransition extends ConsumerStatefulWidget {
  final Widget child;
  final Function(AnimationController animationController)? onPopCall;

  const DialogTransition({super.key, required this.child, this.onPopCall});

  @override
  ConsumerState<DialogTransition> createState() => _DialogTransitionState();
}

class _DialogTransitionState extends ConsumerState<DialogTransition>
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
      _controller.forward();
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
    return SizeTransition(
      sizeFactor: _animation,
      axis: Axis.vertical,
      child: SizeTransition(
        sizeFactor: _animation,
        axis: Axis.horizontal,
        child: widget.child,
      ),
    );
  }
}
