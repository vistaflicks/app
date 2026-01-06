import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/core/widgets/common_bg_container.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';
import 'package:vista_flicks/framework/controller/invite_friend/invite_friend_controller.dart';
import 'package:vista_flicks/framework/repository/chat/model/group_details_response_model.dart';
import 'package:vista_flicks/framework/utils/extension/context_extension.dart';
import 'package:vista_flicks/framework/utils/local_storage/session.dart';
import 'package:vista_flicks/ui/routing/navigation_stack_item.dart';
import 'package:vista_flicks/ui/routing/stack.dart';
import 'package:vista_flicks/ui/utils/const/app_constants.dart';
import 'package:vista_flicks/ui/utils/helper/group_chat_manager/group_chat_manager.dart';
import 'package:vista_flicks/ui/utils/widgets/common_dialogs.dart';
import 'package:vista_flicks/ui/utils/widgets/dialog_progressbar.dart';

import '../../../../../../core/values/app_colours.dart';
import '../../../../../../core/values/size_constant.dart';
import '../../../../../../framework/controller/main/inbox/single_group/single_group_controller.dart';
import '../../../../../../gen/assets.gen.dart';

class GroupInfoScreen extends ConsumerWidget {
  final GroupDetailsResponseModel? groupDetailsResponseModel;

  const GroupInfoScreen({super.key, required this.groupDetailsResponseModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupInfoScreenWatch = ref.watch(singleGroupController);
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.black.withOpacity(.0),
        foregroundColor: AppColors.primeryTxt,
        centerTitle: true,
        actions: [
          Row(
            children: [
              (groupInfoScreenWatch.getGroupDetailsResponseModel?.adminIds
                          ?.contains(Session.userId) ??
                      false)
                  ? GestureDetector(
                      onTap: () {
                        ref.read(navigationStackController).push(
                            NavigationStackItem.inviteFrd(
                                groupId: groupInfoScreenWatch
                                        .getGroupDetailsResponseModel
                                        ?.groupId ??
                                    '',
                                groupDetailsResponseModel: groupInfoScreenWatch
                                    .getGroupDetailsResponseModel));
                      },
                      child: SvgPicture.asset(
                        Assets.icons.tablerIconQrcode,
                        color: AppColors.primeryTxt,
                      ),
                    )
                  : const SizedBox(),
              getHorizonatlWidth(16),
              PopupMenuButton<int>(
                onSelected: (value) async {
                  showConfirmationDialog(
                    context,
                    'Leave Group',
                    'Are you sure want to leave group?',
                    'Leave',
                    'Cancel',
                    (isPositive) async {
                      if (isPositive) {
                        if (value == 0) {
                          groupInfoScreenWatch.updateIsLoading(true);
                          bool isLeave = await GroupChatManager.instance
                              .leaveGroup(groupInfoScreenWatch
                                      .getGroupDetailsResponseModel?.groupId ??
                                  '');

                          if (isLeave) {
                            ref.read(navigationStackController).pop();
                            ref.read(navigationStackController).pop();
                          }
                          groupInfoScreenWatch.updateIsLoading(false);
                        }
                      }
                    },
                  );
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text('Leave Group'),
                  ),
                ],
                child: SvgPicture.asset(
                  Assets.icons.tablerIconDotsVertical,
                  color: AppColors.primeryTxt,
                ),
              ),
            ],
          ),
          getHorizonatlWidth(16)
        ],
      ),
      body: Stack(
        children: [
          bodyWidget(ref),
          DialogProgressBar(isLoading: groupInfoScreenWatch.isLoading)
        ],
      ),
      bottomNavigationBar: (groupInfoScreenWatch
                  .getGroupDetailsResponseModel?.adminIds
                  ?.contains(Session.userId) ??
              false)
          ? GroupInfoBottomInviteFrdWidget()
          : const SizedBox(),
    );
  }

  Widget bodyWidget(WidgetRef ref) {
    final groupInfoScreenWatch = ref.watch(singleGroupController);

    return CommonBgContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getVerticalHeight(100),
          MyRegularText(
            groupInfoScreenWatch.getGroupDetailsResponseModel?.groupName ?? '',
            style: BaseTextStyle.headerXl,
          ),
          getVerticalHeight(20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyRegularText(
                  "${groupInfoScreenWatch.getGroupDetailsResponseModel?.members?.length ?? ""} Members",
                  style: BaseTextStyle.lableM,
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: getHeight(10)),
                    itemCount: groupInfoScreenWatch
                            .getGroupDetailsResponseModel?.members?.length ??
                        0,
                    itemBuilder: (context, i) {
                      if (groupInfoScreenWatch.getGroupDetailsResponseModel ==
                          null) {
                        return CircularProgressIndicator();
                      }
                      return ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: getHeight(0)),
                        leading: SizedBox(
                          height: getHeight(50),
                          width: getWidth(50),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundImage: NetworkImage(groupInfoScreenWatch
                                    .getGroupDetailsResponseModel
                                    ?.members?[i]
                                    .userImage ??
                                ''),
                            // backgroundColor: Colors.grey[800],
                          ),
                        ),
                        title: MyRegularText(
                          groupInfoScreenWatch.getGroupDetailsResponseModel
                                  ?.members?[i].userName ??
                              '',
                          style: BaseTextStyle.lableM,
                        ),
                        subtitle: MyRegularText(
                          (groupInfoScreenWatch
                                      .getGroupDetailsResponseModel?.adminIds
                                      ?.contains(groupInfoScreenWatch
                                          .getGroupDetailsResponseModel
                                          ?.members?[i]
                                          .userId) ??
                                  false)
                              ? 'Admin'
                              : 'Member',
                          style: BaseTextStyle.textS
                              .copyWith(color: AppColors.secondaryTxt),
                        ),
                        trailing: (groupInfoScreenWatch
                                    .getGroupDetailsResponseModel
                                    ?.members?[i]
                                    .userId !=
                                Session.userId)
                            ? (groupInfoScreenWatch
                                        .getGroupDetailsResponseModel?.adminIds
                                        ?.contains(Session.userId) ==
                                    true)
                                ? PopupMenuButton<int>(
                                    onSelected: (value) async {
                                      showConfirmationDialog(
                                        context,
                                        'Remove From Group',
                                        'Are you sure want to remove user from group?',
                                        'Remove',
                                        'Cancel',
                                        (isPositive) async {
                                          if (isPositive) {
                                            if (value == 0) {
                                              groupInfoScreenWatch
                                                  .updateIsLoading(true);
                                              bool isRemove = await GroupChatManager.instance.removeMember(
                                                  groupId: groupInfoScreenWatch
                                                          .getGroupDetailsResponseModel
                                                          ?.groupId ??
                                                      '',
                                                  userId: groupInfoScreenWatch
                                                          .getGroupDetailsResponseModel
                                                          ?.members?[i]
                                                          .userId ??
                                                      '',
                                                  userName: groupInfoScreenWatch
                                                          .getGroupDetailsResponseModel
                                                          ?.members?[i]
                                                          .userName ??
                                                      '',
                                                  userImage: groupInfoScreenWatch
                                                          .getGroupDetailsResponseModel
                                                          ?.members?[i]
                                                          .userImage ??
                                                      '');

                                              if (isRemove) {
                                                await groupInfoScreenWatch
                                                    .getGroupDetails(
                                                        groupInfoScreenWatch
                                                                .getGroupDetailsResponseModel
                                                                ?.groupId ??
                                                            '');
                                              }
                                              groupInfoScreenWatch
                                                  .updateIsLoading(false);
                                            }
                                          }
                                        },
                                      );
                                    },
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<int>>[
                                      const PopupMenuItem<int>(
                                        value: 0,
                                        child: Text('Remove'),
                                      ),
                                    ],
                                    child: SvgPicture.asset(
                                      Assets.icons.tablerIconDotsVertical,
                                      color: AppColors.primeryTxt,
                                    ),
                                  )
                                : const SizedBox()
                            : const SizedBox(),
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class GroupInfoBottomInviteFrdWidget extends ConsumerWidget {
  const GroupInfoBottomInviteFrdWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inviteFriendWatch = ref.watch(inviteFriendController);
    final groupInfoScreenWatch = ref.watch(singleGroupController);

    return SafeArea(
      child: GestureDetector(
        onTap: () async {
          try {
            await inviteFriendWatch.shareQRCodeCaptureFromWidget(
                joinLink:
                    '$staticGroupChatUrl${groupInfoScreenWatch.getGroupDetailsResponseModel?.groupId}');
          } catch (e) {
            showLog('Error $e');
          }
        },
        child: Container(
          height: 50.h,
          padding: EdgeInsets.symmetric(horizontal: getWidth(16)),
          width: context.width,
          color: AppColors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              inviteFriendWatch.isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Center(
                      child: MyRegularText(
                        "Invite Friends",
                        style: BaseTextStyle.buttonM,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
