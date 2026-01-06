import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vista_flicks/framework/utils/extension/context_extension.dart';

import '../../../framework/provider/network/network.dart';
import '../../../gen/assets.gen.dart';
import '../../routing/delegate.dart';
import '../widgets/common_image.dart';

/// Common Keys
const String development = 'development';
const String production = 'production';
const String appName = 'Vista Reels';
const String hiveSessionBox = 'SessionBox';
const String googleKey = 'Add yours ';

const String accept = 'Accept';
const String headerAccept = 'application/json';
const String contentType = 'contentType';
const String headerContentType = 'application/json';
const String acceptLanguage = 'Accept-Language';

const String defaultCountry = 'US';
const String commonDummyProfileImage =
    'https://www.cgg.gov.in/wp-content/uploads/2017/10/dummy-profile-pic-male1.jpg';

const String staticGroupChatUrl =
    'https://vista_flicks.com/join_group?groupId=';

WidgetRef? globalRef;

bool getIsIOSPlatform() => Platform.isIOS;

bool getIsAppleSignInSupport() => (iosVersion >= 13);
int iosVersion = 11;
int minPasswordLength = 8;
int maxPasswordLength = 16;
int otpLength = 6;
int maxMobileLength = 10;

/// Currency
String currency = '\$';

///Page Size in Pagination
int pageSize = 20;
int pageSizeHundred = 100;
int pageSizeThousand = 1000;

/// Maps Constant
int mapMarkerSize = 75;
double minZoom = globalNavigatorKey.currentContext!.isTablet ? 7.5 : 6.8;
double maxZoom = 25;

/// Get Current Device type
String getDeviceType() => getIsIOSPlatform() ? 'ios' : 'android';

/// Hide Keyboard
hideKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
}

///
String dateFormatFromDateTime(DateTime? dateTime, String format) {
  if (dateTime != null) {
    final DateFormat formatter = DateFormat(format);
    return formatter.format(dateTime);
  } else {
    return '';
  }
}

/// To format date and time fromMillisecondsSinceEpoch to {dd MMM yyyy \'at\' h:mma} as per the docs
String formatDatetime({required int createdAt, String? dateFormat}) {
  final DateFormat format =
      DateFormat(dateFormat ?? 'dd MMM yyyy \'at\' h:mma');
  final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(createdAt);
  final String formattedString = format.format(dateTime);
  return formattedString;
}

/// Printing Statement
showLog(String str) {
  debugPrint('=> $str', wrapWidth: 500);
}

/// Make Phone Call
Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}

/// Encode Query Parameters
String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map(
        (MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
      )
      .join('&');
}

/// Send a Email
Future<void> sendAEmail(String email) async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: email,
    query: encodeQueryParameters(<String, String>{
      // 'subject': 'Example Subject & Symbols are allowed!',
    }),
  );

  launchUrl(emailLaunchUri);
}

/// Common DatePicker
Future<DateTime?> datePicker(BuildContext context,
    {String? selectedDate}) async {
  try {
    DateFormat format = DateFormat('MM-dd-yyyy');
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate != null && selectedDate != ''
          ? format.parse(selectedDate)
          : DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      return pickedDate;
    }
  } catch (e) {
    showLog('Error $e');
  }
  return null;
}

/// Common Image Placeholder Widget
Widget placeHolderWidget({double? height, double? width}) {
  return SizedBox(
    height: height,
    width: width,
    child: CommonImage(
      strIcon: Assets.images.backButtonWhite.path,
      height: height,
      width: width,
    ),
  );
}

/// Show Common Toast Message
commonToaster(String message) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    timeInSecForIosWeb: 4,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

/// get Simple Text From HTMl
getSimpleTextFromHtmlText(String htmlText) {
  var unescape = HtmlUnescape();
  var titleText = unescape.convert(htmlText);
  showLog('titleText $titleText');
  return titleText;
}

/// Convert Uint8List to File
Future<File> uint8ListToFile(Uint8List data, String filePath) async {
  /// Create the File object
  File file = File(filePath);

  /// Write the data to the file
  await file.writeAsBytes(data);

  return file;
}

enum PASSWORD_ENUM { RESET_PASSWORD, CHANGE_PASSWORD }
