import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/widgets/common_bg_container.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';
import 'package:vista_flicks/framework/controller/invite_friend/invite_friend_controller.dart';

import '../../../../../core/values/text_styles/base_textstyle.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../gen/assets.gen.dart';

class InitInviteFriendsScreen extends ConsumerStatefulWidget {
  final String groupUrl;

  const InitInviteFriendsScreen({super.key, required this.groupUrl});

  @override
  ConsumerState<InitInviteFriendsScreen> createState() => _InitInviteFriendsScreenState();
}

class _InitInviteFriendsScreenState extends ConsumerState<InitInviteFriendsScreen> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final inviteFriendWatch = ref.read(inviteFriendController);
      await inviteFriendWatch.getGroupDetails(widget.groupUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    final inviteFriendWatch = ref.watch(inviteFriendController);
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: MyRegularText(inviteFriendWatch.groupName),
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.primeryTxt),
        actions: [
          // Padding(
          //   padding: EdgeInsets.only(right: getWidth(16)),
          //   child: SvgPicture.asset(
          //     Assets.icons.tablerIconDotsVertical,
          //     color: AppColors.primeryTxt,
          //   ),
          // ),
        ],
      ),
      body: CommonBgContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SvgPicture.asset(
            //   height: getHeight(48),
            //   width: getWidth(48),
            //   Assets.icons.tablerIconMessages,
            //   color: AppColors.primeryTxt,
            // ),

            Screenshot(
              controller: inviteFriendWatch.screenshotController,
              child: QrImageView(
                data: widget.groupUrl,
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.white,
              ),
            ),
            getVerticalHeight(20),
            Text(
              "You don't have any group members.",
              style: BaseTextStyle.lableL.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            getVerticalHeight(20),
            CustomButton(
              isLoading: inviteFriendWatch.isLoading,
              text: "Invite Friends",
              fun: () async {
                await inviteFriendWatch.shareQRCode(joinLink: widget.groupUrl);
              },
              leftIcon: Assets.icons.tablerIconShare,
            )
          ],
        ),
      ),
    );
  }
}
