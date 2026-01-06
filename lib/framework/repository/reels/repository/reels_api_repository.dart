import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:vista_flicks/framework/provider/network/network.dart';
import 'package:vista_flicks/framework/repository/bookmark/model/get_bookmark_watched_response.dart';
import 'package:vista_flicks/framework/repository/reels/contract/reels_repository.dart';
import 'package:vista_flicks/framework/repository/reels/model/get_reels_list_response_model.dart';
import 'package:vista_flicks/framework/repository/reels/model/post_report_model.dart';
import 'package:vista_flicks/ui/utils/const/app_constants.dart';

import '../../../controller/main/reel/models/get_comments.dart';

@LazySingleton(as: ReelsRepository, env: [development, production])
class ReelsApiRepository implements ReelsRepository {
  ReelsApiRepository(this.apiClient);

  DioClient apiClient;

  @override
  Future getReels({required int pageNo}) async {
    try {
      Response? response =
          await apiClient.getRequest(ApiEndPoints.getReels, queryParameters: {
        'page': pageNo.toString(),
        'limit': "10",
      });
      GetReelsListResponseModel responseModel =
          getReelsListResponseModelFromJson(response.toString());
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
  Future getGuestReels() async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.guest);
      GetReelsListResponseModel responseModel =
          getReelsListResponseModelFromJson(response.toString());
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
  Future getReelsById(
      {required String reelId, required String contentId}) async {
    try {
      Response? response = await apiClient.getRequest(
          ApiEndPoints.getReview(contentId),
          queryParameters: {'reelId': reelId});
      GetReelsListResponseModel responseModel =
          getReelsListResponseModelFromJson(response.toString());
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
  Future postInteraction({required Map<String, dynamic> map}) async {
    try {
      String jsonString = json.encode(map);
      Response? response =
          await apiClient.postRequest(ApiEndPoints.interaction, jsonString);
      // CommonResponseModel responseModel =
      //     commonResponseModelFromJson(response.toString());
      if (response?.statusCode == ApiEndPoints.apiStatus_200) {
        return ApiResult.success(data: response);
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
  Future postBookMarkWatchList(
      {bool? isBookmarked,
      bool? isWatched,
      double? rating = 0.0,
      required String contentId,
      String reelId = ""}) async {
    try {
      String jsonString = json.encode({
        if (isBookmarked != null) "isBookmarked": isBookmarked,
        if (isWatched != null) "isWatched": isWatched,
        if (isWatched != null)
          if (rating != 0.0) "rating": rating,
        if (reelId.isNotEmpty) "reelId": reelId
      });

      Response? response = await apiClient.patchRequest(
          ApiEndPoints.postBookMarkWatchList(contentId), jsonString);
      GetBookMarkWatchResponse responseModel =
          getBookMarkWatchResponseFromJson(response.toString());
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
  Future getComments({required String reelId}) async {
    try {
      Response? response = await apiClient.getRequest(
          ApiEndPoints.getComments(reelId),
          queryParameters: {'reelId': reelId});
      GetCommentsResponseModel responseModel =
          getCommentsResponseModelFromJson(response.toString());
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
  Future postReport({required String report}) async {
    try {
      String jsonString = json.encode({
        "query": report,
      });

      Response? response =
          await apiClient.postRequest(ApiEndPoints.postReport, jsonString);
      PostReportResponseModel responseModel =
          postReportResponseModelFromJson(response.toString());
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
