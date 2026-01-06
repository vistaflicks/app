import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:injectable/injectable.dart';
import 'package:vista_flicks/framework/controller/main/reel/reels_controller.dart';
import 'package:vista_flicks/framework/repository/auth/on_boarding/model/generate_otp_response_model.dart';
import 'package:vista_flicks/framework/repository/auth/on_boarding/model/register_user_response_model.dart';
import 'package:vista_flicks/framework/repository/auth/on_boarding/model/verify_otp_response_model.dart';
import 'package:vista_flicks/framework/utils/extension/string_extension.dart';
import 'package:vista_flicks/ui/routing/navigation_stack_item.dart';
import 'package:vista_flicks/ui/utils/helper/location_helper/location_helper.dart';

import '../../../../ui/routing/stack.dart';
import '../../../../ui/utils/const/form_validations.dart';
import '../../../../ui/utils/helper/image_picker_manager.dart';
import '../../../../ui/utils/theme/app_strings.g.dart';
import '../../../../ui/utils/theme/theme.dart';
import '../../../../ui/utils/widgets/common_dialogs.dart';
import '../../../dependency_injection/inject.dart';
import '../../../provider/network/api_result.dart';
import '../../../provider/network/network_exceptions.dart';
import '../../../repository/auth/on_boarding/contract/on_boarding_repository.dart';
import '../../../repository/auth/on_boarding/model/check_existing_user_response_model.dart';
import '../../../repository/common_response/common_response_model.dart';
import '../../../utils/local_storage/session.dart';
import '../../../utils/ui_state.dart';

final onBoardingController =
    ChangeNotifierProvider((ref) => getIt<OnBoardingController>());

@injectable
class OnBoardingController extends ChangeNotifier {
  OnBoardingRepository onBoardingRepository;

  OnBoardingController(this.onBoardingRepository);

  bool isEmail = false;

  // final TextEditingController inputController = TextEditingController();
  late bool isInputValid = false;
  String countryCode = '91', flagEmoji = '🇮🇳';

  // final firstNameController = TextEditingController();
  // final lastNameController = TextEditingController();
  // final emailController = TextEditingController();
  // final ageController = TextEditingController();
  // final phoneNumberController = TextEditingController();
  // var selectedAge = '';
  // var selectedGender = '';
  var isFormValid = false;
  var selectedAgeIndex = 0;

  var selectedGenderIndex = 0;
  Timer? _locationUpdateTimer;

  void startLocationUpdates(BuildContext context, WidgetRef ref) {
    _locationUpdateTimer?.cancel(); // Cancel if already running
    _locationUpdateTimer = Timer.periodic(const Duration(minutes: 10), (_) {
      locationUpdateApi(context, ref: ref);
    });
  }

  /// Profile Image
  File? profileImage;

  updateProfileImage(FileResult value) {
    profileImage = value.file;
    notifyListeners();
  }

  updateScreenState() {
    notifyListeners();
  }

  /// OTP
  String strOTP = '';
  String? strOTPError;
  bool isOtpFilled = false;
  bool isCheckAllFieldValidate = false;

  void checkAllFieldValidation() {
    isCheckAllFieldValidate = strOTP != '' && strOTPError == null;
    notifyListeners();
  }

  /// Check OTP Validation
  void checkOTPValidation(String str) {
    strOTP = str;
    strOTPError = null;

    if (strOTP.isEmpty) {
      strOTPError = LocaleKeys.keyOTPIsRequired.localized;
    } else if (strOTP.length == 6) {
      isOtpFilled = true;
      strOTPError = LocaleKeys.keyOTPLengthShouldBeDigits.localized;
    } else {
      isOtpFilled = false;
    }

    checkAllFieldValidation();
    notifyListeners();
  }

  TextEditingController otpController = TextEditingController();
  int countdown = 15; // Timer value
  Timer? _timer;

  // Start Timer Function
  void startTimer() {
    _timer?.cancel();
    countdown = 15; // Reset to 15 seconds
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        countdown--;
        notifyListeners();
      } else {
        timer.cancel();
        notifyListeners();
      }
    });
  }

  void resendCode() {
    startTimer(); // Restart timer
  }

  // Start timer when page loads

  void otpListener() {
    otpController.addListener(() {
      isOtpFilled = otpController.text.length == 6;
    });
  }

  void validateForm(firstNameController, lastNameController, inputController,
      ageController, selectedGender) {
    isFormValid = firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        // emailController.text.isNotEmpty &&
        // phoneController.text.isNotEmpty &&
        inputController.text.isNotEmpty &&
        ageController.text.isNotEmpty &&
        selectedGender.isNotEmpty;
    notifyListeners();
  }

  void countryPick(String value) {
    countryCode = value;
    notifyListeners();
  }

  void validateInput(String value) {
    if (isEmail) {
      // Validate email
      isInputValid = validateEmail(value) == null;
      print("Email Valid: $isInputValid");
      notifyListeners();
    } else {
      isInputValid = validatePhoneNumber(value) == null;
      notifyListeners();
    }
  }

  void disposeController({bool isNotify = false}) {
    // inputController.clear();

    isLoading = false;
    notifyListeners();

    if (isNotify) {
      notifyListeners();
    }
  }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  ///Progress Indicator
  bool isLoading = false;

  UIState<CheckExistingUserResponseModel> checkUserAPIState =
      UIState<CheckExistingUserResponseModel>();

  /// Login API
  Future checkUserApi(
    BuildContext context, {
    required WidgetRef ref,
    required String dialCode,
    required String inputTxt,
    // required bool isSocial
  }) async {
    checkUserAPIState.isLoading = true;
    checkUserAPIState.success = null;
    notifyListeners();

    Map<String, dynamic> map = {
      if (inputTxt.contains("@"))
        'email': inputTxt
      else
        "primaryContact": {"dialCode": dialCode, "number": inputTxt},
      // "isSocial": isSocial
    };

    ApiResult apiResult = await onBoardingRepository.checkUserApi(map: map);
    apiResult.when(success: (data) async {
      checkUserAPIState.success = data;
      checkUserAPIState.isLoading = false;

      if (checkUserAPIState.success?.success ?? false) {
        print("inputTxt from checkUserApi ==============> $inputTxt");
        // ref.read(navigationStackController).push(
        //     NavigationStackItemVerifyOtpScreen(
        //         isEmail: isEmail, inputController: inputTxt.toString()));
        // if (checkUserAPIState.success?.code == ApiEndPoints.apiStatus_200) {
        //
        // }
      }
    }, failure: (NetworkExceptions error) {
      checkUserAPIState.isLoading = false;
      notifyListeners();
      String errorMsg = NetworkExceptions.getErrorMessage(error);

      error.whenOrNull(
        notFound: (reason, response) {
          CommonResponseModel commonResponseModel =
              commonResponseModelFromJson(response.toString());
          errorMsg = commonResponseModel.message ?? '';
        },
      );
      showMessageDialog(context, errorMsg, null);
    });
    checkUserAPIState.isLoading = false;

    notifyListeners();
  }

  UIState<String> uploadToS3APIState = UIState<String>();

  Future uploadToS3(
    BuildContext context, {
    required WidgetRef ref,
    required File file,
  }) async {
    uploadToS3APIState.isLoading = true;
    uploadToS3APIState.success = null;
    notifyListeners();

    Map<String, dynamic> map = {
      "schema": "user",
      "fileName": file.path.split('/').last,
      "contentType": "image/png",
    };

    ApiResult apiResult =
        await onBoardingRepository.uploadToS3(map: map, file: file);
    print("map from uploadToS3 ==============> $map");

    apiResult.when(success: (data) async {
      uploadToS3APIState.success = data;
      uploadToS3APIState.isLoading = false;

      if (uploadToS3APIState.success != null) {
        print("Uploaded file URL: ${uploadToS3APIState.success}");
      }
    }, failure: (NetworkExceptions error) {
      uploadToS3APIState.isLoading = false;
      notifyListeners();
      String errorMsg = NetworkExceptions.getErrorMessage(error);

      error.whenOrNull(
        notFound: (reason, response) {
          CommonResponseModel commonResponseModel =
              commonResponseModelFromJson(response.toString());
          errorMsg = commonResponseModel.message ?? '';
        },
      );
      showMessageDialog(context, errorMsg, null);
    });

    uploadToS3APIState.isLoading = false;
    notifyListeners();
  }

  /// Generate Otp  API

  UIState<GenerateOtpResponseModel> generateOtpAPIState =
      UIState<GenerateOtpResponseModel>();

  Future generateOtpApi(
    BuildContext context, {
    required WidgetRef ref,
    required String dialCode,
    required String inputTxt,
  }) async {
    generateOtpAPIState.isLoading = true;
    generateOtpAPIState.success = null;
    notifyListeners();

    Map<String, dynamic> map = {
      if (isEmail)
        "email": inputTxt
      else
        "primaryContact": {"dialCode": dialCode, "number": inputTxt},
      // "userType": "app",
      "authSource": isEmail ? "email" : "phone",
    };

    ApiResult apiResult = await onBoardingRepository.generateOtpApi(map: map);

    apiResult.when(success: (data) async {
      generateOtpAPIState.success = data;
      generateOtpAPIState.isLoading = false;
      isOtpFilled = false;
      if (generateOtpAPIState.success?.success == false) {
        showMessageDialog(
            context, generateOtpAPIState.success!.message.toString(), null);
      }
      if (generateOtpAPIState.success?.success == true) {
        ref.read(navigationStackController).push(
            NavigationStackItemVerifyOtpScreen(
                isEmail: isEmail, inputController: inputTxt.toString()));
      }
    }, failure: (NetworkExceptions error) {
      generateOtpAPIState.isLoading = false;
      notifyListeners();
      String errorMsg = NetworkExceptions.getErrorMessage(error);

      error.whenOrNull(
        notFound: (reason, response) {
          CommonResponseModel commonResponseModel =
              commonResponseModelFromJson(response.toString());
          errorMsg = commonResponseModel.message ?? '';
        },
      );
      showMessageDialog(context, errorMsg, null);
    });
    generateOtpAPIState.isLoading = false;

    notifyListeners();
  }

  /// Verify Otp API

  UIState<VerifyOtpResponseModel> verifyOtpAPIState =
      UIState<VerifyOtpResponseModel>();

  Future otpVerifyApi(
    BuildContext context, {
    required WidgetRef ref,
    required String dialCode,
    required String inputTxt,
    required String otp,
    required String orderId,
  }) async {
    verifyOtpAPIState.isLoading = true;
    verifyOtpAPIState.success = null;
    notifyListeners();
    String? deviceToken = await FirebaseMessaging.instance.getToken();

    Map<String, dynamic> map = {
      if (isEmail)
        'email': inputTxt
      else
        "primaryContact": {"dialCode": dialCode, "number": inputTxt},
      "otp": otp,
      "orderId": orderId,
      "channel": isEmail ? "EMAIL" : "SMS",
      "deviceToken": deviceToken
    };

    ApiResult apiResult = await onBoardingRepository.verifyOtpApi(map: map);
    apiResult.when(success: (data) async {
      verifyOtpAPIState.success = data;
      verifyOtpAPIState.isLoading = false;
      if (verifyOtpAPIState.success?.success == false) {
        showMessageDialog(context, "Please enter correct OTP", null);
      }
      if (verifyOtpAPIState.success?.success ?? false) {
        await checkUserApi(context,
            // isSocial: false,
            ref: ref,
            dialCode: dialCode,
            inputTxt: inputTxt);

        final user = verifyOtpAPIState.success;
        if (user != null) {
          storeUserInFirebase(user.data?.user ?? VerifyOTPUser());
          Session.userData = jsonEncode(user);
          print("Session user ======> ${Session.userData}");
        }
        Session.userAccessToken =
            verifyOtpAPIState.success?.data?.tokens?.access?.token ?? '';
        Session.userMobileNo = verifyOtpAPIState
                .success?.data?.user?.primaryContact?.number
                .toString() ??
            '';
        Session.userEmail = verifyOtpAPIState.success?.data?.user?.email ?? '';
        Session.userId =
            verifyOtpAPIState.success?.data?.user?.id.toString() ?? '';
        Session.userFirstName =
            verifyOtpAPIState.success?.data?.user?.firstName ?? '';
        Session.userLastName =
            verifyOtpAPIState.success?.data?.user?.lastName ?? '';
        Session.userAge =
            verifyOtpAPIState.success?.data?.user?.age.toString() ?? '';
        Session.userGender =
            verifyOtpAPIState.success?.data?.user?.gender ?? '';
        if (checkUserAPIState.success?.data?.isNewUser == true) {
          ref
              .read(navigationStackController)
              .push(NavigationStackItemRegisterFormScreen(inputTxt: inputTxt));
        } else {
          if (verifyOtpAPIState.success?.data?.user?.ageRating?.isEmpty ==
                  true &&
              verifyOtpAPIState.success?.data?.user?.company?.isEmpty == true &&
              verifyOtpAPIState.success?.data?.user?.content?.isEmpty == true &&
              verifyOtpAPIState.success?.data?.user?.contentType?.isEmpty ==
                  true &&
              verifyOtpAPIState.success?.data?.user?.genre?.isEmpty == true &&
              verifyOtpAPIState.success?.data?.user?.imdbRating?.isEmpty ==
                  true &&
              verifyOtpAPIState.success?.data?.user?.language?.isEmpty ==
                  true &&
              verifyOtpAPIState.success?.data?.user?.ottPlatforms?.isEmpty ==
                  true) {
            ref
                .read(navigationStackController)
                .push(NavigationStackItemInitialWatchPreferencesScreen());
          } else {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
              final reelScreenWatch = ref.watch(reelsController);

              ref
                  .read(navigationStackController)
                  .pushAndRemoveAll(NavigationStackItemBlankScreen());
              LocationHandler.getCurrentPosition();
              reelScreenWatch.disposeController(isNotify: true);
              reelScreenWatch.getReels(context, ref: ref);

              reelScreenWatch.startWatchTimer(0);

              //////
            });
          }
        }
        // _handleNavigation(ref, context);

        // if (checkUserAPIState.success?.code == ApiEndPoints.apiStatus_200) {
        //
        // }
        // ref.read(navigationStackController).push(
        //     NavigationStackItemVerifyOtpScreen(
        //         isEmail: isEmail, inputController: inputTxt));
      }
    }, failure: (NetworkExceptions error) {
      verifyOtpAPIState.isLoading = false;
      notifyListeners();
      String errorMsg = NetworkExceptions.getErrorMessage(error);

      error.whenOrNull(
        notFound: (reason, response) {
          CommonResponseModel commonResponseModel =
              commonResponseModelFromJson(response.toString());
          errorMsg = commonResponseModel.message ?? '';
        },
      );
      showMessageDialog(context, errorMsg, null);
    });
    verifyOtpAPIState.isLoading = false;

    notifyListeners();
  }

  Future<void> storeUserInFirebase(VerifyOTPUser user) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference userDoc =
        firestore.collection('users').doc(user.id);

    final DocumentSnapshot docSnapshot = await userDoc.get();

    if (docSnapshot.exists) {
      // 🔁 Already exists – Update relevant fields or skip
      print('User already exists in Firebase.');

      // Optional: Update only FCM token or last login
      await userDoc.update({
        'userFcmToken': await FirebaseMessaging.instance.getToken(),
        'lastLogin': FieldValue.serverTimestamp(),
      });
    } else {
      // ✅ New user – Create entry
      final userMap = {
        'id': user.id,
        'email': user.email,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'age': user.age,
        'gender': user.gender,
        'mobile': user.primaryContact?.number,
        'dialCode': user.primaryContact?.dialCode,
        'userFcmToken': await FirebaseMessaging.instance.getToken(),
        'createdAt': FieldValue.serverTimestamp(),
      };

      await userDoc.set(userMap);
      print('New user added to Firebase.');
    }
  }

  Future socialLoginAPI(
    BuildContext context, {
    required WidgetRef ref,
    required String dialCode,
    required String inputTxt,
    String gender = "",
    int age = 0,
    required String firstName,
    required String lastName,
    required String avatar,
    required String socialType,
  }) async {
    verifyOtpAPIState.isLoading = true;
    verifyOtpAPIState.success = null;
    notifyListeners();

    String? deviceToken = await FirebaseMessaging.instance.getToken();

    Map<String, dynamic> map = {
      "firstName": firstName,
      if (lastName.isNotEmpty) "lastName": lastName,
      "social": socialType,
      //  if(avatar.isNotEmpty) "avatar": avatar,
      if (gender.isNotEmpty) "gender": gender,
      if (age != 0) "age": age,
      if (inputTxt.contains("@")) "email": inputTxt,
      if (!inputTxt.contains("@"))
        "primaryContact": {"dialCode": dialCode, "number": inputTxt},
      "deviceToken": deviceToken
    };

    ApiResult apiResult = await onBoardingRepository.socialLoginApi(map: map);
    apiResult.when(success: (data) async {
      verifyOtpAPIState.success = data;
      verifyOtpAPIState.isLoading = false;

      if (verifyOtpAPIState.success?.success ?? false) {
        _handleNavigation(ref, context);
        // storeUserInFirebase(
        //     verifyOtpAPIState.success?.data?.user ?? VerifyOTPUser());
        // Session.userData = jsonEncode(verifyOtpAPIState.success);
        // Session.userAccessToken =
        //     verifyOtpAPIState.success?.data?.tokens?.access?.token ?? '';
        // Session.userMobileNo = verifyOtpAPIState
        //         .success?.data?.user?.primaryContact?.number
        //         .toString() ??
        //     '';
        // Session.userEmail = verifyOtpAPIState.success?.data?.user?.email ?? '';
        // Session.userId =
        //     verifyOtpAPIState.success?.data?.user?.id.toString() ?? '';
        // Session.userFirstName =
        //     verifyOtpAPIState.success?.data?.user?.firstName ?? '';
        // Session.userLastName =
        //     verifyOtpAPIState.success?.data?.user?.lastName ?? '';
        // Session.userAge =
        //     verifyOtpAPIState.success?.data?.user?.age.toString() ?? '';
        // Session.userGender =
        //     verifyOtpAPIState.success?.data?.user?.gender ?? '';

        // if (verifyOtpAPIState.success?.data?.isNewUser == true) {
        //   ref
        //       .read(navigationStackController)
        //       .push(NavigationStackItemInitialWatchPreferencesScreen());
        // } else {
        //   ref
        //       .read(navigationStackController)
        //       .pushAndRemoveAll(NavigationStackItemBlankScreen());
        // }
      }
    }, failure: (NetworkExceptions error) {
      verifyOtpAPIState.isLoading = false;
      notifyListeners();
      String errorMsg = NetworkExceptions.getErrorMessage(error);

      error.whenOrNull(
        notFound: (reason, response) {
          CommonResponseModel commonResponseModel =
              commonResponseModelFromJson(response.toString());
          errorMsg = commonResponseModel.message ?? '';
        },
      );
      showMessageDialog(context, errorMsg, null);
    });
    verifyOtpAPIState.isLoading = false;

    notifyListeners();
  }

  void _handleNavigation(WidgetRef ref, BuildContext context) {
    storeUserInFirebase(
        verifyOtpAPIState.success?.data?.user ?? VerifyOTPUser());
    Session.userData = jsonEncode(verifyOtpAPIState.success);
    Session.userAccessToken =
        verifyOtpAPIState.success?.data?.tokens?.access?.token ?? '';
    Session.userMobileNo = verifyOtpAPIState
            .success?.data?.user?.primaryContact?.number
            .toString() ??
        '';
    Session.userEmail = verifyOtpAPIState.success?.data?.user?.email ?? '';
    Session.userId = verifyOtpAPIState.success?.data?.user?.id.toString() ?? '';
    Session.userFirstName =
        verifyOtpAPIState.success?.data?.user?.firstName ?? '';
    Session.userLastName =
        verifyOtpAPIState.success?.data?.user?.lastName ?? '';
    Session.userAge =
        verifyOtpAPIState.success?.data?.user?.age.toString() ?? '';
    Session.userGender = verifyOtpAPIState.success?.data?.user?.gender ?? '';
    Session.userType = verifyOtpAPIState.success?.data?.user?.userType ?? '';

    if (verifyOtpAPIState.success?.data?.isNewUser == true) {
      ref
          .read(navigationStackController)
          .push(NavigationStackItemInitialWatchPreferencesScreen());
    } else {
      if (verifyOtpAPIState.success?.data?.user?.ageRating?.isEmpty == true &&
          verifyOtpAPIState.success?.data?.user?.company?.isEmpty == true &&
          verifyOtpAPIState.success?.data?.user?.content?.isEmpty == true &&
          verifyOtpAPIState.success?.data?.user?.contentType?.isEmpty == true &&
          verifyOtpAPIState.success?.data?.user?.genre?.isEmpty == true &&
          verifyOtpAPIState.success?.data?.user?.imdbRating?.isEmpty == true &&
          verifyOtpAPIState.success?.data?.user?.language?.isEmpty == true &&
          verifyOtpAPIState.success?.data?.user?.ottPlatforms?.isEmpty ==
              true) {
        ref
            .read(navigationStackController)
            .push(NavigationStackItemInitialWatchPreferencesScreen());
      } else {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
          final reelScreenWatch = ref.watch(reelsController);

          ref
              .read(navigationStackController)
              .pushAndRemoveAll(NavigationStackItemBlankScreen());
          LocationHandler.getCurrentPosition();
          reelScreenWatch.disposeController(isNotify: true);
          reelScreenWatch.getReels(context, ref: ref);

          reelScreenWatch.startWatchTimer(0);

          //////
        });
      }
    }
  }

  /// Resend Otp API

  var resendOtpAPIState = UIState<CommonResponseModel>();

  Future resendOtpApi(
    BuildContext context, {
    required WidgetRef ref,
    required String orderId,
  }) async {
    resendOtpAPIState.isLoading = true;
    resendOtpAPIState.success = null;
    notifyListeners();

    Map<String, dynamic> map = {'orderId': orderId};

    ApiResult apiResult = await onBoardingRepository.resendOtpApi(map: map);
    apiResult.when(success: (data) async {
      resendOtpAPIState.success = data;
      resendOtpAPIState.isLoading = false;
    }, failure: (NetworkExceptions error) {
      resendOtpAPIState.isLoading = false;
      notifyListeners();
      String errorMsg = NetworkExceptions.getErrorMessage(error);

      error.whenOrNull(
        notFound: (reason, response) {
          CommonResponseModel commonResponseModel =
              commonResponseModelFromJson(response.toString());
          errorMsg = commonResponseModel.message ?? '';
        },
      );
      showMessageDialog(context, errorMsg, null);
    });
    resendOtpAPIState.isLoading = false;

    notifyListeners();
  }

  /// Resend Otp API

  var locationUpdateAPIState = UIState<CommonResponseModel>();

  Future locationUpdateApi(
    BuildContext context, {
    required WidgetRef ref,
  }) async {
    locationUpdateAPIState.isLoading = true;
    locationUpdateAPIState.success = null;
    notifyListeners();
    String? city = '';
    String? state = '';
    String? country = '';
    List<Placemark> placemarks;

    if (LocationHandler.currentPosition != null) {
      try {
        placemarks = await placemarkFromCoordinates(
          LocationHandler.currentPosition!.latitude,
          LocationHandler.currentPosition!.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          city = place.locality;
          state = place.administrativeArea;
          country = place.country;
        }
      } catch (e) {
        log('Error getting address details: $e');
      }
    }
    Map<String, dynamic> map = {
      "latitude": LocationHandler.currentPosition!.latitude,
      "longitude": LocationHandler.currentPosition!.longitude,
      "stateName": state,
      "city": city
    };

    ApiResult apiResult =
        await onBoardingRepository.locationUpdateApi(map: map);
    apiResult.when(success: (data) async {
      locationUpdateAPIState.success = data;
      locationUpdateAPIState.isLoading = false;
    }, failure: (NetworkExceptions error) {
      locationUpdateAPIState.isLoading = false;
      notifyListeners();
      String errorMsg = NetworkExceptions.getErrorMessage(error);

      error.whenOrNull(
        notFound: (reason, response) {
          CommonResponseModel commonResponseModel =
              commonResponseModelFromJson(response.toString());
          errorMsg = commonResponseModel.message ?? '';
        },
      );
      // showMessageDialog(context, errorMsg, null);
    });
    locationUpdateAPIState.isLoading = false;

    notifyListeners();
  }

  /// Logout api
  UIState<CommonResponseModel> logoutApiState = UIState<CommonResponseModel>();

  Future logoutApi(BuildContext context, WidgetRef ref) async {
    logoutApiState.isLoading = true;
    logoutApiState.success = null;
    notifyListeners();

    ApiResult apiResult = await onBoardingRepository.logoutApi();
    apiResult.when(success: (data) async {
      logoutApiState.success = data;
      logoutApiState.isLoading = false;
    }, failure: (NetworkExceptions error) {
      logoutApiState.isLoading = false;
      notifyListeners();
      String errorMsg = NetworkExceptions.getErrorMessage(error);

      error.whenOrNull(
        notFound: (reason, response) {
          CommonResponseModel commonResponseModel =
              commonResponseModelFromJson(response.toString());
          errorMsg = commonResponseModel.message ?? '';
        },
      );
      showMessageDialog(context, errorMsg, null);
    });
    logoutApiState.isLoading = false;

    notifyListeners();
  }

  /// Register  API

  UIState<RegisterUserResponseModel> registerUserAPIState =
      UIState<RegisterUserResponseModel>();

  Future registerUserApi(
    BuildContext context, {
    required WidgetRef ref,
    required String firstName,
    required String lastName,
    required String dialCode,
    required String age,
    required String gender,
    required String inputTxt,
  }) async {
    registerUserAPIState.isLoading = true;
    registerUserAPIState.success = null;
    notifyListeners();

    Map<String, dynamic> map = {
      "firstName": firstName,
      "lastName": lastName,
      "gender": gender,
      "age": int.parse(age),
      if (isEmail) "isEmailVerified": true else "isPhoneVerified": true,
      if (isEmail)
        "email": inputTxt
      else
        "primaryContact": {"dialCode": dialCode, "number": inputTxt},
      // "userType": "app",
      // "authSource": isEmail ? "email" : "phone",
    };

    ApiResult apiResult = await onBoardingRepository.registerApi(
        map: map, id: verifyOtpAPIState.success?.data?.user?.id ?? "");
    print("map from registerUserApi ==============> $map");
    print("isEmail from registerUserApi ==============>$isEmail");
    apiResult.when(success: (data) async {
      registerUserAPIState.success = data;
      registerUserAPIState.isLoading = false;

      if (registerUserAPIState.success?.success ?? false) {
        print("map from registerUserApi ==============>$isEmail $map");
        Session.userFirstName =
            registerUserAPIState.success?.data?.firstName ?? '';
        Session.userLastName =
            registerUserAPIState.success?.data?.lastName ?? '';
        Session.userEmail = registerUserAPIState.success?.data?.email ?? '';
        Session.userMobileNo = registerUserAPIState
                .success?.data?.primaryContact?.number
                .toString() ??
            '';
        Session.userAge =
            registerUserAPIState.success?.data?.age.toString() ?? '';
        Session.userGender = registerUserAPIState.success?.data?.gender ?? '';
        print(
            "registerUserAPIState.success?.success from registerUserApi ==============>${registerUserAPIState.success?.success}");

        print(
            "registerUserAPIState.success?.data?.isNewUser ========>${checkUserAPIState.success?.data?.isNewUser}");
        print(
            "registerUserAPIState.success?.data?.user?.email ========>${registerUserAPIState.success?.data?.email}");
        print(
            "registerUserAPIState.success?.data?.primaryContact?.number ========>${registerUserAPIState.success?.data?.primaryContact?.number}");
        print(
            "registerUserAPIState.success?.data?.user?.age ========>${registerUserAPIState.success?.data?.age}");
        print(
            "registerUserAPIState.success?.data?.user?.gender ========>${registerUserAPIState.success?.data?.gender}");
        ref
            .read(navigationStackController)
            .push(NavigationStackItem.initWatchPref());
        // if (checkUserAPIState.success?.code == ApiEndPoints.apiStatus_200) {
        //
        // }
      }
    }, failure: (NetworkExceptions error) {
      registerUserAPIState.isLoading = false;
      notifyListeners();
      String errorMsg = NetworkExceptions.getErrorMessage(error);

      error.whenOrNull(
        notFound: (reason, response) {
          CommonResponseModel commonResponseModel =
              commonResponseModelFromJson(response.toString());
          errorMsg = commonResponseModel.message ?? '';
        },
      );
      showMessageDialog(context, errorMsg, null);
    });
    registerUserAPIState.isLoading = false;

    notifyListeners();
  }

  /// Update User Detail  API

  UIState<RegisterUserResponseModel> updateUserProfileAPIState =
      UIState<RegisterUserResponseModel>();

  Future updateUserProfileApi(
    BuildContext context, {
    required WidgetRef ref,
    required String firstName,
    required String lastName,
    required String dialCode,
    required String age,
    required String gender,
    required String inputFieldTxt,
    // required String emailInputTxt,
  }) async {
    updateUserProfileAPIState.isLoading = true;
    updateUserProfileAPIState.success = null;
    notifyListeners();

    Map<String, dynamic> map = {
      "firstName": firstName,
      "lastName": lastName,
      "gender": gender,
      "age": int.parse(age),
      // "isEmailVerified": false,
      // if (isEmail) "isEmailVerified": true else "isPhoneVerified": true,
      //

      if (uploadToS3APIState.success != null)
        "avatar": uploadToS3APIState.success.toString(),
      // else
      // if (isEmail) "email": inputFieldTxt ?? "",
      // if (!isEmail)
      //   "primaryContact": {"dialCode": dialCode, "number": inputFieldTxt ?? ""},
      // "userType": "app",
      // "authSource": isEmail ? "email" : "phone",
    };

    ApiResult apiResult =
        await onBoardingRepository.registerApi(map: map, id: Session.userId);
    apiResult.when(success: (data) async {
      updateUserProfileAPIState.success = data;
      updateUserProfileAPIState.isLoading = false;

      if (updateUserProfileAPIState.success?.success ?? false) {
        Session.userFirstName =
            registerUserAPIState.success?.data?.firstName ?? '';
        Session.userLastName =
            registerUserAPIState.success?.data?.lastName ?? '';
        Session.userEmail = registerUserAPIState.success?.data?.email ?? '';
        Session.userMobileNo = registerUserAPIState
                .success?.data?.primaryContact?.number
                .toString() ??
            '';
        Session.userAge =
            registerUserAPIState.success?.data?.age.toString() ?? '';
        Session.userGender = registerUserAPIState.success?.data?.gender ?? '';
        Session.userType = registerUserAPIState.success?.data?.userType ?? '';
        ref.read(navigationStackController).pop();
      }
    }, failure: (NetworkExceptions error) {
      updateUserProfileAPIState.isLoading = false;
      notifyListeners();
      String errorMsg = NetworkExceptions.getErrorMessage(error);

      error.whenOrNull(
        notFound: (reason, response) {
          CommonResponseModel commonResponseModel =
              commonResponseModelFromJson(response.toString());
          errorMsg = commonResponseModel.message ?? '';
        },
      );
      showMessageDialog(context, errorMsg, null);
    });
    updateUserProfileAPIState.isLoading = false;

    notifyListeners();
  }

  /// Get Profile Api
  var getProfileApiState = UIState<RegisterUserResponseModel>();

  Future<void> getProfileApi(BuildContext context) async {
    getProfileApiState.isLoading = true;
    getProfileApiState.success = null;
    notifyListeners();

    if (context.mounted) {
      final res = await onBoardingRepository.getProfileApi(
          verifyOtpAPIState.success?.data?.user?.id.toString() ??
              Session.userId);
      res.when(success: (data) async {
        getProfileApiState.success = data;
        getProfileApiState.isLoading = false;
        Session.userFirstName =
            getProfileApiState.success?.data?.firstName ?? '';
        Session.userLastName = getProfileApiState.success?.data?.lastName ?? '';
        Session.userEmail = getProfileApiState.success?.data?.email ?? '';
        Session.userMobileNo = getProfileApiState
                .success?.data?.primaryContact?.number
                .toString() ??
            '';
        Session.userAge =
            getProfileApiState.success?.data?.age.toString() ?? '';
        Session.userGender = getProfileApiState.success?.data?.gender ?? '';
        Session.userProfileImage =
            getProfileApiState.success?.data?.avatar ?? '';

        print(
            "getProfileApiState.success?.data?.primaryContact?.number ========>${getProfileApiState.success?.data?.primaryContact?.number.toString()}");

        notifyListeners();
      }, failure: (NetworkExceptions error) {
        String errorMsg = NetworkExceptions.getErrorMessage(error);
        showMessageDialog(context, errorMsg, () {});
      });
    }
    getProfileApiState.isLoading = false;
    notifyListeners();
  }

  /// Logout api
  UIState<CommonResponseModel> deleteAccountApiState =
      UIState<CommonResponseModel>();

  Future deleteAccount(BuildContext context, WidgetRef ref) async {
    deleteAccountApiState.isLoading = true;
    deleteAccountApiState.success = null;
    notifyListeners();

    ApiResult apiResult = await onBoardingRepository.deleteAccount();
    apiResult.when(success: (data) async {
      deleteAccountApiState.success = data;
      await Session.sessionLogout(ref);

      deleteAccountApiState.isLoading = false;
    }, failure: (NetworkExceptions error) {
      deleteAccountApiState.isLoading = false;
      notifyListeners();
      String errorMsg = NetworkExceptions.getErrorMessage(error);

      error.whenOrNull(
        notFound: (reason, response) {
          CommonResponseModel commonResponseModel =
              commonResponseModelFromJson(response.toString());
          errorMsg = commonResponseModel.message ?? '';
        },
      );
      showMessageDialog(context, errorMsg, null);
    });
    deleteAccountApiState.isLoading = false;

    notifyListeners();
  }

  void onInit(TextEditingController inputController) {
    inputController.addListener(() {
      // isPhoneNumberValid.value =
      // Validator.validatePhoneNumber(phoneController.text) == null;
      // validatePhoneNumber(inputController.text);
      // firstNameController.addListener(validateForm);
      // lastNameController.addListener(validateForm);
      // emailController.addListener(validateForm);
      // phoneNumberController.addListener(validateForm);
      validateInput(inputController.text);
      notifyListeners();
    });
  }
}
