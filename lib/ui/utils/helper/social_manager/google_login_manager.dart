import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../const/app_constants.dart';

class GoogleLoginManager {
  GoogleLoginManager._privateConstructor();

  static final GoogleLoginManager instance =
      GoogleLoginManager._privateConstructor();

  Future<void> googleLoginAPI(
      BuildContext context,
      Function(GoogleDataModel googleDataModel) resultCallBack,
      Function(dynamic error) failureCallBack) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? user = googleSignIn.currentUser;

    String token = '';
    // _googleSignIn.signOut();
    showLog('User Data from Google : $user');

    if (user == null) {
      await googleSignIn.signIn().then((account) {
        user = account;
        // print("User Response from google${user.}");

        if (account != null) {
          account.authentication.then((googleKey) async {
            token = googleKey.accessToken ?? '';
            showLog('accessToken: $token');
            showLog('idToken: ${googleKey.idToken}');
            showLog('displayName: ${googleSignIn.currentUser?.displayName}');
          }).catchError((err) {
            googleSignIn.signOut();
            showLog('inner error');
          });
        }
      }, onError: (error) {
        showLog('google error : $error');
        googleSignIn.signOut();
        failureCallBack(error);
      });
    }

    if (user != null) {
      user!.authentication.then((googleKey) async {
        token = googleKey.accessToken ?? '';
        showLog('accessToken: ${googleKey.accessToken}');
        showLog('idToken: ${googleKey.idToken}');
        showLog('displayName: ${googleSignIn.currentUser?.displayName}');

        showLog('Google Json : ${user.toString()}');
        showLog('id : ${user?.id}');
        showLog('email : ${user?.email}');
        showLog('displayName : ${user?.displayName}');
        showLog('photoUrl : ${user?.photoUrl}');

        String strUniqueID = user?.id ?? '';
        String strEmail = user?.email ?? '';
        List<String> strFullName = (user?.displayName ?? '').split(' ');
        String strFName = strFullName.first;
        String strLName = strFullName.last;
        String strPhoto = user?.photoUrl ?? '';

        GoogleDataModel googleDataModel = GoogleDataModel(
            token, strUniqueID, strEmail, strFName, strLName, strPhoto);
        googleSignIn.signOut();
        resultCallBack(googleDataModel);
      }).catchError((err) {
        showLog('inner error');
        googleSignIn.signOut();
        failureCallBack(err);
      });

      // return null;
    } else {
      googleSignIn.signOut();
      failureCallBack(null);
    }
  }
}

class GoogleDataModel {
  String token;
  String googleId;
  String email;
  String firstName;
  String lastName;
  String profilePhoto;

  GoogleDataModel(this.token, this.googleId, this.email, this.firstName,
      this.lastName, this.profilePhoto);
}

/*
------------------- Usage of Google Login Manager -------------------
*/

/*
GoogleLoginManager.instance.googleLoginAPI(context, (model) {
//Result Call Back
showLog("Google Data Model - $model");

}, (error) {
//Failure Call Back
showLog("Error - $error");
});
*/

// Example log output (tokens removed for security):
// idToken: null
// displayName: [User Display Name]
// Google Json : GoogleSignInAccount:{displayName: [User Display Name], email: [user@example.com], id: [user_id], photoUrl: [photo_url], serverAuthCode: null}
// id : [user_id]
// email : [user@example.com]
// displayName : [User Display Name]
// photoUrl : [photo_url]
