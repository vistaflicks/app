import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vista_flicks/core/utils/url_launchers.dart';

import '../../../../../framework/controller/splash/splash_home/splash_home_view_controller.dart';

class TermsAndConditionTxtWidget extends ConsumerWidget {
  const TermsAndConditionTxtWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final termsAndConditionTxtWidgetWatch = ref.watch(splashHomeController);
    return Opacity(
      opacity: 0.6,
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
                text: "By continuing, you agree to our ",
                style: GoogleFonts.poppins(
                    fontSize: 12, fontWeight: FontWeight.w400)
                // style: BaseTextStyle.textXs.copyWith(fontFamily: "poppins"),
                ),
            TextSpan(
                text: "Terms & Conditions ",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                )
                // style: BaseTextStyle.textXs.copyWith(
                //     decoration: TextDecoration.underline,
                //     fontFamily: "poppins"),
                ,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    UrlLaunchers.openLink(
                        link: "https://policies.google.com/terms?hl=en-US");
                  }),
            TextSpan(
              text: "and acknowledge that you have read our ",
              // style: BaseTextStyle.textXs.copyWith(fontFamily: "poppins"),
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
                text: "Privacy Policy",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                ),
                // style: BaseTextStyle.textXs.copyWith(
                //     decoration: TextDecoration.underline,
                //     fontFamily: "poppins"),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    UrlLaunchers.openLink(
                        link: "https://policies.google.com/privacy");
                  }),
          ])),
    );
  }
}
