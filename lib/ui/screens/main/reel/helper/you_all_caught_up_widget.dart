import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/framework/utils/extension/extension.dart';
import 'package:vista_flicks/framework/utils/local_storage/session.dart';
import 'package:vista_flicks/ui/routing/navigation_stack_item.dart';
import 'package:vista_flicks/ui/routing/stack.dart';
import 'package:vista_flicks/ui/utils/helper/base_widget.dart';
import 'package:vista_flicks/ui/utils/widgets/common_dialogs.dart';

import '../../../../../core/values/app_colours.dart';
import '../../../../../core/values/text_styles/base_textstyle.dart';
import '../../../../../framework/controller/main/account_and_pref/filter/filter_controller.dart';
import '../../../../../framework/provider/network/network.dart';
import '../../../../utils/widgets/common_button.dart';
import '../../../../utils/widgets/common_text.dart';
import '../../account_and_pref/filter/filter_screen.dart';

class YouAllCaughtUpWidget extends ConsumerStatefulWidget {
  const YouAllCaughtUpWidget({super.key});

  @override
  ConsumerState<YouAllCaughtUpWidget> createState() =>
      _YouAllCaughtUpWidgetState();
}

class _YouAllCaughtUpWidgetState extends ConsumerState<YouAllCaughtUpWidget>
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
        CommonText(
            title: "You're All Caught Up ", textStyle: BaseTextStyle.headerL),
        SizedBox(
          height: 10.h,
        ),
        Text(
            textAlign: TextAlign.center,
            "Please select more preference for more interesting content, explore more content or check back later.",
            style: BaseTextStyle.textM),
        SizedBox(
          height: 50.h,
        ),
        CommonButton(
          onTap: () {
            if (Session.userType == "guest") {
              showLoginDialog(
                  context, "For more excusive content, Please Sign in", () {
                ref
                    .read(navigationStackController)
                    .pushAndRemoveAll(NavigationStackItem.splashHome());
              });
              return;
            }
            filterScreenWatch.updateSelectedCategory('Genre', context, ref);
            // filterScreenWatch.getPreferencesAPI(context,
            //     ref: ref, type: FilterType.genre.name);

            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilterScreen(
                    type: "Genre",
                  ),
                ));
          },
          buttonText: "Filter",
          buttonEnabledColor: AppColors.red,
        )
      ],
    ).paddingSymmetric(horizontal: 30.w);
  }
}
