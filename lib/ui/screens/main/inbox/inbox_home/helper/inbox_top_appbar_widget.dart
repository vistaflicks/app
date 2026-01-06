import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';
import 'package:vista_flicks/gen/assets.gen.dart';
import 'package:vista_flicks/ui/routing/navigation_stack_item.dart';
import 'package:vista_flicks/ui/routing/stack.dart';

class InboxTopAppbarWidget extends ConsumerWidget {
  const InboxTopAppbarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            ref.read(navigationStackController).push(NavigationStackItem.createGroup());
          },
          child: SvgPicture.asset(
            Assets.icons.tablerIconSquarePlus,
            color: AppColors.primeryTxt,
          ),
        ),
        getHorizonatlWidth(128),
        const MyRegularText("Inbox", style: BaseTextStyle.headerM),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                ref.read(navigationStackController).push(NavigationStackItem.searchGroup());
              },
              child: SvgPicture.asset(
                Assets.icons.tablerIconSearch,
                color: AppColors.primeryTxt,
              ),
            ),
            getHorizonatlWidth(20),
            GestureDetector(
              onTap: () {
                // showWidgetDialog(
                //     context,
                //     JoinGroupDialog(
                //         groupId: '0OMC9ATs9f1ySjoaH0Hp',
                //         onJoinCall: () {},
                //         onCancelCall: () {
                //           Navigator.of(context).pop();
                //         }),
                //     () {});
                ref.read(navigationStackController).push(NavigationStackItem.qrScanner());
              },
              child: SvgPicture.asset(
                Assets.icons.tablerIconQrcode,
                color: AppColors.primeryTxt,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
