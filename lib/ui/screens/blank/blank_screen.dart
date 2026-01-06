import 'dart:io';
import 'dart:ui';

import 'package:double_tap_to_exit/double_tap_to_exit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/framework/controller/auth/on_boarding/on_boarding_controller.dart';
import 'package:vista_flicks/framework/controller/blank/blank_controller.dart';
import 'package:vista_flicks/framework/controller/main/reel/reels_controller.dart';
import 'package:vista_flicks/framework/utils/local_storage/session.dart';
import 'package:vista_flicks/ui/utils/helper/location_helper/location_helper.dart';

import '../../../core/values/size_constant.dart';
import '../../../gen/assets.gen.dart';
import '../../utils/helper/base_widget.dart';

class BlankScreen extends ConsumerStatefulWidget {
  const BlankScreen({super.key});

  @override
  ConsumerState<BlankScreen> createState() => _BlankScreenState();
}

class _BlankScreenState extends ConsumerState<BlankScreen>
    with BaseConsumerStatefulWidget {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final blankWatch = ref.watch(blankController); // Get provider instance
      blankWatch.setIndex(0, ref: ref, context: context);
      await LocationHandler.getCurrentPosition();
      final reelScreenWatch = ref.watch(reelsController);
      final onBoardingWatch = ref.watch(onBoardingController);
      if (Session.userType.toLowerCase() != "guest") {
        onBoardingWatch.startLocationUpdates(context, ref);
        reelScreenWatch.disposeController(isNotify: true);
        reelScreenWatch.reelsListState.isLoading = false;
        await reelScreenWatch.getReels(context, ref: ref);
        reelScreenWatch.startWatchTimer(0);
      }
    });

    super.initState();
  }

  @override
  Widget buildPage(BuildContext context) {
    final blankWatch = ref.watch(blankController); // Get provider instance

    return DoubleTapToExit(
      snackBar: SnackBar(
          content: Text(
        'Double tap to exit!',
      )),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // body: blankWatch.pages[blankWatch.currentIndex],
        backgroundColor: AppColors.black,
        body: SafeArea(
          top: Platform.isAndroid,
          child: Stack(
            children: [
              blankWatch.pages[blankWatch.currentIndex], // Main content

              /// Bottom Navigation Bar with Blur
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: 10.0, sigmaY: 10.0), // Blur effect
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.black.withOpacity(0.5),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: tabItem(Assets.icons.tablerIconHome, false,
                                  blankWatch.currentIndex == 0, 0, ref)),
                          Expanded(
                              child: tabItem(Assets.icons.tablerIconSearch,
                                  false, blankWatch.currentIndex == 1, 1, ref)),
                          Expanded(
                              child: tabItem(Assets.icons.tablerIconMessage2,
                                  false, blankWatch.currentIndex == 2, 2, ref)),
                          Expanded(
                              child: tabItem(Assets.icons.tablerIconBookmark,
                                  false, blankWatch.currentIndex == 3, 3, ref)),
                          Expanded(
                              child: tabItem(Assets.icons.tablerIconUserCircle,
                                  false, blankWatch.currentIndex == 4, 4, ref)),
                          Expanded(
                            child: tabItem(
                              Assets.lottie.animation1737368859751,
                              true,
                              blankWatch.currentIndex == 5,
                              5,
                              ref,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // PersistentTabView(
  // avoidBottomPadding: true,
  // navBarHeight: 80,
  // backgroundColor: AppColors.red.withOpacity(0.3),
  // // selectedIndex: blankWatch.currentIndex,
  // onTabChanged: (index) {
  // blankWatch.setIndex(index); // Update index using Riverpod
  // },
  // tabs: List.generate(
  // blankWatch.pages.length,
  // (index) => _buildTabItem(index, ref),
  // ),
  // navBarBuilder: (navBarConfig) => Style11BottomNavBar(
  // itemAnimationProperties: const ItemAnimation(
  // curve: Curves.linear,
  // duration: Duration(milliseconds: 500),
  // ),
  // navBarDecoration: NavBarDecoration(
  // padding: const EdgeInsets.all(0),
  // color: AppColors.black.withOpacity(0.6),
  // ),
  // navBarConfig: navBarConfig,
  // ),
  // )

  Widget tabItem(
      String asset, bool isLottie, bool isSelected, int index, WidgetRef ref) {
    final blankWatch = ref.watch(blankController);
    return InkWell(
      onTap: () {
        blankWatch.setIndex(index,
            context: context, ref: ref); // Update index using Riverpod
        if (index != 0) {
          final reelScreenWatch = ref.watch(reelsController);
          reelScreenWatch.sendWatchDuration(
              reelScreenWatch.previousReelIndex ?? 0, context);
        }
      },
      child: Center(
        child: isLottie
            ? Lottie.asset(
                height: getHeight(28),
                width: getWidth(28),
                Assets.lottie.animation1737368859751,
              )
            : SvgPicture.asset(
                asset,
                colorFilter: ColorFilter.mode(
                  isSelected ? AppColors.red : AppColors.primeryTxt,
                  BlendMode.srcIn,
                ),
              ),
      ),
    );
  }

  PersistentTabConfig _buildTabItem(int index, WidgetRef ref) {
    final blankWatch = ref.watch(blankController);
    bool isLottie = index == 5;

    return PersistentTabConfig(
      screen: blankWatch.pages[index],
      item: ItemConfig(
        activeForegroundColor: blankWatch.currentIndex == index
            ? AppColors.red
            : AppColors.primeryTxt,
        inactiveBackgroundColor: AppColors.primeryTxt,
        icon: isLottie
            ? Lottie.asset(
                height: getHeight(28),
                width: getWidth(28),
                Assets.lottie.animation1737368859751,
              )
            : SvgPicture.asset(
                blankWatch.iconAssets[index],
                colorFilter: ColorFilter.mode(
                  blankWatch.currentIndex == index
                      ? AppColors.red
                      : AppColors.primeryTxt,
                  BlendMode.srcIn,
                ),
              ),
      ),
    );
  }
}
