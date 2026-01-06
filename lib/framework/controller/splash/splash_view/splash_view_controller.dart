import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';

import '../../../../ui/utils/theme/theme.dart';
import '../../../dependency_injection/inject.dart';

final splashViewController =
    ChangeNotifierProvider((ref) => getIt<SplashViewController>());

@injectable
class SplashViewController extends ChangeNotifier {
  bool isLoading = false;

  void disposeController({bool isNotify = false}) {
    isLoading = false;

    if (isNotify) {
      notifyListeners();
    }
  }
}
