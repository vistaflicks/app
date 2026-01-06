import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/framework/controller/auth/on_boarding/on_boarding_controller.dart';
import 'package:vista_flicks/framework/controller/main/reel/reels_controller.dart';
import 'package:vista_flicks/ui/screens/splash/splash_home/helper/social_login_button_widget.dart';

import '../../../../../framework/controller/splash/splash_home/splash_home_view_controller.dart';
import '../../../../../framework/utils/local_storage/session.dart';
import '../../../../../gen/assets.gen.dart';

class SocialButtonsWidget extends ConsumerWidget {
  const SocialButtonsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final socialButtonsWidgetWatch = ref.watch(splashHomeController);
    final reelsWatch = ref.watch(reelsController);
    final onBoardingWatch = ref.watch(onBoardingController);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (Platform.isIOS == true)
          SocialLoginButtonWidget(
            isLoading: socialButtonsWidgetWatch.isLoading &&
                socialButtonsWidgetWatch.type == 1,
            onTap: () {
              Session.userType = "";
              socialButtonsWidgetWatch.loginWithApple(context, ref);
            },
            assets: Assets.icons.fi747,
          ),
        if (Platform.isIOS == true) getHorizonatlWidth(10.w),
        SocialLoginButtonWidget(
          isLoading: socialButtonsWidgetWatch.isLoading &&
              socialButtonsWidgetWatch.type == 2,
          onTap: () {
            Session.userType = "";
            socialButtonsWidgetWatch.loginWithGoogle(context, ref);
          },
          assets: Assets.icons.fi281764,
        ),
        getHorizonatlWidth(10.w),
        // SocialLoginButtonWidget(
        //   isLoading: socialButtonsWidgetWatch.isLoading &&
        //       socialButtonsWidgetWatch.type == 3,
        //   onTap: () {
        //     socialButtonsWidgetWatch.loginWithFacebook(context, ref);
        //   },
        //   assets: Assets.icons.fi5968764,
        // ),
      ],
    );
  }
}
