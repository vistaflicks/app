import 'dart:async';

import '../../../../../framework/provider/network/network.dart';

class DoubleTapDetector extends StatefulWidget {
  final Widget child;
  final Function(TapDownDetails) onDoubleTap;

  const DoubleTapDetector({required this.child, required this.onDoubleTap});

  @override
  _DoubleTapDetectorState createState() => _DoubleTapDetectorState();
}

class _DoubleTapDetectorState extends State<DoubleTapDetector> {
  int _tapCount = 0;
  Timer? _doubleTapTimer;

  void _handleTap(TapDownDetails details) {
    _tapCount++;
    if (_tapCount == 1) {
      _doubleTapTimer = Timer(const Duration(milliseconds: 300), () {
        _tapCount = 0;
      });
    } else if (_tapCount == 2) {
      _doubleTapTimer?.cancel();
      _tapCount = 0;
      widget.onDoubleTap(details);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTap,
      child: widget.child,
    );
  }
}
