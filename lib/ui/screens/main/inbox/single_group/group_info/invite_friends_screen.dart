import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/core/widgets/common_bg_container.dart';
import 'package:vista_flicks/core/widgets/custom_button.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';
import 'package:vista_flicks/framework/controller/invite_friend/invite_friend_controller.dart';
import 'package:vista_flicks/framework/repository/chat/model/group_details_response_model.dart';
import 'package:vista_flicks/framework/utils/extension/extension.dart';
import 'package:vista_flicks/ui/utils/const/app_constants.dart';
import 'package:vista_flicks/ui/utils/helper/base_widget.dart';

import '../../../../../../core/values/app_colours.dart';
import '../../../../../../core/values/size_constant.dart';
import '../../../../../../gen/assets.gen.dart';

class InviteFriendsScreen extends ConsumerWidget with BaseConsumerWidget {
  final String groupId;
  final GroupDetailsResponseModel? groupDetailsResponseModel;

  const InviteFriendsScreen(
      {super.key, required this.groupId, this.groupDetailsResponseModel});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    // final inviteFriendsScreenWatch = ref.watch(singleGroupController);
    final inviteFriendWatch = ref.watch(inviteFriendController);
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.black.withOpacity(.0),
        foregroundColor: AppColors.primeryTxt,
        centerTitle: true,
        title: MyRegularText(
          "Invite Friends to ${groupDetailsResponseModel?.groupName}",
          style: BaseTextStyle.headerM,
        ),
      ),
      body: CommonBgContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 60.w,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: List.generate(
                      groupDetailsResponseModel?.members?.length ?? 0,
                      (i) {
                        return SizedBox(
                          height: getHeight(25.h),
                          width: getWidth(25.w),
                          child: CircleAvatar(
                            radius: 15.r,
                            backgroundImage: NetworkImage(
                              groupDetailsResponseModel
                                      ?.members?[i].userImage ??
                                  '',
                            ),
                            // backgroundColor: Colors.grey[800],
                          ),
                        );
                      },
                    ),
                  ),
                ).alignAtCenter(),
                getVerticalHeight(10.h),
                MyRegularText(
                  groupDetailsResponseModel?.groupName ?? '',
                  style: BaseTextStyle.headerMl,
                ).alignAtCenter(),
              ],
            ),
            getVerticalHeight(30.h),
            // CommonImageView(
            //   imagePath: Assets.images.qrCode.path,
            // ),
            Screenshot(
              controller: inviteFriendWatch.screenshotController,
              child: QrImageView(
                data:
                    '$staticGroupChatUrl${groupDetailsResponseModel?.groupId}',
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.white,
              ),
            ),
            getVerticalHeight(30.h),
            SizedBox(
              width: getWidth(300.w),
              child: Text(
                "Your QR Code is private.If you share it with someone, they can scan it with their Vista Reels Camera to add join the group.",
                style: BaseTextStyle.lableM,
                textAlign: TextAlign.center,
              ),
            ),
            getVerticalHeight(30.h),
            CustomButton(
              isLoading: inviteFriendWatch.isLoading,
              text: "Share",
              fun: () async {
                await inviteFriendWatch.shareQRCode(
                    joinLink:
                        '$staticGroupChatUrl${groupDetailsResponseModel?.groupId}');
              },
              leftIcon: Assets.icons.tablerIconShare,
            )
          ],
        ),
      ),
    );
  }
}
