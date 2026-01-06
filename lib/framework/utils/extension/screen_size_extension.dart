// import 'dart:math';
// import 'package:country_kart/framework/utils/extension/context_extension.dart';
// import 'package:country_kart/framework/utils/local_storage/session.dart';
// import 'package:country_kart/ui/utils/const/global_context_manager.dart';
// import 'package:country_kart/ui/utils/theme/theme.dart';
//
// class CustomScreenSize {
//   CustomScreenSize._();
//
//   late BuildContext context;
//   static CustomScreenSize instance = CustomScreenSize._();
//
//   void init({required Size designSize}) {
//     context = getContext();
//     Session.designSize = designSize;
//   }
// }
//
// extension ScreenSizeExtension on double {
//   double get hp {
//     return (CustomScreenSize.instance.context.height * this) / (Session.designSize.height);
//   }
//
//   double get wp {
//     return (CustomScreenSize.instance.context.width * this) / (Session.designSize.width);
//   }
//
//   double get fp {
//     var scaleWidth = CustomScreenSize.instance.context.width / (Session.designSize.width);
//     var scaleHeight = CustomScreenSize.instance.context.height / (Session.designSize.height);
//     return (this * min(scaleWidth, scaleHeight));
//   }
//
//   double get rp {
//     var scaleWidth = CustomScreenSize.instance.context.width / (Session.designSize.width);
//     var scaleHeight = CustomScreenSize.instance.context.height / (Session.designSize.height);
//     return (this * min(scaleWidth, scaleHeight));
//   }
// }
//
// extension ScreenSizeIntExtension on int {
//   double get hp {
//     return (CustomScreenSize.instance.context.height * this) / (Session.designSize.height);
//   }
//
//   double get wp {
//     return (CustomScreenSize.instance.context.width * this) / (Session.designSize.width);
//   }
//
//   double get fp {
//     var scaleWidth = CustomScreenSize.instance.context.width / (Session.designSize.width);
//     var scaleHeight = CustomScreenSize.instance.context.height / (Session.designSize.height);
//     return (this * min(scaleWidth, scaleHeight));
//   }
//
//   double get rp {
//     var scaleWidth = CustomScreenSize.instance.context.width / (Session.designSize.width);
//     var scaleHeight = CustomScreenSize.instance.context.height / (Session.designSize.height);
//     return (this * min(scaleWidth, scaleHeight));
//   }
// }
