import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:vista_flicks/framework/utils/extension/context_extension.dart';
import 'package:vista_flicks/framework/utils/extension/string_extension.dart';

import '../../../framework/provider/network/network.dart';
import '../../../framework/utils/local_storage/session.dart';
import '../../routing/navigation_stack_item.dart';
import '../../routing/stack.dart';
import '../../utils/const/app_enums.dart';
import '../../utils/theme/app_colors.dart';
import '../../utils/theme/app_strings.g.dart';
import '../../utils/theme/assets.gen.dart';
import '../../utils/widgets/common_button.dart';

class ErrorWeb extends ConsumerStatefulWidget {
  final ErrorType? errorType;

  const ErrorWeb({Key? key, this.errorType}) : super(key: key);

  @override
  ConsumerState<ErrorWeb> createState() => _ErrorWebState();
}

class _ErrorWebState extends ConsumerState<ErrorWeb> {
  String errorAsset = '';
  String buttonText = '';

  @override
  void initState() {
    super.initState();
    switch (widget.errorType) {
      case null:
        break;
      case ErrorType.error403:
        errorAsset = Assets.anim.animError403.keyName;
        buttonText = 'LocaleKeys.keyBackToLogin.localized';
        break;
      case ErrorType.error404:
        if (Session.userAccessToken.isNotEmpty) {
          errorAsset = Assets.anim.animError404.keyName;
          buttonText = 'LocaleKeys.keyBackToHome.localized';
        } else {
          errorAsset = Assets.anim.animError403.keyName;
          buttonText = 'LocaleKeys.keyBackToLogin.localized';
        }
        break;
      case ErrorType.noInternet:
        errorAsset = Assets.anim.animError404.keyName;
        buttonText = LocaleKeys.keyRefresh.localized;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            right: 0,
            child: Lottie.asset(errorAsset, fit: BoxFit.cover),
          ),
          Positioned(
            bottom: 10.h,
            child: CommonButton(
              width: context.width * 0.15,
              buttonEnabledColor: AppColors.white.withOpacity(0.18),
              isButtonEnabled: true,
              height: context.height * 0.08,
              buttonText: buttonText,
              onTap: () {
                switch (widget.errorType) {
                  case null:
                  case ErrorType.error403:
                    ref
                        .read(navigationStackController)
                        .pushAndRemoveAll(const NavigationStackItem.splash());
                  case ErrorType.error404:
                    if (Session.userAccessToken.isNotEmpty) {
                      /// Uncomment all while implement design
                      // ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.home());
                    } else {
                      ref
                          .read(navigationStackController)
                          .pushAndRemoveAll(const NavigationStackItem.splash());
                    }
                  case ErrorType.noInternet:
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
