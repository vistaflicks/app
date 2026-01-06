import 'package:injectable/injectable.dart';
import 'package:vista_flicks/framework/provider/network/network.dart';
import 'package:vista_flicks/framework/repository/common_response/common_response_model.dart';
import 'package:vista_flicks/framework/repository/preferences/contract/preference_repository.dart';
import 'package:vista_flicks/framework/repository/preferences/model/get_preferences_response_model.dart';
import 'package:vista_flicks/ui/utils/const/app_constants.dart';

@LazySingleton(as: PreferenceRepository, env: [development, production])
class PreferenceApiRepository implements PreferenceRepository {
  PreferenceApiRepository(this.apiClient);

  DioClient apiClient;

  @override
  Future getPreferencesAPI({required String type}) async {
    try {
      Response? response =
          await apiClient.getRequest(ApiEndPoints.getPreference(type));
      GetPreferencesResponseModel responseModel =
          getPreferencesResponseModelFromJson(response.toString());
      if (response?.statusCode == ApiEndPoints.apiStatus_200) {
        return ApiResult.success(data: responseModel);
      } else {
        return ApiResult.failure(
            error:
                NetworkExceptions.defaultError(response?.statusMessage ?? ''));
      }
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future updatePreferencesAPI({required String request}) async {
    try {
      Response? response =
          await apiClient.patchRequest(ApiEndPoints.updatePreference, request);
      CommonResponseModel responseModel =
          commonResponseModelFromJson(response.toString());
      if (response?.statusCode == ApiEndPoints.apiStatus_200) {
        return ApiResult.success(data: responseModel);
      } else {
        return ApiResult.failure(
            error:
                NetworkExceptions.defaultError(response?.statusMessage ?? ''));
      }
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
}
