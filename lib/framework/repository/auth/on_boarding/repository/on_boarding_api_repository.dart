import 'dart:convert';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:vista_flicks/framework/provider/network/network.dart';
import 'package:vista_flicks/framework/repository/auth/on_boarding/contract/on_boarding_repository.dart';
import 'package:vista_flicks/framework/repository/auth/on_boarding/model/check_existing_user_response_model.dart';
import 'package:vista_flicks/framework/repository/auth/on_boarding/model/generate_otp_response_model.dart';
import 'package:vista_flicks/framework/repository/auth/on_boarding/model/verify_otp_response_model.dart';
import 'package:vista_flicks/framework/repository/common_response/common_response_model.dart';
import 'package:vista_flicks/framework/utils/local_storage/session.dart';
import 'package:vista_flicks/ui/utils/const/app_constants.dart';

import '../model/register_user_response_model.dart';

@LazySingleton(as: OnBoardingRepository, env: [development, production])
class OnBoardingApiRepository implements OnBoardingRepository {
  OnBoardingApiRepository(this.apiClient);

  DioClient apiClient;

  @override
  Future checkUserApi({required Map<String, dynamic> map}) async {
    try {
      String jsonString = json.encode(map);
      print("Encoded json $jsonString");
      Response? response = await apiClient.getRequest(ApiEndPoints.checkUser,
          requestBody: jsonString);
      CheckExistingUserResponseModel responseModel =
          checkExistingUserResponseModelFromJson(response.toString());
      if (response?.statusCode == ApiEndPoints.apiStatus_200) {
        return ApiResult.success(data: responseModel);
      } else {
        return ApiResult.failure(
            error:
                NetworkExceptions.defaultError(response?.statusMessage ?? ''));
      }
    } catch (err) {
      showLog('checkUser API Error -> err $err');
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future generateOtpApi({required Map<String, dynamic> map}) async {
    try {
      String jsonString = json.encode(map);
      Response? response =
          await apiClient.postRequest(ApiEndPoints.sendOtp, jsonString);
      GenerateOtpResponseModel responseModel =
          generateOtpResponseModelFromJson(response.toString());
      if (response?.statusCode == ApiEndPoints.apiStatus_200) {
        return ApiResult.success(data: responseModel);
      } else {
        return ApiResult.failure(
            error:
                NetworkExceptions.defaultError(response?.statusMessage ?? ''));
      }
    } catch (err) {
      showLog('generateOtp API Error -> err $err');
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future uploadToS3({
    required Map<String, dynamic> map,
    required File file,
  }) async {
    try {
      // Step 1: Get pre-signed URL
      String jsonString = json.encode(map);
      Response? response =
          await apiClient.postRequest(ApiEndPoints.uploadAvatar, jsonString);

      if (response?.statusCode == ApiEndPoints.apiStatus_200) {
        String uploadUrl = response?.data["url"];

        // Step 2: Read file as bytes
        List<int> fileBytes = await file.readAsBytes();

        // Step 3: Upload file to S3 using PUT request
        await apiClient.putRequest(
          uploadUrl,
          fileBytes, // Send raw file bytes
          headers: {
            "Content-Type": "image/jpeg", // Ensure correct content type
            "Content-Length": fileBytes.length.toString(), // Set content length
          },
        );

        return ApiResult.success(data: uploadUrl.split('?')[0]);
      } else {
        return ApiResult.failure(
            error:
                NetworkExceptions.defaultError(response?.statusMessage ?? ''));
      }
    } catch (err) {
      showLog('uploadToS3 API Error -> err $err');
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future verifyOtpApi({required Map<String, dynamic> map}) async {
    try {
      String jsonString = json.encode(map);
      Response? response =
          await apiClient.postRequest(ApiEndPoints.verifyOrp, jsonString);
      VerifyOtpResponseModel responseModel =
          verifyOtpResponseModelFromJson(response.toString());
      if (response?.statusCode == ApiEndPoints.apiStatus_200) {
        return ApiResult.success(data: responseModel);
      } else {
        return ApiResult.failure(
            error:
                NetworkExceptions.defaultError(response?.statusMessage ?? ''));
      }
    } catch (err) {
      showLog('verifyOtp API Error -> err $err');
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future socialLoginApi({required Map<String, dynamic> map}) async {
    try {
      String jsonString = json.encode(map);
      Response? response =
          await apiClient.postRequest(ApiEndPoints.socialLogin, jsonString);
      VerifyOtpResponseModel responseModel =
          verifyOtpResponseModelFromJson(response.toString());
      if (response?.statusCode == ApiEndPoints.apiStatus_200) {
        return ApiResult.success(data: responseModel);
      } else {
        return ApiResult.failure(
            error:
                NetworkExceptions.defaultError(response?.statusMessage ?? ''));
      }
    } catch (err) {
      showLog('verifyOtp API Error -> err $err');
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future resendOtpApi({required Map<String, dynamic> map}) async {
    try {
      String jsonString = json.encode(map);
      Response? response =
          await apiClient.postRequest(ApiEndPoints.resendOrp, jsonString);
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
      showLog('resendOtp API Error -> err $err');
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future locationUpdateApi({required Map<String, dynamic> map}) async {
    try {
      String jsonString = json.encode(map);
      Response? response = await apiClient.patchRequest(
          ApiEndPoints.locationUpdateApi, jsonString);
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
      showLog('locationUpdateApi API Error -> err $err');
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future logoutApi() async {
    try {
      // String jsonString = json.encode();
      Response? response =
          await apiClient.postRequest(ApiEndPoints.logout, "{}");
      VerifyOtpResponseModel responseModel =
          verifyOtpResponseModelFromJson(response.toString());
      if (response?.statusCode == ApiEndPoints.apiStatus_200) {
        return ApiResult.success(data: responseModel);
      } else {
        return ApiResult.failure(
            error:
                NetworkExceptions.defaultError(response?.statusMessage ?? ''));
      }
    } catch (err) {
      showLog('resendOtp API Error -> err $err');
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future registerApi(
      {required Map<String, dynamic> map, required String id}) async {
    try {
      String jsonString = json.encode(map);
      Response? response =
          await apiClient.patchRequest(ApiEndPoints.profile(id), jsonString);
      RegisterUserResponseModel responseModel =
          registerUserResponseModelFromJson(response.toString());
      if (response?.statusCode == ApiEndPoints.apiStatus_200) {
        return ApiResult.success(data: responseModel);
      } else {
        return ApiResult.failure(
            error:
                NetworkExceptions.defaultError(response?.statusMessage ?? ''));
      }
    } catch (err) {
      showLog('registerApi API Error -> err $err');
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  ///Get Profile Api
  @override
  Future getProfileApi(id) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.profile(id));
      RegisterUserResponseModel responseModel =
          registerUserResponseModelFromJson(response.toString());
      if (response?.statusCode == ApiEndPoints.apiStatus_200) {
        return ApiResult.success(data: responseModel);
      } else {
        return ApiResult.failure(
            error: NetworkExceptions.defaultError(responseModel.message ?? ''));
      }
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  ///Delete user Api
  @override
  Future deleteAccount() async {
    try {
      Response? response = await apiClient.deleteRequest(
          ApiEndPoints.profile(Session.userId), "");
      CommonResponseModel responseModel =
          commonResponseModelFromJson(response.toString());
      if (response?.statusCode == ApiEndPoints.apiStatus_200) {
        return ApiResult.success(data: responseModel);
      } else {
        return ApiResult.failure(
            error: NetworkExceptions.defaultError(responseModel.message ?? ''));
      }
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
}
