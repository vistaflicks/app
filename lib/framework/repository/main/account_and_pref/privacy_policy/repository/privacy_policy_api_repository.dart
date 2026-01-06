import 'package:injectable/injectable.dart';
import 'package:vista_flicks/framework/provider/network/network.dart';
import 'package:vista_flicks/framework/repository/main/account_and_pref/privacy_policy/model/privacy_policy_response_model.dart';
import 'package:vista_flicks/ui/utils/const/app_constants.dart';

import '../contract/privacy_policy_repository.dart';

@LazySingleton(as: PrivacyPolicyRepository, env: [development, production])
class PrivacyPolicyApiRepository implements PrivacyPolicyRepository {
  DioClient apiClient;

  PrivacyPolicyApiRepository(this.apiClient);

  @override
  Future privacyPolicyApi() async {
    try {
      Response response =
          await apiClient.getRequest(ApiEndPoints.privacyPolicy);
      PrivacyPolicyResponseModel responseModel =
          privacyPolicyResponseModelFromJson(response.toString());

      if (response.statusCode == ApiEndPoints.apiStatus_200) {
        return ApiResult.success(data: responseModel);
      } else {
        return ApiResult.failure(
            error:
                NetworkExceptions.defaultError(response.statusMessage ?? ""));
      }
    } catch (err) {
      showLog("privacyPolicyApi API Error -> err $err");
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
}
