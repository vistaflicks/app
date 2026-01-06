import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:vista_flicks/framework/repository/main/account_and_pref/terms_of_use/contract/terms_of_use_repository.dart';
import 'package:vista_flicks/framework/repository/main/account_and_pref/terms_of_use/model/terms_of_use_response_model.dart';
import 'package:vista_flicks/framework/utils/ui_state.dart';

import '../../../../../ui/utils/widgets/common_dialogs.dart';
import '../../../../dependency_injection/inject.dart';
import '../../../../provider/network/network_exceptions.dart';

final termsOfUseController =
    ChangeNotifierProvider((ref) => getIt<TermsOfUseController>());

@injectable
class TermsOfUseController extends ChangeNotifier {
  TermsOfUseRepository termsOfUseRepository;

  TermsOfUseController(this.termsOfUseRepository);

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  bool isLoading = false;

  /// Terms Of Use Api call
  var termsOfUseApiState = UIState<TermsOfUseResponseModel>();

  /// Terms Of Use List
  List<Result> termsOfUseList = [];

  /// Terms Of Use List  Api

  Future termsOfUseListApi(BuildContext context) async {
    termsOfUseApiState.isLoading = true;
    termsOfUseApiState.success = null;
    notifyListeners();

    if (context.mounted) {
      final res = await termsOfUseRepository.termsOfUseListApi();
      res.when(success: (data) async {
        termsOfUseApiState.success = data;
        termsOfUseApiState.isLoading = false;
        if (termsOfUseApiState.success?.data != null &&
            (termsOfUseApiState.success?.data?.results?.isNotEmpty ?? false)) {
          termsOfUseList.clear();
          termsOfUseList
              .addAll(termsOfUseApiState.success!.data?.results ?? []);
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
