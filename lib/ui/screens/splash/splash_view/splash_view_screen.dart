// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:video_player/video_player.dart'; // Add this
// import 'package:vista_flicks/framework/utils/extension/context_extension.dart';
//
// import '../../../../framework/repository/auth/on_boarding/model/verify_otp_response_model.dart';
// import '../../../../framework/utils/local_storage/session.dart';
// import '../../../../gen/assets.gen.dart';
// import '../../../routing/navigation_stack_item.dart';
// import '../../../routing/stack.dart';
// import '../../../utils/helper/base_widget.dart';
//
// class SplashViewScreen extends ConsumerStatefulWidget {
//   const SplashViewScreen({super.key});
//
//   @override
//   ConsumerState<SplashViewScreen> createState() => _SplashViewScreenState();
// }
//
// class _SplashViewScreenState extends ConsumerState<SplashViewScreen>
//     with BaseConsumerStatefulWidget {
//   late VideoPlayerController _controller;
//
//   @override
//   void initState() {
//     _controller = VideoPlayerController.asset(Assets.background.comp1)
//       ..initialize().then((_) {
//         _controller.play();
//         _controller.setLooping(false); // No loop
//         _controller.setVolume(0); //// Mute
//         setState(() {}); // Refresh
//       });
//
//     SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
//       await Future.delayed(const Duration(seconds: 10), () {
//         // await Future.delayed(const Duration(milliseconds: 2850), () {
//         setNavigationRedirection();
//       });
//     });
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget buildPage(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           _controller.value.isInitialized
//               ? SizedBox(
//                   width: context.width,
//                   height: context.height,
//                   child: FittedBox(
//                     fit: BoxFit.cover,
//                     child: SizedBox(
//                       width: _controller.value.size.width,
//                       height: _controller.value.size.height,
//                       child: VideoPlayer(_controller),
//                     ),
//                   ),
//                 )
//               : const SizedBox(), // Show empty until video initializes
//         ],
//       ),
//     );
//   }
//
//   /// Redirections
//   Future<void> setNavigationRedirection() async {
//     if (Session.userAccessToken == '') {
//       ref.read(navigationStackController).pushAndRemoveAll(
//             const NavigationStackItem.splashHome(),
//           );
//     } else {
//       final userData =
//           VerifyOtpResponseModel.fromJson(jsonDecode(Session.userData))
//               .data
//               ?.user;
//       final bool isAllEmptyList = userData?.ageRating?.isEmpty == true ||
//           userData?.content?.isEmpty == true ||
//           userData?.contentType?.isEmpty == true ||
//           userData?.genre?.isEmpty == true ||
//           userData?.imdbRating?.isEmpty == true ||
//           userData?.language?.isEmpty == true ||
//           userData?.ottPlatforms?.isEmpty == true ||
//           userData?.region?.isEmpty == true ||
//           userData?.subTitleLanguage?.isEmpty == true;
//       print("Session.userData from splash home  ===========> $isAllEmptyList");
//       print("Session.userData blank===========> ${userData?.firstName}");
//       ref.read(navigationStackController).pushAndRemoveAll(
//             const NavigationStackItem.blank(),
//           );
//     }
//   }
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/widgets/common_image_view.dart';
import 'package:vista_flicks/framework/repository/auth/on_boarding/model/verify_otp_response_model.dart';
import 'package:vista_flicks/framework/utils/extension/context_extension.dart';
import 'package:vista_flicks/gen/assets.gen.dart';

import '../../../../framework/utils/local_storage/session.dart';
import '../../../routing/navigation_stack_item.dart';
import '../../../routing/stack.dart';
import '../../../utils/helper/base_widget.dart';

class SplashViewScreen extends ConsumerStatefulWidget {
  const SplashViewScreen({super.key});

  @override
  ConsumerState<SplashViewScreen> createState() => _SplashViewScreenState();
}

class _SplashViewScreenState extends ConsumerState<SplashViewScreen>
    with BaseConsumerStatefulWidget {
  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      if (Session.userType.toLowerCase() == "guest") {
        Session.userType = "";
      }
      await Future.delayed(const Duration(seconds: 5), () {
        setNavigationRedirection();
      });
    });
  }

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.black,
        width: context.width,
        height: context.height,
        // color: Colors.black.withOpacity(0.6),
        child: CommonImageView(
          fit: BoxFit.cover,
          imagePath: Assets.background.splashGIF.path,
        ), // Semi-transparent black overlay
      ),
      // Stack(
      //   children: [
      //     // Lottie.asset(
      //     //   Assets.lottie.bgSlider,
      //     //   fit: BoxFit.cover,
      //     //   height: context.height,
      //     //   width: context.width,
      //     //   repeat: true,
      //     //   reverse: true,
      //     //   filterQuality: FilterQuality.high,
      //     //   frameRate: FrameRate(144),
      //     // ),
      //
      //     // Container(
      //     //   width: context.width,
      //     //   height: context.height,
      //     //   color: Colors.black, // Semi-transparent black overlay
      //     // ),
      //     // Container(
      //     //   width: context.width,
      //     //   height: context.height,
      //     //   decoration: BoxDecoration(
      //     //       gradient: LinearGradient(
      //     //     begin: Alignment.bottomCenter,
      //     //     end: Alignment.topCenter,
      //     //     colors: [
      //     //       AppColors.black.withOpacity(0.5),
      //     //       AppColors.black.withOpacity(0.5),
      //     //       AppColors.black,
      //     //     ],
      //     //   )),
      //     //   // color: Colors.black.withOpacity(0.4), // Semi-transparent black overlay
      //     // ),
      //     Container(
      //       color: AppColors.black,
      //       width: context.width,
      //       height: context.height,
      //       // color: Colors.black.withOpacity(0.6),
      //       child: CommonImageView(
      //         fit: BoxFit.cover,
      //         imagePath: Assets.background.mobileRender.path,
      //       ), // Semi-transparent black overlay
      //     ),
      //     // Center(
      //     //   child: CommonImageView(
      //     //     height: 144.h,
      //     //     imagePath: Assets.images.vistaFlicksSplashLogo.path,
      //     //   ),
      //     // ),
      //   ],
      // ),
    );
  }

  /// Redirections
  Future<void> setNavigationRedirection() async {
    // ref
    //     .read(navigationStackController)
    //     .pushAndRemoveAll(const NavigationStackItem.splashHome());

    if (Session.userAccessToken == '') {
      ref.read(navigationStackController).pushAndRemoveAll(
            const NavigationStackItem.splashHome(),
          );
    } else {
      // ref
      //     .read(navigationStackController)
      //     .push(NavigationStackItemInitialWatchPreferencesScreen());
      final userData =
          VerifyOtpResponseModel.fromJson(jsonDecode(Session.userData))
              .data
              ?.user;
      final bool isAllEmptyList = userData?.ageRating?.isEmpty == true &&
          userData?.content?.isEmpty == true &&
          userData?.contentType?.isEmpty == true &&
          userData?.genre?.isEmpty == true &&
          userData?.imdbRating?.isEmpty == true &&
          userData?.language?.isEmpty == true &&
          userData?.ottPlatforms?.isEmpty == true &&
          userData?.region?.isEmpty == true &&
          userData?.subTitleLanguage?.isEmpty == true;
      print("Session.userData from splash home  ===========> $isAllEmptyList");
      print("Session.userData blank===========> ${userData?.firstName}");

      if (!isAllEmptyList) {
        ref.read(navigationStackController).pushAndRemoveAll(
              const NavigationStackItem.blank(),
            );
      } else {
        ref.read(navigationStackController).pushAndRemoveAll(
            NavigationStackItemInitialWatchPreferencesScreen());
      }
    }
    // if (isAllEmptyList) {
    //   ref.read(navigationStackController).pushAndRemoveAll(
    //         const NavigationStackItem.splashHome(),
    //       );
    // }
  }
}
//
// // class SplashScreen extends GetView<SplashViewController> {
// //   const SplashScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     controller.onInit();
// //     return Scaffold(
// //       body: Stack(
// //         children: [
// //           Lottie.asset(
// //             Assets.lottie.bgSlider,
// //             fit: BoxFit.cover,
// //             height: Get.height,
// //             width: Get.width,
// //             repeat: true,
// //             reverse: true,
// //             filterQuality: FilterQuality.high,
// //             frameRate: FrameRate(144),
// //           ),
// //           Container(
// //             width: Get.width,
// //             height: Get.height,
// //             color:
// //                 Colors.black.withOpacity(0.6), // Semi-transparent black overlay
// //           ),
// //           Container(
// //             width: Get.width,
// //             height: Get.height,
// //             decoration: BoxDecoration(
// //                 gradient: LinearGradient(
// //               begin: Alignment.bottomCenter,
// //               end: Alignment.topCenter,
// //               colors: [
// //                 AppColors.black.withOpacity(0.5),
// //                 AppColors.black.withOpacity(0.5),
// //                 AppColors.black,
// //               ],
// //             )),
// //             // color: Colors.black.withOpacity(0.4), // Semi-transparent black overlay
// //           ),
// //           Center(
// //             child: CommonImageView(
// //               height: getHeight(144),
// //               imagePath: Assets.images.vistaFlicksSplashLogo.path,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   /// Redirections
// //   Future<void> setNavigationRedirection() async {
// //     if (Session.userAccessToken == '') {
// //       ref.read(navigationStackController).pushAndRemoveAll(
// //             const NavigationStackItem.signIn(),
// //           );
// //     } else if (!Session.onboardingStatus) {
// //       ref.read(navigationStackController).pushAndRemoveAll(
// //             const NavigationStackItem.onboarding(),
// //           );
// //     } else {
// //       ref.read(navigationStackController).pushAndRemoveAll(
// //             const NavigationStackItem.mainScreen(),
// //           );
// //     }
// //   }
// // }
