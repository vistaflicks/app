// import 'package:flutter/material.dart';
// import 'package:vista_flicks/gen/assets.gen.dart';

// class PosterOverlay extends StatefulWidget {
//   const PosterOverlay({Key? key}) : super(key: key);

//   @override
//   State<PosterOverlay> createState() => _PosterOverlayState();
// }

// class _PosterOverlayState extends State<PosterOverlay>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _animation;

//   @override
//   void initState() {
//     super.initState();

//     // Initialize AnimationController
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 10),
//     )..repeat(); // Infinite diagonal animation

//     // Define diagonal animation
//     _animation = Tween<Offset>(
//       begin: const Offset(-0.5, -0.5), // Start point (-50%, -50%)
//       end: const Offset(0.0, 0.0), // End point (0%, 0%)
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.linear,
//     ));
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Poster container (moving background)
//           Positioned.fill(
//             child: AnimatedBuilder(
//               animation: _controller,
//               builder: (context, child) {
//                 return FractionalTranslation(
//                   translation: _animation.value,
//                   child: child,
//                 );
//               },
//               child: Container(
//                 width: MediaQuery.of(context).size.width * 9, // 200% width
//                 height: MediaQuery.of(context).size.height * 9, // 200% height
//                 child: GridView.builder(
//                   physics: const NeverScrollableScrollPhysics(),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3, // Split into 50% width and height
//                   ),
//                   itemBuilder: (context, index) {
//                     return Image.asset(
//                       width:
//                           MediaQuery.of(context).size.width * 2, // 200% width
//                       height:
//                           MediaQuery.of(context).size.height * 2, // 200% height
//                       Assets.background.frame1.path, // Replace with your image
//                       fit: BoxFit.cover,
//                     );
//                   },
//                   itemCount: 4, // Fill the grid with 2x2 images
//                 ),
//               ),
//             ),
//           ),

//           // Overlay with opacity
//           Positioned.fill(
//             child: Container(
//               color: Colors.black.withOpacity(0.6), // Overlay color
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/widgets/common_image_view.dart';
import 'package:vista_flicks/framework/utils/extension/context_extension.dart';
import 'package:vista_flicks/gen/assets.gen.dart';
import 'package:vista_flicks/ui/utils/helper/base_widget.dart';

import '../../../../framework/controller/splash/splash_home/splash_home_view_controller.dart';
import 'helper/login_with_button_widget.dart';
import 'helper/social_button_widget.dart';
import 'helper/terms_and_condition_txt_widget.dart';
import 'helper/welcome_txt_widget.dart';

class SplashHomeScreen extends ConsumerStatefulWidget {
  const SplashHomeScreen({super.key});

  @override
  ConsumerState<SplashHomeScreen> createState() => _SplashHomeScreenState();
}

class _SplashHomeScreenState extends ConsumerState<SplashHomeScreen>
    with BaseConsumerStatefulWidget {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final splashHomeScreenWatch = ref.watch(splashHomeController);
      splashHomeScreenWatch.disposeController(isNotify: true);
    });
  }

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Lottie.asset(
          //   Assets.lottie.bgSlider,
          //   fit: BoxFit.cover,
          //   height: context.height,
          //   width: context.width,
          //   repeat: true,
          //   reverse: true,
          //   filterQuality: FilterQuality.high,
          //   frameRate: FrameRate(144),
          // ),
          Container(
            width: context.width,
            height: context.height,
            color: AppColors.black11.withOpacity(0.7),
          ),
          Opacity(
            opacity: 0.6,
            child: Container(
              width: context.width,
              height: context.height,
              color: AppColors.black11.withOpacity(0.7),
              child: CommonImageView(
                imagePath: Assets.images.gradientbg.path,
              ),
            ),
          ),
          SizedBox(
            width: context.width,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  getVerticalHeight(120.h),
                  const WelcomeTxtWidget(),
                  getVerticalHeight(120.h),
                  const LoginWithButtonWidget(),
                  getVerticalHeight(15.h),
                  const SocialButtonsWidget(),
                  getVerticalHeight(15.h),
                  const TermsAndConditionTxtWidget(),
                  getVerticalHeight(15.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
