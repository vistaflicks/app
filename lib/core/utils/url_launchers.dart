import 'package:url_launcher/url_launcher.dart';

class UrlLaunchers {
  static makeCall({required String phoneNumber}) {
    launchUrl(Uri.parse("tel://$phoneNumber"));
  }

  static openLink({required String link}) {
    launchUrl(Uri.parse(link));
  }
}
