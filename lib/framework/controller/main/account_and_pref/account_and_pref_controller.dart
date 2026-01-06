import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';

import '../../../dependency_injection/inject.dart';

final accountAndPrefController =
    ChangeNotifierProvider((ref) => getIt<AccountAndPrefController>());

@injectable
class AccountAndPrefController extends ChangeNotifier {
  bool _notificationToggle = true;
  bool isLoading = false;

  bool get notificationToggle => _notificationToggle;

  void toggleNotification(bool value) {
    _notificationToggle = value;
    notifyListeners();
  }

  void disposeController({bool isNotify = false}) {
    isLoading = false;

    if (isNotify) {
      notifyListeners();
    }
  }
}
