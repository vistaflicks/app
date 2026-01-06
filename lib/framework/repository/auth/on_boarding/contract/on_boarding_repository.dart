import 'dart:io';

abstract class OnBoardingRepository {
  Future checkUserApi({required Map<String, dynamic> map});

  Future generateOtpApi({required Map<String, dynamic> map});

  Future uploadToS3({required Map<String, dynamic> map, required File file});

  Future verifyOtpApi({required Map<String, dynamic> map});

  Future socialLoginApi({required Map<String, dynamic> map});

  Future resendOtpApi({required Map<String, dynamic> map});
  Future locationUpdateApi({required Map<String, dynamic> map});

  Future registerApi({required Map<String, dynamic> map, required String id});

  Future getProfileApi(String userId);

  Future logoutApi();

  Future deleteAccount();
}
