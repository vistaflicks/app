import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';

import '../../../../../ui/utils/theme/theme.dart';
import '../../../../dependency_injection/inject.dart';

final updateProfileController =
    ChangeNotifierProvider((ref) => getIt<UpdateProfileController>());

@injectable
class UpdateProfileController extends ChangeNotifier {
  String countryCode = '91';
  String flagEmoji = '🇮🇳';
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final ageController = TextEditingController();
  bool isLoading = false;

  int selectedGenderIndex = 0;
  String selectedAge = '';
  String selectedGender = '';

  void updateCountryCode(String code) {
    countryCode = code;
    notifyListeners();
  }

  void updateSelectedGender(int index, String gender) {
    selectedGenderIndex = index;
    selectedGender = gender;
    notifyListeners();
  }

  void updateAge(String age) {
    selectedAge = age;
    notifyListeners();
  }

  void disposeController({bool isNotify = false}) {
    isLoading = false;

    if (isNotify) {
      notifyListeners();
    }
  }
}
