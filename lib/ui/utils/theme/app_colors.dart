import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static bool isDarkMode = false;

  static const Color primary = Color(0xFF0655A0);
  static const Color secondaryPrimary = Color(0xFF0C96D7);
  static const Color clrFade = Color(0xFF84AED7);
  static const Color clr0E8DD5 = Color(0xFF0E8DD5);
  static const Color white = Color(0xffFFFFFF);
  static const Color clrFCFCFC = Color(0xffFCFCFC);
  static const Color grey = Color(0xff697176);
  static const Color greyDark = Color(0xff5E5E5E);
  static const Color greyLight = Color(0xffECECEC);
  static const Color clr9A9FA5 = Color(0xff9A9FA5);
  static const Color greyMedium = Color(0xffC0C0C0);
  static const Color clrF9F9F9 = Color(0xffF9F9F9);
  static const Color clr003C75 = Color(0xff003C75);
  static const Color clrF7F7F7 = Color(0xffF7F7F7);
  static const Color blackLight = Color(0x33000000);
  static const Color black = Color(0xff1A1B2D);
  static const Color clrFAFAFA = Color(0xffFAFAFA);
  static const Color clr535763 = Color(0xff535763);
  static const Color clrEFEFEF = Color(0xffEFEFEF);
  static const Color darkNavyBlue = Color(0xff111428);
  static const Color redDark = Color(0xffff0000);
  static const Color redLight = Color(0xfff82323);
  static const Color skyBlue = Color(0xff46A7EA);
  static const Color blue = Color(0xff009AF1);
  static const Color green = Color(0xff2B9200);
  static const Color greenLight = Color(0xff58BF56);
  static const Color clrD1D3D4 = Color(0xffD1D3D4);
  static const Color clr666C89 = Color(0xff666C89);
  static const Color clr6F767E = Color(0xff6F767E);
  static const Color clrFFD88D = Color(0xffFFD88D);
  static const Color clrCABDFF = Color(0xffCABDFF);
  static const Color clrB1E5FC = Color(0xffB1E5FC);
  static const Color clrAFC6FF = Color(0xffAFC6FF);
  static const Color clrF8B0ED = Color(0xffF8B0ED);
  static const Color clr252843 = Color(0xfff252843);
  static const Color clrCBEBA4 = Color(0xffCBEBA4);
  static const Color clrB5EBCD = Color(0xffB5EBCD);
  static const Color clrFB9B9B = Color(0xffFB9B9B);
  static const Color clrFFBC99 = Color(0xffFFBC99);
  static const Color clr41405D = Color(0xff41405D);
  static const Color clr9B9E9F = Color(0xff9B9E9F);
  static const Color clrF2F2F2 = Color(0xffF2F2F2);
  static const Color clrFBFBFB = Color(0xffFBFBFB);
  static const Color clr3465A4 = Color(0xff3465A4);
  static const Color clrB0B0B0 = Color(0xffB0B0B0);
  static const Color purple = Color(0xff6E38D4);
  static const Color clr636A75 = Color(0xff636A75);
  static const Color clr172B4D = Color(0xff172B4D);
  static const Color transparent = Color(0x00000000);
  static const Color textFieldLabelColor = Color(0xFF7E7E7E);
  static const Color clrGreyE8 = Color(0xFFE8E8E8);
  static const Color textPrimary = Color(0xff000000);
  static const Color errorColor = Color(0xffFF5757);
  static const Color orange = Color(0xffF09537);
  static const Color yellowDark = Color(0xffE9A906);
  static const Color yellowLight = Color(0xffFBFC53);
  static const Color clrF9EC99 = Color(0xffF9EC99);
  static const Color clrA19547 = Color(0xffA19547);
  static const Color clrF5F5F5 = Color(0xffF5F5F5);
  static const Color clrC4C4C4 = Color(0xffC4C4C4);
  static const Color marron = Color(0xffBC4035);
  static const Color clr1A1D1F = Color(0xff1A1D1F);
  static const Color clr797979 = Color(0xff797979);
  static const Color clr6C757D = Color(0xff6C757D);

  /// App Colors
  static const Color fontBlack = Color(0xff303030);

  /// Shimmer
  static final baseColor = Colors.grey.shade300;
  static final highlightColor = Colors.grey.shade100;

  /// Color Swatches
  static MaterialColor colorPrimary = MaterialColor(0xFF0655A0, colorSwathes);

  static Map<int, Color> colorSwathes = {
    50: const Color.fromRGBO(6, 85, 160, .1),
    100: const Color.fromRGBO(6, 85, 160, .2),
    200: const Color.fromRGBO(6, 85, 160, .3),
    300: const Color.fromRGBO(6, 85, 160, .4),
    400: const Color.fromRGBO(6, 85, 160, .5),
    500: const Color.fromRGBO(6, 85, 160, .6),
    600: const Color.fromRGBO(6, 85, 160, .7),
    700: const Color.fromRGBO(6, 85, 160, .8),
    800: const Color.fromRGBO(6, 85, 160, .9),
    900: const Color.fromRGBO(6, 85, 160, .1),
  };

  /// Theme Colors
  static Color textByTheme() => isDarkMode ? white : primary;

  static Color textMainFontByTheme() => isDarkMode ? white : textPrimary;

  static Color scaffoldBGByTheme() => isDarkMode ? black : clrF9F9F9;

  static Color textWhiteByNewBlack2() => isDarkMode ? white : black;
}
