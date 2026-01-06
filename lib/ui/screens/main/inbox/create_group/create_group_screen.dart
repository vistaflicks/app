import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/core/widgets/common_bg_container.dart';
import 'package:vista_flicks/framework/repository/chat/model/create_group_request_model.dart';
import 'package:vista_flicks/framework/utils/extension/extension.dart';
import 'package:vista_flicks/framework/utils/local_storage/session.dart';
import 'package:vista_flicks/ui/routing/navigation_stack_item.dart';
import 'package:vista_flicks/ui/routing/stack.dart';
import 'package:vista_flicks/ui/utils/const/app_constants.dart';
import 'package:vista_flicks/ui/utils/helper/group_chat_manager/group_chat_manager.dart';

import '../../../../../core/values/size_constant.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../framework/controller/main/inbox/inbox_home/inbox_home_controller.dart';
import 'helper/create_new_group_txt_widget.dart';
import 'helper/group_name_field_widget.dart';
import 'helper/invite_check_button_widget.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});
  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  @override
  void initState() {
    super.initState();
    ref
        .read(inboxHomeController)
        .createGroupController
        .clear(); // Clear once here
  }

  @override
  Widget build(BuildContext context) {
    final createGroupScreenWatch = ref.watch(inboxHomeController);
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: CommonBgContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getVerticalHeight(100.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CreateNewGroupTxtWidget(),
                GroupNameFieldWidget(),
                InviteCheckButtonWidget(),
                // getVerticalHeight(context.height * .45),
              ],
            ),
            const Spacer(),
            CustomButton(
              isLoading: createGroupScreenWatch.isLoading,
              style: BaseTextStyle.buttonM.copyWith(
                color: (createGroupScreenWatch.isInputValid)
                    ? AppColors.primeryTxt
                    : AppColors.placeholder,
              ),
              color: (createGroupScreenWatch.isInputValid)
                  ? AppColors.red
                  : AppColors.black
                      .withOpacity(.6), // Default color when invalid
              text: "Create Group",
              fun: (createGroupScreenWatch.isInputValid)
                  ? () async {
                      createGroupScreenWatch.updateIsLoading(true);
                      String groupIdLink =
                          await GroupChatManager.instance.createGroup(
                        model: CreateGroupRequestModel(
                          admins: [
                            Admin(
                              userId: Session.userId,
                              userImage: Session.userProfileImage,
                              userName:
                                  '${Session.userFirstName} ${Session.userLastName}',
                            ),
                          ],
                          createdAt: DateTime.now().toString(),
                          groupName:
                              createGroupScreenWatch.createGroupController.text,
                          isGroup: true,
                          members: [
                            Admin(
                              userId: Session.userId,
                              userImage: Session.userProfileImage,
                              userName:
                                  '${Session.userFirstName} ${Session.userLastName}',
                            ),
                          ],
                          participants: [
                            Admin(
                              userId: Session.userId,
                              userImage: Session.userProfileImage,
                              userName:
                                  '${Session.userFirstName} ${Session.userLastName}',
                            ),
                          ],
                          unreadCount: null,
                          updatedAt: DateTime.now().toString(),
                          lastMessage: null,
                          memberIds: [Session.userId],
                          adminIds: [Session.userId],
                          isMembersCanInvite:
                              createGroupScreenWatch.isCheckboxChecked,
                        ),
                      );

                      if (groupIdLink != '') {
                        showLog('groupIdLink groupIdLink $groupIdLink');
                        createGroupScreenWatch.createGroupController.text = '';
                        createGroupScreenWatch.isCheckboxChecked = false;
                        createGroupScreenWatch.updateWidget();
                        createGroupScreenWatch.updateIsLoading(false);
                        ref.read(navigationStackController).pop();
                        ref.read(navigationStackController).push(
                            NavigationStackItem.initInviteFrd(
                                groupUrl: groupIdLink));
                      }
                    }
                  : () {},
            ).paddingOnly(bottom: 20.h),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get_state_manager/src/simple/get_view.dart';
// import 'package:vista_flicks/core/values/app_colours.dart';
// import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
// import 'package:vista_flicks/core/widgets/common_bg_container.dart';
// import 'package:vista_flicks/core/widgets/my_regular_text.dart';
//
// import '../../../../core/values/size_constant.dart';
// import '../../../../core/widgets/custom_text_form_field.dart';
// import '../inbox_home/inbox_home_controller.dart';
//
// class CreateGroupPage extends GetView<InboxHomeController> {
//   const CreateGroupPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.white,
//         systemOverlayStyle: SystemUiOverlayStyle.light,
//       ),
//       body: CommonBgContainer(
//         child: Column(
//           children: [
//             getVerticalHeight(100),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 MyRegularText(
//                   "Create New Group",
//                   style: BaseTextStyle.lableL
//                       .copyWith(fontWeight: FontWeight.w600),
//                 ),
//                 getVerticalHeight(10),
//                 SizedBox(
//                   width: getWidth(343),
//                   child: Text(
//                     "Create group and share movies and web series previews with friends.",
//                     style: BaseTextStyle.textM
//                         .copyWith(fontSize: 16, color: AppColors.secondaryTxt),
//                   ),
//                 ),
//                 CustomTextFormField(
//                   hintText: "Enter group name",
//                   onChanged: (value) {},
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
