import 'package:injectable/injectable.dart';
import 'package:vista_flicks/framework/controller/main/preview_and_detail/detail/detail_repository.dart';
import 'package:vista_flicks/framework/controller/main/preview_and_detail/model/get_about_content_model.dart';
import 'package:vista_flicks/framework/controller/main/preview_and_detail/model/get_review_model.dart';
import 'package:vista_flicks/framework/controller/main/preview_and_detail/model/get_similar_model.dart';
import 'package:vista_flicks/framework/provider/network/network.dart';
import 'package:vista_flicks/ui/utils/const/app_constants.dart';

@LazySingleton(as: DetailRepository, env: [development, production])
class DetailApiRepository implements DetailRepository {
  DetailApiRepository(this.apiClient);

  DioClient apiClient;

  @override
  Future getSimilarAPI(contentId) async {
    try {
      // String jsonString = json.encode(map);
      Response? response =
          await apiClient.getRequest(ApiEndPoints.getSimilar(contentId));
      GetSimilarModel responseModel =
          getSimilarModelFromJson(response.toString());
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
  Future getAboutContentAPI(contentId) async {
    try {
      // String jsonString = json.encode(map);
      Response? response =
          await apiClient.getRequest(ApiEndPoints.getAboutContent(contentId));
      GetAboutContentModel responseModel =
          getAboutContentModelFromJson(response.toString());
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
  Future getReviewAPI(contentId) async {
    try {
      // String jsonString = json.encode(map);
      Response? response =
          await apiClient.getRequest(ApiEndPoints.getReview(contentId));
      GetReviewModel responseModel =
          getReviewModelFromJson(response.toString());
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
