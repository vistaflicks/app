import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';

import '../../../../../ui/utils/theme/theme.dart';
import '../../../../dependency_injection/inject.dart';

final inboxHomeController = ChangeNotifierProvider((ref) => getIt<InboxHomeController>());

@injectable
class InboxHomeController extends ChangeNotifier {
  bool isLoading = false;
  final TextEditingController createGroupController = TextEditingController();
  bool isInputValid = false;
  bool isCheckboxChecked = false;

  updateIsLoading(bool value){
    isLoading = value;
    notifyListeners();
  }

  inboxHomeNotifier() {
    createGroupController.addListener(_validateInput);
  }

  void _validateInput() {
    isInputValid = createGroupController.text.trim().isNotEmpty;
    notifyListeners();
  }

  void toggleCheckbox() {
    isCheckboxChecked = !isCheckboxChecked;
    notifyListeners();
  }

  void updateWidget() {
    notifyListeners();
  }

  void disposeController({bool isNotify = false}) {
    isLoading = false;
    // createGroupController.dispose();
    if (isNotify) {
      notifyListeners();
    }
  }
}
