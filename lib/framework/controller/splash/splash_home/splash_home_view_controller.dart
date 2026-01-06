import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:vista_flicks/framework/controller/auth/on_boarding/on_boarding_controller.dart';
import 'package:vista_flicks/framework/controller/main/reel/reels_controller.dart';

import '../../../../ui/utils/theme/theme.dart';
import '../../../dependency_injection/inject.dart';

final splashHomeController =
    ChangeNotifierProvider((ref) => getIt<SplashHomeController>());

@injectable
class SplashHomeController extends ChangeNotifier {
  bool isLoading = false;
  int type = 0;

  Future<void> loginWithApple(BuildContext context, WidgetRef ref) async {
    try {
      type = 1;
      isLoading = true;
      notifyListeners();
      final rawNonce = generateNonce();
      final onBoardingWatch = ref.watch(onBoardingController);

      // AppleLoginManager appleLoginManager = AppleLoginManager.instance;

      // await appleLoginManager.appleLoginAPI(context, (appleDataModel) async {
      //   print("appleDataModel => ${appleDataModel.email}");
      //   print("appleDataModel => ${appleDataModel.appleId}");
      //   print("appleDataModel => ${appleDataModel.firstName}");
      //   print("appleDataModel => ${appleDataModel.lastName}");
      // }, (error) {
      //   print("error => $error");
      // });

      await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      ).then(
        (result) async {
          if (result.userIdentifier != null) {
            final oauthCredential = OAuthProvider("apple.com").credential(
              idToken: result.identityToken,
              rawNonce: rawNonce,
              accessToken: result.authorizationCode,
            );
            UserCredential results = await FirebaseAuth.instance
                .signInWithCredential(oauthCredential);
            if (results.user != null) {
              final user = results.user;

              debugPrint(
                  "✅ Apple Login + Firebase Auth Successful: ${user?.email}");

              final appleUserId = result.userIdentifier;

              // Try extracting from Apple
              String? email = user?.email ?? result.email;
              String fullName = [result.givenName, result.familyName]
                  .where((e) => e != null && e.isNotEmpty)
                  .join(' ');

              debugPrint("Apple email: ${result.email}");
              debugPrint("Firebase user email: ${user?.email}");
              debugPrint("Firebase user phone: ${user?.phoneNumber}");

              // Try fetching from secure storage or backend if email or name is null (returning user)
              if ((email == null || email.isEmpty) || fullName.isEmpty) {
                final storedUserData =
                    await getAppleUserDataFromLocal(appleUserId ?? "");

                email = email ?? storedUserData['email'] ?? '';
                fullName = fullName.isNotEmpty
                    ? fullName
                    : '${storedUserData['firstName'] ?? ''} ${storedUserData['lastName'] ?? ''}'
                        .trim();
              } else {
                // Store the Apple data for future use (first time only)
                await storeAppleUserDataToLocal(
                  appleUserId ?? "",
                  email: email,
                  firstName: result.givenName ?? '',
                  lastName: result.familyName ?? '',
                );
              }

              // Split names
              final nameParts = fullName.trim().split(' ');
              final firstName = nameParts.isNotEmpty ? nameParts.first : '';
              final lastName =
                  nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

              final inputTxt =
                  email.isNotEmpty ? email : (user?.phoneNumber ?? '');
              final socialType = "apple";

              await onBoardingWatch.socialLoginAPI(
                context,
                ref: ref,
                dialCode: inputTxt.contains("@")
                    ? inputTxt
                    : inputTxt.substring(0, 3),
                inputTxt:
                    inputTxt.contains("@") ? inputTxt : inputTxt.substring(3),
                firstName: firstName,
                lastName: lastName,
                avatar: "", // Apple doesn't provide avatarSignInWithApple
                socialType: socialType,
              );
            }
          }
        },
      );
    } catch (error) {
      debugPrint("❌ Apple Login Failed: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  static const _chars =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';

  /// Generate a cryptographically secure random nonce
  String generateNonce({int length = 32}) {
    final random = Random.secure();

    return Iterable.generate(
      length,
      (_) => _chars[random.nextInt(_chars.length)],
    ).join();
  }

  Future<void> storeAppleUserDataToLocal(
    String userId, {
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('apple_user_email_$userId', email);
    await prefs.setString('apple_user_first_name_$userId', firstName);
    await prefs.setString('apple_user_last_name_$userId', lastName);
  }

  Future<Map<String, String>> getAppleUserDataFromLocal(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString('apple_user_email_$userId') ?? '',
      'firstName': prefs.getString('apple_user_first_name_$userId') ?? '',
      'lastName': prefs.getString('apple_user_last_name_$userId') ?? '',
    };
  }

  // Future<void> loginWithApple(context, WidgetRef ref) async {
  //   try {
  //     type = 1;
  //     isLoading = true;
  //     final onBoardingWatch = ref.watch(onBoardingController);

  //     final appleCredential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //     );

  //     final oauthCredential = OAuthProvider("apple.com").credential(
  //       idToken: appleCredential.identityToken,
  //       accessToken: appleCredential.authorizationCode,
  //     );

  //     final userCredential =
  //         await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  //     final user = userCredential.user;

  //     debugPrint("✅ Apple Login + Firebase Auth Successful: ${user?.email}");

  //     // Extract user data
  //     final email = user?.email ?? appleCredential.email ?? '';
  //     final fullName = [appleCredential.givenName, appleCredential.familyName]
  //         .where((e) => e != null && e.isNotEmpty)
  //         .join(' ');

  //     final nameParts = fullName.split(' ');
  //     final firstName = nameParts.isNotEmpty ? nameParts.first : '';
  //     final lastName =
  //         nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

  //     final inputTxt = email.isNotEmpty ? email : (user?.phoneNumber ?? '');
  //     final socialType = "apple";

  //     await onBoardingWatch.socialLoginAPI(
  //       context,
  //       ref: ref,

  //       dialCode: inputTxt.contains("@") ? inputTxt : inputTxt.substring(0, 3),
  //       inputTxt: inputTxt.contains("@") ? inputTxt : inputTxt.substring(3),
  //       firstName: firstName,
  //       lastName: lastName,
  //       avatar: "", // Apple doesn't provide avatar
  //       socialType: socialType,
  //     );

  //     isLoading = false;

  //     notifyListeners();

  //     // Call your backend API with `idToken`
  //   } catch (error) {
  //     debugPrint("❌ Apple Login Failed: $error");
  //   }
  // }

  Future<void> loginWithGoogle(context, WidgetRef ref) async {
    final reelsWatch = ref.watch(reelsController);

    try {
      type = 2;
      isLoading = true;
      final onBoardingWatch = ref.watch(onBoardingController);
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // clientId:
      //     "1071319888527-r2g1lbk9uvu34g0dhr3uqvdmdq7qhrvh.apps.googleusercontent.com");

      await googleSignIn.signOut();
      final GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account != null) {
        final GoogleSignInAuthentication googleAuth =
            await account.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final user = userCredential.user;

        debugPrint("✅ Google Login + Firebase Auth Successful: ${user?.email}");

        final fullName = user?.displayName ?? '';
        final avatar = user?.photoURL ?? '';
        final nameParts = fullName.split(' ');

        final firstName = nameParts.isNotEmpty ? nameParts.first : '';
        final lastName =
            nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

        // Placeholder/defaults — customize as needed
        final inputTxt = user?.email ??
            user?.phoneNumber ??
            ''; // Maybe from a form input before this

        final socialType = "google";

        await onBoardingWatch.socialLoginAPI(
          context,
          ref: ref,
          dialCode: inputTxt.substring(0, 3),
          inputTxt: inputTxt.contains("@") ? inputTxt : inputTxt.substring(3),
          firstName: firstName,
          lastName: lastName,
          avatar: avatar,
          socialType: socialType,
        );
        reelsWatch.getReels(context, ref: ref);
        onBoardingWatch.isEmail = true;
        isLoading = false;

        notifyListeners();
      }
    } catch (error) {
      debugPrint("❌ Google Login Failed: $error");
      isLoading = false;
      notifyListeners();
    }
  }

  // Future<void> loginWithFacebook(context, WidgetRef ref) async {
  //   try {
  //     type = 3;
  //     isLoading = true;
  //     final onBoardingWatch = ref.watch(onBoardingController);
  //     final LoginResult result = await FacebookAuth.instance.login();

  //     if (result.status == LoginStatus.success) {
  //       final facebookCredential =
  //           FacebookAuthProvider.credential(result.accessToken!.tokenString);

  //       final userCredential = await FirebaseAuth.instance
  //           .signInWithCredential(facebookCredential);
  //       final user = userCredential.user;

  //       debugPrint(
  //           "✅ Facebook Login + Firebase Auth Successful: ${user?.email}");

  //       final userData = await FacebookAuth.instance.getUserData();
  //       final fullName = user?.displayName ?? userData['name'] ?? '';
  //       final avatar =
  //           user?.photoURL ?? userData['picture']['data']['url'] ?? '';
  //       final email = user?.email ?? userData['email'] ?? '';

  //       final nameParts = fullName.split(' ');
  //       final firstName = nameParts.isNotEmpty ? nameParts.first : '';
  //       final lastName =
  //           nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

  //       final inputTxt = email.isNotEmpty ? email : (user?.phoneNumber ?? '');
  //       final socialType = "facebook";

  //       await onBoardingWatch.socialLoginAPI(
  //         context,
  //         ref: ref,
  //         dialCode: inputTxt.substring(0, 3),
  //         inputTxt: inputTxt.contains("@") ? inputTxt : inputTxt.substring(3),
  //         firstName: firstName,
  //         lastName: lastName,
  //         avatar: avatar,
  //         socialType: socialType,
  //       );

  //       isLoading = false;
  //       notifyListeners();
  //     } else {
  //       debugPrint("❌ Facebook Login Failed: ${result.status}");
  //       isLoading = false;
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     debugPrint("❌ Facebook Login Error: $e");
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

  void disposeController({bool isNotify = false}) {
    isLoading = false;

    if (isNotify) {
      notifyListeners();
    }
  }
}
