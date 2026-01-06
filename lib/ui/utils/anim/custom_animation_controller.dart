import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';

import '../../../framework/dependency_injection/inject.dart';

final customAnimationController = ChangeNotifierProvider(
  (ref) => getIt<CustomAnimationController>(),
);

@injectable
class CustomAnimationController extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
