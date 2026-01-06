import 'package:vista_flicks/framework/utils/local_storage/session.dart';

class ApiEndPoints {
  /*
  * ----- Api status
  * */
  static const int apiStatus_200 = 200; //success
  static const int apiStatus_201 = 201; //success
  static const int apiStatus_202 = 202; //success for static page
  static const int apiStatus_203 = 203; //success
  static const int apiStatus_205 = 205; // for remaining step 2
  static const int apiStatus_401 = 401; //Invalid data
  static const int apiStatus_404 = 404; //Invalid data
  static const int apiStatus_500 = 500; //Invalid data

  static const currentUrl = 'baseUrl';

  /// Auth
  static String checkUser = '/auth/check';
  static String sendOtp = '/auth/otp/send';
  static String verifyOrp = '/auth/otp/verify';
  static String resendOrp = '/auth/otp/resend';
  static String locationUpdateApi = '/profile/location';
  static String logout = '/auth/user/logout';
  static String guest = '/guest';
  static String socialLogin = '/auth/social-login';
  static String uploadAvatar =
      'https://vistabackend.codnestx.com/api/v1/upload/users';
  // 'http://192.168.1.25:9001/api/v1/upload/users';

  // static String uploadAvatar = '/upload/users';

  /// Terms of usr (FAQ's)
  static String termsOfUse = '/faq?page=-1';

  /// Privacy Policy
  static String privacyPolicy = '/privacyPolicy';

  // static String profile = '/profile/$id';

  static String profile(id) => '/profile/$id';

  // static String login = '/login';
  // static String loginSocial = '/google-login';
  // static String logOut = '/logout';
  // static String forgotPassword = '/forgot-password';
  // static String checkOTP = '/check-otp';
  // static String signUp = '/signup';
  // static String resetPassword = '/reset-password';

  /// Profile
  static String getProfile = '/profile-detail';
  static String updateProfile = '/update-profile';

  static String getPreference(String type) => '/preferences/$type';
  static String updatePreference = '/preferences';

  static String home = '/home';

  static String homeViewAll(
      {required String type,
      required String page,
      String? limit,
      String? search}) {
    if (search?.isNotEmpty == true) {
      return '/home/viewAll/$type?page=$page&search=$search'; // &search=${search ?? ""}
    } else {
      return '/home/viewAll/$type?page=$page&limit=${limit ?? 20}';
    }
  }

  static String content = '/content';

  static String postBookMarkWatchList(String contentId) =>
      "/$content/$contentId";

  static String postReport = "/support?userId=${Session.userId}";

  static String interaction = "/interaction";

  static String getSearch(String search) =>
      search.isNotEmpty ? "/search?search=$search" : "/search";

  static String getReels = '/reels';

  // 'https://vista-flicks-recommendation-api.onrender.com/api/v1/reels/feed';

  static String getSimilar(String contentId) => "/$content/$contentId/similar";

  static String getReview(String contentId) => "/$content/$contentId/reviews";

  static String getComments(String reelId) => "/comment/$reelId";

  static String getAboutContent(String contentId) =>
      "/$content/$contentId/about";

  /// Bookmark
  static String getBookmarkBanner = "/banner/bookMarked";

  static String getAllBookmarks(int pageNo, String search, String limit) =>
      search.isNotEmpty
          ? "/content/bookMarked?page=$pageNo&limit=$limit&search=$search"
          : "/content/bookMarked?page=$pageNo&limit=$limit";

  /// Chatbot
  static String chatBot = "https://reelrecs.codnestx.com/chat";
}
