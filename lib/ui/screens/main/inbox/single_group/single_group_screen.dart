import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/widgets/common_bg_container.dart';
import 'package:vista_flicks/core/widgets/common_image_view.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';
import 'package:vista_flicks/framework/controller/main/inbox/single_group/single_group_controller.dart';
import 'package:vista_flicks/framework/repository/chat/model/group_details_response_model.dart';
import 'package:vista_flicks/framework/repository/chat/model/message_list_response_model.dart';
import 'package:vista_flicks/framework/utils/extension/context_extension.dart';
import 'package:vista_flicks/framework/utils/extension/date_time_extensions.dart';
import 'package:vista_flicks/framework/utils/extension/extension.dart';
import 'package:vista_flicks/framework/utils/local_storage/session.dart';

import '../../../../../core/values/text_styles/base_textstyle.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../routing/navigation_stack_item.dart';
import '../../../../routing/stack.dart';
import '../../../../utils/helper/base_widget.dart';
import 'helper/group_chat_bubble.dart';

class SingleGroupScreen extends ConsumerStatefulWidget {
  final GroupDetailsResponseModel? groupDetailsResponseModel;

  const SingleGroupScreen({super.key, this.groupDetailsResponseModel});

  @override
  ConsumerState<SingleGroupScreen> createState() => _SingleGroupScreenState();
}

class _SingleGroupScreenState extends ConsumerState<SingleGroupScreen>
    with BaseConsumerStatefulWidget {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final singleGroupScreenWatch = ref.watch(singleGroupController);
      singleGroupScreenWatch.disposeController(isNotify: true);
      if (widget.groupDetailsResponseModel != null) {
        singleGroupScreenWatch.getGroupMessages(
            groupId: widget.groupDetailsResponseModel?.groupId ?? '');
      }
    });
  }

  @override
  Widget buildPage(BuildContext context) {
    final singleGroupScreenWatch = ref.watch(singleGroupController);
    return SafeArea(
      top: Platform.isAndroid,
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        extendBody: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: AppColors.black,
          foregroundColor: AppColors.primeryTxt,
          centerTitle: true,
          title:
              MyRegularText(widget.groupDetailsResponseModel?.groupName ?? ''),
          actions: [
            GestureDetector(
              onTap: () async {
                ref.read(navigationStackController).push(
                    NavigationStackItem.groupInfo(
                        groupDetailsResponseModel: singleGroupScreenWatch
                            .getGroupDetailsResponseModel));
                await singleGroupScreenWatch.getGroupDetails(
                    widget.groupDetailsResponseModel?.groupId ?? '');
              },
              child: SvgPicture.asset(
                Assets.icons.tablerIconInfoCircle,
                color: AppColors.primeryTxt,
              ),
            ),
            getHorizonatlWidth(16.w)
          ],
        ),
        body: CommonBgContainer(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: widget.groupDetailsResponseModel != null
                    ? StreamBuilder<List<MessageListResponseModel>>(
                        stream: singleGroupScreenWatch.getGroupMessages(
                          groupId:
                              widget.groupDetailsResponseModel?.groupId ?? '',
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }

                          List<MessageListResponseModel> messages =
                              snapshot.data ?? [];

                          if (messages.isEmpty) {
                            return const Center(
                                child: Text("No messages yet."));
                          }
                          return ListView.builder(
                            // shrinkWrap: true,
                            reverse: true,
                            // padding: const EdgeInsets.all(16),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final time =
                                  messages[index].createdAt?.toDateTime;
                              final message = messages[index];
                              final previousMessage =
                                  index > 0 ? messages[index - 1] : null;

                              // showAvatar only if it's the first message from the sender in the sequence
                              final showAvatar = previousMessage == null ||
                                  previousMessage.sendBy != message.sendBy;
                              final currentDate = message.createdAt?.toDateTime;
                              final previousDate =
                                  previousMessage?.createdAt?.toDateTime;

                              bool showDateLabel = false;

                              if (index == messages.length - 1) {
                                showDateLabel = true;
                              }
                              if (index < messages.length - 1) {
                                final nextMessage = messages[index + 1];
                                final nextDate =
                                    nextMessage.createdAt?.toDateTime;

                                if (currentDate != null &&
                                    nextDate != null &&
                                    !currentDate.isSameDate(nextDate)) {
                                  showDateLabel = true;
                                }
                              }

                              // if (index == messages.length - 1) {
                              //   // Only show if it's the first message of a new day
                              //   final nextMessageDate = index <
                              //       messages.length - 1
                              //       ? messages[index + 1].createdAt?.toDateTime
                              //       : null;
                              //
                              //   if (nextMessageDate == null ||
                              //       !currentDate!.isSameDate(nextMessageDate)) {
                              //     showDateLabel = true;
                              //   }
                              // } else if (previousDate == null ||
                              //     !currentDate!.isSameDate(previousDate)) {
                              //   showDateLabel = true;
                              // }
                              //

                              // if (index == messages.length - 1) {
                              //   showDateLabel = true;
                              // } else if (previousDate != null &&
                              //     currentDate != null &&
                              //     currentDate.difference(previousDate).inDays !=
                              //         0) {
                              //   showDateLabel = true;
                              // }
                              //
                              // if (index == messages.length - 1) {
                              //   // Always show label for the last message
                              //   showDateLabel = true;
                              // } else if (previousDate != null &&
                              //     currentDate != null &&
                              //     previousDate.toLocal().day !=
                              //         currentDate.toLocal().day) {
                              //   // Show label if the day (not just difference in days) changes
                              //   showDateLabel = true;
                              // }

                              // if (index == messages.length - 1 ||
                              //     previousDate == null ||
                              //     !currentDate!.isSameDate(previousDate)) {
                              //   showDateLabel = true;
                              // }

                              final formattedDate = currentDate != null
                                  ? getFormattedDateLabel(currentDate)
                                  : '';
                              return Column(
                                children: [
                                  if (showDateLabel)
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12.h),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 6.h, horizontal: 14.w),
                                        decoration: BoxDecoration(
                                          color:
                                              AppColors.black.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        child: Text(
                                          formattedDate,
                                          style: BaseTextStyle.textXs.copyWith(
                                            color: AppColors.primeryTxt
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (message.media != null)
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.h, horizontal: 0.w),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (message.media?.mediaReelId !=
                                                  null ||
                                              message.media?.mediaReelId
                                                      ?.isNotEmpty ==
                                                  true) {
                                            print("Route for reel ");
                                            ref
                                                .read(navigationStackController)
                                                .push(
                                                    NavigationStackItemReelScreen(
                                                        reelId: message.media
                                                                ?.mediaReelId ??
                                                            "",
                                                        contentId: message.media
                                                                ?.mediaId ??
                                                            ""));
                                          } else {
                                            print("Route for containte ");
                                            ref
                                                .read(navigationStackController)
                                                .push(
                                                    NavigationStackItemDetailScreen(
                                                        contentId: message.media
                                                                ?.mediaId ??
                                                            ""));
                                          }
                                        },
                                        child: Align(
                                          alignment:
                                              message.sendBy == Session.userId
                                                  ? Alignment.centerRight
                                                  : Alignment.centerLeft,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (!(message.sendBy ==
                                                  Session.userId))
                                                SizedBox(
                                                  width: getWidth(24.w),
                                                  height: getHeight(24.h),
                                                  child: CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(message
                                                                  .sendByImage ??
                                                              "")),
                                                ),
                                              // getHorizonatlWidth(9.h),
                                              CommonImageView(
                                                height: 150.h,
                                                width: 100.w,
                                                radius: 10.r,
                                                url: message.media?.mediaUrl,
                                              ),
                                              getHorizonatlWidth(9.h),
                                              if (message.sendBy ==
                                                  Session.userId)
                                                SizedBox(
                                                  width: getWidth(24.w),
                                                  height: getHeight(24.h),
                                                  child: CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(message
                                                                  .sendByImage ??
                                                              "")),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (message.content!.isNotEmpty)
                                    GroupChatBubble(
                                      text: message.content ?? '',
                                      isSender:
                                          message.sendBy == Session.userId,
                                      sendByName: message.sendByName ?? '',
                                      sendByImage: message.sendByImage ?? '',
                                      sendTime: time?.formattedTime12Hour ?? '',
                                      showAvatar: showAvatar,
                                    ).paddingOnly(
                                        bottom: showAvatar ? 20.h : 3.h),
                                ],
                              );

                              // final time = messages[index].createdAt?.toDateTime;
                              // showLog(
                              //     'messages[index].sendByImage ${messages[index].sendByImage}');
                              // return Column(
                              //   children: [
                              //     GroupChatBubble(
                              //       text: messages[index].content ?? '',
                              //       isSender:
                              //           messages[index].sendBy == Session.userId,
                              //       sendByName: messages[index].sendByName ?? '',
                              //       sendByImage:
                              //           messages[index].sendByImage ?? '',
                              //       sendTime: time?.formattedTime12Hour ?? '',
                              //     ).paddingSymmetric(vertical: 5.h),
                              //
                              //     // GroupChatBubble(text: "Finally found this movie on Vista Flicks", isSender: false),
                              //     // GroupChatBubble(text: "This app is superb! 😍", isSender: false),
                              //     // GroupChatBubble(text: "Let's watch it together 🍿🍿", isSender: true),
                              //   ],
                              // );
                              // Align(
                              //   alignment: message.isMe
                              //       ? Alignment.centerRight
                              //       : Alignment.centerLeft,
                              //   child: Container(
                              //     margin: const EdgeInsets.symmetric(vertical: 4),
                              //     padding: const EdgeInsets.all(12),
                              //     decoration: BoxDecoration(
                              //       color: message.isMe
                              //           ? AppColors.primeryTxt
                              //           : AppColors.black.withOpacity(0.2),
                              //       borderRadius: BorderRadius.circular(12),
                              //     ),
                              //     child: MyRegularText(
                              //       message.text,
                              //       color: AppColors.primeryTxt,
                              //     ),
                              //   ),
                              // );
                            },
                          );
                        })
                    : const SizedBox(),
              ),
              // getVerticalHeight(context.height * .01 +
              //     MediaQuery.of(context).viewInsets.bottom),
              // getVerticalHeight(10.h)
            ],
          ),
        ),
        bottomNavigationBar: AnimatedPadding(
          duration: const Duration(milliseconds: 50),
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: getWidth(16.w), vertical: 10.h),
            width: context.width,
            color: AppColors.black,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    // Text Field
                    Expanded(
                      child: TextField(
                        controller: singleGroupScreenWatch.textController,
                        style: const TextStyle(color: AppColors.primeryTxt),
                        decoration: InputDecoration(
                          hintText: "Message...",
                          hintStyle: TextStyle(
                              color: AppColors.primeryTxt.withOpacity(0.6)),
                          filled: true,
                          fillColor: AppColors.lightGray1,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    getHorizonatlWidth(10),

                    GestureDetector(
                      onTap: () {
                        singleGroupScreenWatch.sendMessage(
                            groupId:
                                widget.groupDetailsResponseModel?.groupId ??
                                    '');
                      },
                      child: SvgPicture.asset(
                        Assets.icons.tablerIconSend,
                        color: AppColors.red,
                      ),
                    )
                  ],
                ),
                // getVerticalHeight(20)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:vista_flicks/core/values/app_colours.dart';
// import 'package:vista_flicks/core/values/size_constant.dart';
// import 'package:vista_flicks/core/widgets/common_bg_container.dart';
// import 'package:vista_flicks/core/widgets/my_regular_text.dart';
// import 'package:vista_flicks/pages/main/inbox/single_group/single_group_controller.dart';
//
// import '../../../../gen/assets.gen.dart';
//
// class SingleGroupPage extends GetView<SingleGroupController> {
//   const SingleGroupPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: AppColors.black.withOpacity(.5),
//         foregroundColor: AppColors.primeryTxt,
//         centerTitle: true,
//         title: MyRegularText("Movie Nights"),
//         actions: [
//           SvgPicture.asset(
//             Assets.icons.tablerIconInfoCircle,
//             color: AppColors.primeryTxt,
//           ),
//           getHorizonatlWidth(16)
//         ],
//       ),
//       body: CommonBgContainer(
//         child: Column(
//           children: [],
//         ),
//       ),
//     );
//   }
// }
