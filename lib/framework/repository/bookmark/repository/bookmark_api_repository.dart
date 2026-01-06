import 'package:injectable/injectable.dart';
import 'package:vista_flicks/framework/provider/network/network.dart';
import 'package:vista_flicks/framework/repository/bookmark/contract/bookmark_repository.dart';
import 'package:vista_flicks/framework/repository/bookmark/model/get_all_bookmark_response_model.dart';
import 'package:vista_flicks/framework/repository/bookmark/model/get_bookmark_list_response_model.dart';
import 'package:vista_flicks/ui/utils/const/app_constants.dart';

@LazySingleton(as: BookmarkRepository, env: [development, production])
class BookmarkApiRepository implements BookmarkRepository {
  BookmarkApiRepository(this.apiClient);

  DioClient apiClient;

  @override
  Future getBannerListAPI() async {
    try {
      Response? response =
          await apiClient.getRequest(ApiEndPoints.getBookmarkBanner);
      BookmarkBannerListResponseModel responseModel =
          bookmarkBannerListResponseModelFromJson(response.toString());
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
  Future getAllBookmarkListAPI(
      {required int pageNo,
      required String search,
      required String limit}) async {
    try {
      Response? response = await apiClient
          .getRequest(ApiEndPoints.getAllBookmarks(pageNo, search, limit));
      GetAllBookmarkResponseModel responseModel =
          getAllBookmarkResponseModelFromJson(response.toString());
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
