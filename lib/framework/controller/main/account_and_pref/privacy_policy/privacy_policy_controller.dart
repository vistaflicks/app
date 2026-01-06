import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:vista_flicks/framework/repository/main/account_and_pref/privacy_policy/contract/privacy_policy_repository.dart';
import 'package:vista_flicks/framework/repository/main/account_and_pref/privacy_policy/model/privacy_policy_response_model.dart';

import '../../../../../ui/utils/theme/theme.dart';
import '../../../../../ui/utils/widgets/common_dialogs.dart';
import '../../../../dependency_injection/inject.dart';
import '../../../../provider/network/network_exceptions.dart';
import '../../../../utils/ui_state.dart';

final privacyPolicyController =
    ChangeNotifierProvider((ref) => getIt<PrivacyPolicyController>());

@injectable
class PrivacyPolicyController extends ChangeNotifier {
  PrivacyPolicyRepository privacyPolicyRepository;

  PrivacyPolicyController(this.privacyPolicyRepository);

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  bool isLoading = false;

  /// Terms Of Use Api call
  var privacyPolicyApiState = UIState<PrivacyPolicyResponseModel>();

  /// Terms Of Use List
  List<Result> PrivacyPolicyList = [];

  /// Terms Of Use List  Api

  Future termsOfUseListApi(BuildContext context) async {
    privacyPolicyApiState.isLoading = true;
    privacyPolicyApiState.success = null;
    notifyListeners();

    if (context.mounted) {
      final res = await privacyPolicyRepository.privacyPolicyApi();
      res.when(success: (data) async {
        privacyPolicyApiState.success = data;
        privacyPolicyApiState.isLoading = false;
        if (privacyPolicyApiState.success?.data != null &&
            (privacyPolicyApiState.success?.data?.results?.isNotEmpty ??
                false)) {
          PrivacyPolicyList.clear();
          PrivacyPolicyList.addAll(
              privacyPolicyApiState.success!.data?.results ?? []);
        }
        notifyListeners();
      }, failure: (NetworkExceptions error) {
        String errorMsg = NetworkExceptions.getErrorMessage(error);
        showMessageDialog(context, errorMsg, () {});
      });
    }
  }

  void disposeController({bool isNotify = false}) {
    isLoading = false;

    if (isNotify) {
      notifyListeners();
    }
  }
}
