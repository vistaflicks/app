import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';
import 'package:vista_flicks/framework/utils/extension/context_extension.dart';

class GroupInfoBottomInviteFrdWidget extends StatelessWidget {
  const GroupInfoBottomInviteFrdWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: context.width,
        color: AppColors.red,
        child: GestureDetector(
          onTap: () {
            Share.share('check out my website https://example.com');
          },
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: getWidth(16), vertical: 20),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: MyRegularText(
                    "Invite Friends ",
                    style: BaseTextStyle.buttonM,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
