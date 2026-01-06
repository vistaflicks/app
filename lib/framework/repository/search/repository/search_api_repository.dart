import 'package:injectable/injectable.dart';
import 'package:vista_flicks/framework/provider/network/network.dart';
import 'package:vista_flicks/framework/repository/search/contract/search_repository.dart';
import 'package:vista_flicks/framework/repository/search/model/explore_list_response_model.dart';
import 'package:vista_flicks/framework/repository/search/model/get_home_view_all_model.dart';
import 'package:vista_flicks/ui/screens/main/explore/search_in_explore/Model/get_search_response.dart';
import 'package:vista_flicks/ui/utils/const/app_constants.dart';

@LazySingleton(as: SearchRepository, env: [development, production])
class SearchApiRepository implements SearchRepository {
  SearchApiRepository(this.apiClient);

  DioClient apiClient;

  @override
  Future getExploreListAPI() async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.home);
      ExploreListResponseModel responseModel =
          exploreListResponseModelFromJson(response.toString());
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
  Future getHomeViewAllAPI(
      {required String type, required String page, String? search}) async {
    try {
      Response? response = await apiClient.getRequest(
          ApiEndPoints.homeViewAll(page: page, type: type, search: search));
      GetHomeViewAllModel responseModel =
          getHomeViewAllModelFromJson(response.toString());
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
  Future getSearchAPI({required String search}) async {
    try {
      Response? response =
          await apiClient.getRequest(ApiEndPoints.getSearch(search));
      GetSearchResponse responseModel =
          getSearchResponseFromJson(response.toString());
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
