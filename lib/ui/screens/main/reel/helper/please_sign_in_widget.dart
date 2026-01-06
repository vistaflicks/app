import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/framework/utils/extension/extension.dart';
import 'package:vista_flicks/ui/routing/navigation_stack_item.dart';
import 'package:vista_flicks/ui/routing/stack.dart';
import 'package:vista_flicks/ui/utils/helper/base_widget.dart';

import '../../../../../core/values/app_colours.dart';
import '../../../../../core/values/text_styles/base_textstyle.dart';
import '../../../../../framework/controller/main/account_and_pref/filter/filter_controller.dart';
import '../../../../../framework/provider/network/network.dart';
import '../../../../utils/widgets/common_button.dart';
import '../../../../utils/widgets/common_text.dart';

class PleaseSignInWidget extends ConsumerStatefulWidget {
  const PleaseSignInWidget({super.key});

  @override
  ConsumerState<PleaseSignInWidget> createState() =>
      _YouAllCaughtUpWidgetState();
}

class _YouAllCaughtUpWidgetState extends ConsumerState<PleaseSignInWidget>
    with BaseConsumerStatefulWidget {
  @override
  Widget buildPage(BuildContext context) {
    final filterScreenWatch = ref.watch(filterController);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          size: 70.h,
          Icons.check_circle_outline_rounded,
          color: AppColors.green,
        ),
        SizedBox(
          height: 20.h,
        ),
        CommonText(title: "Please Login ", textStyle: BaseTextStyle.headerL),
        SizedBox(
          height: 10.h,
        ),
        Text(
            textAlign: TextAlign.center,
            "Please login to continue watching more reels.",
            style: BaseTextStyle.textM),
        SizedBox(
          height: 50.h,
        ),
        CommonButton(
          onTap: () {
            ref
                .read(navigationStackController)
                .pushAndRemoveAll(NavigationStackItem.splashHome());
          },
          buttonText: "Login",
          buttonEnabledColor: AppColors.red,
        )
      ],
    ).paddingSymmetric(horizontal: 30.w);
  }
}
