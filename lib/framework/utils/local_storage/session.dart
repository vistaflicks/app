import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:vista_flicks/framework/controller/blank/blank_controller.dart';

import '../../../ui/routing/navigation_stack_item.dart';
import '../../../ui/routing/stack.dart';
import '../../../ui/utils/const/app_constants.dart';
import '../../../ui/utils/theme/theme.dart';

const String keyAppLanguage = 'keyAppLanguage';
const String keyUserType = 'keyUserType';
const String keyUserAuthToken = 'keyUserAuthToken';
const String keyDeviceFCMToken = 'keyDeviceFCMToken';
const String keyDesignSize = 'keyDesignSize';
const String keyMyWeatherLocalData = 'keyMyWeatherLocalData';
const String keyUserFirstName = 'keyUserFirstName';
const String keyUserLastName = 'keyUserLastName';
const String keyUserEmail = 'keyUserEmail';
const String keyUserMobile = 'keyUserMobile';
const String keyUserGender = 'keyUserGender';
const String keyUserAge = 'keyUserAge';
const String keyCity = 'keyCity';
const String keyUserProfileImage = 'keyUserProfileImage';
const String keyUserId = 'keyUserId';
const String keyStartSubscriptionDate = 'keyStartSubscriptionDate';
const String keyEndSubscriptionDate = 'keyEndSubscriptionDate';
const String keyIsSubscribed = 'keyIsSubscribed';
const String keyFirebaseResponse = 'keyFirebaseResponse';
const String keyFirebaseUId = 'keyFirebaseUId';
const String keyUserData = 'keyUserData';

const String keyOnBoardingStatus = 'keyOnBoardingStatus';

class Session {
  Session._();

  static var sessionBox = Hive.box(hiveSessionBox);

  static String get userAccessToken => (sessionBox.get(keyUserAuthToken) ?? '');

  static set userAccessToken(String userAccessToken) =>
      (saveLocalData(keyUserAuthToken, userAccessToken));

  static String get appLanguage => (sessionBox.get(keyAppLanguage) ?? 'en');

  static set appLanguage(String appLanguage) =>
      (saveLocalData(keyAppLanguage, appLanguage));

  /// User Data
  ///
  static String get userData => (sessionBox.get(keyUserData) ?? "");

  static set userData(String? userData) {
    if (userData != null) {
      saveLocalData(keyUserData, userData);
    }
  }

  static String get userType => (sessionBox.get(keyUserType) ?? '');

  static set userType(String userType) =>
      (saveLocalData(keyUserType, userType));

  static String get userFirstName => (sessionBox.get(keyUserFirstName) ?? '');

  static set userFirstName(String userFirstName) =>
      (saveLocalData(keyUserFirstName, userFirstName));

  static String get userLastName => (sessionBox.get(keyUserLastName) ?? '');

  static set userLastName(String userLastName) =>
      (saveLocalData(keyUserLastName, userLastName));

  static String get userGender => (sessionBox.get(keyUserGender) ?? '');

  static set userGender(String userGender) =>
      (saveLocalData(keyUserGender, userGender));

  static String get userAge => (sessionBox.get(keyUserAge) ?? '');

  static String get deviceFCMToken => (sessionBox.get(keyDeviceFCMToken) ?? '');

  static set deviceFCMToken(String deviceFCMToken) =>
      (saveLocalData(keyDeviceFCMToken, deviceFCMToken));

  static set userAge(String userAge) => (saveLocalData(keyUserAge, userAge));

  static String get userId => (sessionBox.get(keyUserId) ?? "");

  static set userId(String id) => (saveLocalData(keyUserId, id));

  static String get userEmail => (sessionBox.get(keyUserEmail) ?? '');

  static set userEmail(String email) => (saveLocalData(keyUserEmail, email));

  static String get userMobileNo => (sessionBox.get(keyUserMobile) ?? '');

  static set userMobileNo(String mobile) =>
      (saveLocalData(keyUserMobile, mobile));

  static String get userCity => (sessionBox.get(keyCity) ?? '');

  static set userCity(String city) => (saveLocalData(keyCity, city));

  static String get userProfileImage => (sessionBox.get(keyUserProfileImage) !=
              '' &&
          sessionBox.get(keyUserProfileImage) != null
      ? sessionBox.get(keyUserProfileImage)
      : 'https://img.freepik.com/free-vector/user-circles-set_78370-4704.jpg');

  static set userProfileImage(String imageUrl) =>
      (saveLocalData(keyUserProfileImage, imageUrl));

  ///Save Local Data
  static saveLocalData(String key, value) {
    sessionBox.put(key, value);
  }

  ///Session Logout
  static Future sessionLogout(WidgetRef ref) async {
    // String appLanguage = getAppLanguage();
    // String isOnBoarding = getIsOnBoardingShowed();
    // String deviceToken = getDeviceFCMToken();

    await Session.sessionBox.clear().then((value) async {
      // await Session.saveLocalData(keyIsOnBoardingShowed, true);
      // Session.saveLocalData(isGuestUser, true);
      // Session.saveLocalData(showLanguageScreen, false);
      // saveLocalData(keyAPP_LANGUAGE, appLanguage);
      // saveLocalData(keyIS_ONBOARDING_SHOWED, isOnBoarding);
      // saveLocalData(keyFCM_DEVICE_TOKEN, deviceToken);

      debugPrint(
          '===========================YOU LOGGED OUT FROM THE APP==============================');
      ref.read(blankController).setIndex(0);

      /// Delete device token api calling
      ref
          .read(navigationStackController)
          .pushAndRemoveAll(const NavigationStackItem.splashHome());
    });
  }

  static Size get designSize {
    String? size = sessionBox.get(keyDesignSize);
    if (size != null) {
      return Size(double.parse(size.split('+').first),
          double.parse(size.split('+').last));
    }
    return const Size(1, 1);
  }

  static set designSize(Size designSize) => (sessionBox.put(
      keyDesignSize,
      designSize != const Size(1, 1)
          ? '${designSize.width}+${designSize.height}'
          : null));
}
