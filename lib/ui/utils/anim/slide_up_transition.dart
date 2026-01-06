import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vista_flicks/ui/utils/anim/animation_extension.dart';

class SlideUpTransition extends StatefulWidget {
  final Widget child;
  final int? delay;
  final int? duration;

  const SlideUpTransition(
      {super.key, required this.child, this.delay, this.duration});

  @override
  State<SlideUpTransition> createState() => _SlideUpTransitionState();
}

class _SlideUpTransitionState extends State<SlideUpTransition>
    with TickerProviderStateMixin {
  AnimationController? _animController;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.duration ?? 300));
    if (_animController != null) {
      final curve = CurvedAnimation(
          curve: Curves.decelerate,
          parent: _animController ??
              AnimationController(
                  vsync: this,
                  duration: Duration(milliseconds: widget.duration ?? 300)));
      _animOffset =
          Tween<Offset>(begin: const Offset(0.0, 0.35), end: Offset.zero)
              .animate(curve);

      if (mounted) {
        Future.delayed(Duration(milliseconds: widget.delay ?? 100), () {
          if (!(_animController?.isDisposed ?? false)) {
            _animController?.forward().orCancel;
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _animController?.stop(canceled: true);
    _animController?.dispose();
    _animController == null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _animController != null
        ? FadeTransition(
            opacity: _animController!,
            child: SlideTransition(
              position: _animOffset,
              child: widget.child,
            ),
          )
        : const Offstage();
  }
}
