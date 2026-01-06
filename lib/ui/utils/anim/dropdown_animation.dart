import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../framework/provider/network/network.dart';

class DropDownAnimation extends ConsumerStatefulWidget {
  final Function(Future<void> Function({bool? isExpand}))? onPopCall;
  final Widget child;
  final Axis? axis;

  const DropDownAnimation(
      {super.key, this.onPopCall, required this.child, this.axis});

  @override
  ConsumerState<DropDownAnimation> createState() => _DropDownAnimationState();
}

class _DropDownAnimationState extends ConsumerState<DropDownAnimation>
    with TickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    expandController.addListener(() {
      print('Animation->${expandController.value}');
      print(
          '--------------------------------------------------------------------------------------------------');
    });
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    animation =
        CurvedAnimation(parent: expandController, curve: Curves.fastOutSlowIn);
    widget.onPopCall?.call(_runExpandCheck);
  }

  Future<void> _runExpandCheck({bool? isExpand}) async {
    if (isExpand == null) {
      if ((expandController.isAnimating == false)) {
        if (expandController.isCompleted) {
          await expandController.reverse();
        } else {
          await expandController.forward();
        }
      }
    } else {
      if (isExpand) {
        await expandController.forward();
      } else {
        await expandController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axisAlignment: 1.0,
      axis: widget.axis ?? Axis.vertical,
      sizeFactor: animation,
      child: widget.child,
    );
  }
}
