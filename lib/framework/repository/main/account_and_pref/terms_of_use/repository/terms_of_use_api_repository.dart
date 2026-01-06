import 'package:injectable/injectable.dart';
import 'package:vista_flicks/framework/provider/network/network.dart';
import 'package:vista_flicks/framework/repository/main/account_and_pref/terms_of_use/model/terms_of_use_response_model.dart';

import '../../../../../../ui/utils/const/app_constants.dart';
import '../contract/terms_of_use_repository.dart';

@LazySingleton(as: TermsOfUseRepository, env: [development, production])
class TermsOfUseApiRepository implements TermsOfUseRepository {
  DioClient apiClient;

  TermsOfUseApiRepository(this.apiClient);

  @override
  Future termsOfUseListApi() async {
    try {
      Response response = await apiClient.getRequest(ApiEndPoints.termsOfUse);
      TermsOfUseResponseModel responseModel =
          termsOfUseResponseModelFromJson(response.toString());
      if (response.statusCode == ApiEndPoints.apiStatus_200) {
        return ApiResult.success(data: responseModel);
      } else {
        return ApiResult.failure(
            error:
                NetworkExceptions.defaultError(response.statusMessage ?? ""));
      }
    } catch (err) {
      showLog("termsOfUseListApi API Error -> err $err");
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
}
