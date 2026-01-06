import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vista_flicks/framework/controller/blank/blank_controller.dart';
import 'package:vista_flicks/framework/controller/main/reel/reels_controller.dart';

import '../../../../../core/values/app_colours.dart';
import '../../../../../core/values/size_constant.dart';
import '../../../../../core/values/strings.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../framework/controller/splash/splash_home/splash_home_view_controller.dart';
import '../../../../../framework/utils/local_storage/session.dart';
import '../../../../routing/navigation_stack_item.dart';
import '../../../../routing/stack.dart';

class LoginWithButtonWidget extends ConsumerWidget {
  const LoginWithButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginWithButtonWidgetWatch = ref.watch(splashHomeController);
    final reelsWatch = ref.watch(reelsController);
    return Column(
      children: [
        CustomButton(
          text: AppStrings.continueWithPhone,
          fun: () {
            Session.userType = "";
            // reelsWatch.getReels(context, ref: ref);
            ref
                .read(navigationStackController)
                .push(const NavigationStackItem.onboarding(isEmail: false));
            // Get.toNamed(Routes.ONBORDING, arguments: false);
          },
        ),
        getVerticalHeight(15),
        CustomButton(
          isDisabled: true,
          color: AppColors.black11.withOpacity(0.6),
          text: AppStrings.continueWithEmail,
          fun: () {
            Session.userType = "";
            ref
                .read(navigationStackController)
                .push(const NavigationStackItem.onboarding(isEmail: true));
            // Get.toNamed(Routes.ONBORDING, arguments: true);
          },
        ),
        getVerticalHeight(15),
        CustomButton(
          text: AppStrings.continueAsGuest,
          color: AppColors.black11.withOpacity(0.6),
          fun: () {
            Session.userType = "guest";
            reelsWatch.currentIndex = 0;
            // ref.read(blankController).setIndex(0);
            reelsWatch.reelsListState.isLoading = false;
            reelsWatch.getReels(context, ref: ref);
            final blankWatch =
                ref.watch(blankController); // Get provider instance
            blankWatch.setIndex(0, ref: ref, context: context);
            ref
                .read(navigationStackController)
                .push(const NavigationStackItem.blank());
          },
        ),
      ],
    );
  }
}
