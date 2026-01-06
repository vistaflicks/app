import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:vista_flicks/framework/utils/extension/context_extension.dart';
import 'package:vista_flicks/framework/utils/extension/extension.dart';
import 'package:vista_flicks/ui/routing/navigation_stack_item.dart';
import 'package:vista_flicks/ui/routing/stack.dart';
import 'package:vista_flicks/ui/utils/widgets/common_button.dart';
import 'package:vista_flicks/ui/utils/widgets/common_dialogs.dart';
import 'package:vista_flicks/ui/utils/widgets/common_form_field.dart';
import 'package:vista_flicks/ui/utils/widgets/dropdown/common_form_field_dropdown.dart';

import '../../../../core/values/app_colours.dart';
import '../../../../core/values/size_constant.dart';
import '../../../../core/values/strings.dart';
import '../../../../core/values/text_styles/base_textstyle.dart';
import '../../../../core/widgets/common_bg_container.dart';
import '../../../../core/widgets/common_image_view.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/my_regular_text.dart';
import '../../../../framework/controller/main/chatbot/chatbot_controller.dart';
import '../../../../framework/repository/chatbot/model/chatbot_message_response.dart';
import '../../../../gen/assets.gen.dart';
import '../../auth/initial_watch_preferences/helper/chat_bubble.dart';

class ChatBotScreen extends ConsumerStatefulWidget {
  const ChatBotScreen({super.key});

  @override
  ConsumerState<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends ConsumerState<ChatBotScreen> {
  final TextEditingController bookmarkSearchController =
      TextEditingController();
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // TODO: implement initState

    ref.read(chatbotController.notifier).updateMessages();
  }

  // @override
  // void dispose() {
  //   final chatbotState = ref.watch(chatbotController);
  //   chatbotState.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final chatbotState = ref.watch(chatbotController);
    final chatbotNotifier = ref.read(chatbotController.notifier);
    if (MediaQuery.of(context).viewInsets.bottom != 0) {
      chatbotNotifier.scrollToBottomWhenKeyboardOpen();
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.black.withOpacity(.5),
        foregroundColor: AppColors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        // titleSpacing: 0,
        leading: SizedBox(),
        title: Stack(children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyRegularText(
                "Flixy AI",
                style: BaseTextStyle.headerMl,
              ),
              getHorizonatlWidth(5),
              MyRegularText(
                "BETA",
                style: BaseTextStyle.headerMl
                    .copyWith(fontSize: 10, color: AppColors.red),
              ),
            ],
          ),
        ]),
      ),
      body: CommonBgContainer(
        child: Column(
          children: [
            SizedBox(
              height: 50.h,
            ),
            Expanded(
              child: StreamBuilder<List<ChatbotMessageResponse>>(
                stream: chatbotState.messageStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  final messages = snapshot.data!;

                  return ListView.builder(
                    controller: chatbotState.scrollController,
                    padding: EdgeInsets.only(top: 50.h),
                    itemCount: messages.length +
                        (chatbotState.chatBotAPIState.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == messages.length &&
                          chatbotState.chatBotAPIState.isLoading) {
                        return _buildLoadingWidget();
                      }

                      /// If Keyboard is open then scroll to max
                      // if (FocusScope.of(context).hasFocus) {
                      //   chatbotNotifier.scrollToBottomWhenKeyboardOpen();
                      // }

                      final msg = messages[index];
                      bool isUser = msg.sender == "user";
                      if (msg.data?.isEmpty == true) {
                        return SizedBox.shrink();
                      }
                      return Column(
                        crossAxisAlignment: isUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          ChatBubble(
                            text: msg.messageText ?? '',
                            // isUser: isUser,
                            // animateTyping: index == messages.length - 1,
                            isUser: index == 0 || index == 1
                                ? false
                                : msg.messageText?.isNotEmpty == true,
                            animationCompleted: false,
                          ),
                          if (msg.type?.toLowerCase() == "text")
                            Row(
                              children: [
                                Expanded(
                                  child: ChatBubble(
                                    text: msg.data?.firstOrNull?.response ?? '',
                                    isUser: false,
                                    animateTyping: index == messages.length - 1,
                                    animationCompleted:
                                        index == messages.length - 1,
                                  ),
                                ),
                                getHorizonatlWidth(10.w),
                                GestureDetector(
                                    onTap: () {
                                      log(msg.id ?? "");
                                      _showReportDialog(context, msg);
                                    },
                                    child: Icon(Icons.report,
                                        color: AppColors.primeryTxt))
                              ],
                            ),
                          if (msg.type?.toLowerCase() == "poster")
                            if (!isUser && msg.data?.isNotEmpty == true)
                              Row(
                                children: [
                                  Expanded(
                                    child: GridSection(
                                        data: msg.data!,
                                        ref: ref,
                                        response: msg),
                                  ),
                                  getHorizonatlWidth(10.w),
                                  GestureDetector(
                                      onTap: () {
                                        _showReportDialog(context, msg);
                                      },
                                      child: Icon(Icons.report,
                                          color: AppColors.primeryTxt))
                                ],
                              ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            getVerticalHeight(
              chatbotState.isStarted
                  ? MediaQuery.of(context).viewInsets.bottom != 0
                      ? context.height * .1
                      : context.height * .19
                  : context.height * .17,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Consumer(
        builder: (context, ref, _) {
          return chatbotState.isStarted
              ? _buildChatInput(context, ref)
              : CustomButton(
                  text: AppStrings.okLetsStart,
                  fun: () {
                    chatbotNotifier.sendMessage(
                      context,
                      AppStrings.okLetsStart,
                      true,
                    );
                    chatbotNotifier.updateWidget();
                  },
                ).paddingOnly(bottom: 80.h, left: 10.w, right: 10.w);
        },
      ),
    );
  }

  Widget _buildChatInput(BuildContext context, WidgetRef ref) {
    final chatbotNotifier = ref.read(chatbotController.notifier);

    return Container(
      width: context.width,
      // color: AppColors.black,
      padding: EdgeInsets.symmetric(horizontal: getWidth(16.w), vertical: 10.h),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              style: const TextStyle(color: AppColors.primeryTxt),
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: () {
                    final msg = controller.text.trim();
                    if (msg.isNotEmpty) {
                      chatbotNotifier.sendMessage(context, msg, false);
                      controller.clear();
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10, top: 6, bottom: 6),
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: AppColors.primeryTxt,
                        borderRadius: BorderRadius.circular(50)),
                    child: SvgPicture.asset(
                      Assets.icons.tablerIconSend,
                      color: AppColors.red,
                    ),
                  ),
                ),
                hintText: "  Message...",
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.border),
                    borderRadius: BorderRadius.circular(50)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.border),
                    borderRadius: BorderRadius.circular(50)),
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.border),
                    borderRadius: BorderRadius.circular(50)),
                hintStyle:
                    TextStyle(color: AppColors.primeryTxt.withOpacity(0.6)),
                filled: true,
                fillColor: AppColors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ).paddingOnly(
        bottom: MediaQuery.of(context).viewInsets.bottom != 0 ? 0 : 80,
      ),
    );
  }

  void _showReportDialog(BuildContext context, ChatbotMessageResponse msg) {
    final chatbotNotifier = ref.read(chatbotController.notifier);
    final List<String> reportReasons = [
      'Offensive content',
      'Misleading or inaccurate',
      'Sexual or violent content',
      'Spam or irrelevant',
      'Other',
    ];
    String? selectedReason;

    showWidgetDialog(
      context,
      StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Report",
                style: BaseTextStyle.headerM.copyWith(fontSize: 50.sp),
              ).paddingOnly(top: 15.h),
              SizedBox(
                width: 250.w,
                child: Text(
                  "Submitting a report helps us improve your experience. You won't be able to edit the report after submission.",
                  style: BaseTextStyle.headerM.copyWith(fontSize: 15.sp),
                ).paddingOnly(top: 15.h),
              ),
              // Dropdown for reasons
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                child: CommonDropdownInputFormField<String>(
                  menuItems: reportReasons,
                  hintText: 'Select a reason',
                  borderColor: AppColors.border,
                  borderRadius: 16.r,
                  isEnabled: true,
                  // Set dropdown open background color to white
                  // and selected item text style to white
                  selectedItemBuilder: (context) {
                    return reportReasons.map((item) {
                      final isSelected = item == selectedReason;
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item,
                          style: BaseTextStyle.headerM.copyWith(
                            fontSize: 15.sp,
                            color: isSelected ? Colors.white : AppColors.black,
                          ),
                        ),
                      );
                    }).toList();
                  },
                  // Set dropdown menu background color
                  items: reportReasons
                      .map(
                        (item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: BaseTextStyle.headerM.copyWith(
                                fontSize: 15.sp, color: AppColors.black),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedReason = value;
                      if (selectedReason != 'Other') {
                        chatbotNotifier.reportController.clear();
                      }
                    });
                  },
                ),
              ),
              // Show text field only if 'Other' is selected
              if (selectedReason == 'Other')
                CommonInputFormField(
                  textEditingController: chatbotNotifier.reportController,
                  hintText: "Enter your report here...",
                  maxLines: 5,
                  backgroundColor: AppColors.border,
                  borderColor: AppColors.border,
                  borderRadius: BorderRadius.circular(16.r),
                ).paddingSymmetric(vertical: 10.h, horizontal: 15.w),
              CommonButton(
                buttonText: 'Report',
                buttonEnabledColor: AppColors.red,
                borderRadius: BorderRadius.circular(100.r),
                buttonTextStyle: BaseTextStyle.headerM
                    .copyWith(fontSize: 15.sp, color: Colors.white),
                onTap: () {
                  final isOther = selectedReason == 'Other';
                  final reportText = chatbotNotifier.reportController.text;
                  final reason = isOther ? reportText : selectedReason;
                  if (reason != null && reason.isNotEmpty) {
                    final reportPayload = {
                      "messageId": msg.id,
                      "message": msg.data?.firstOrNull?.response ?? '',
                      "reason": reason,
                      "timestamp": DateTime.now().toIso8601String(),
                    };
                    chatbotNotifier.submitReport(reportPayload).whenComplete(
                      () {
                        Navigator.pop(context);
                        chatbotNotifier.reportController.clear();
                        showSuccessDialog(
                          context,
                          "Report submitted successfully",
                          "Thank you for your feedback!",
                          () {},
                        );
                      },
                    );
                  }
                },
              ).paddingSymmetric(vertical: 10.h, horizontal: 15.w),
              CommonButton(
                buttonText: 'Cancel',
                buttonEnabledColor: AppColors.black,
                borderRadius: BorderRadius.circular(100.r),
                buttonTextStyle: BaseTextStyle.headerM
                    .copyWith(fontSize: 15.sp, color: Colors.white),
                onTap: () {
                  chatbotNotifier.reportController.clear();
                  Navigator.of(context).pop();
                },
              ).paddingSymmetric(vertical: 10.h, horizontal: 15.w),
            ],
          );
        },
      ),
      () {},
    );
  }

  Widget _buildLoadingWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Lottie.asset(
          height: getHeight(50),
          Assets.lottie.animation1737368859751,
        ),
        const SizedBox(width: 8),
        CommonImageView(
          height: getHeight(50),
          imagePath: Assets.background.loading.path,
        ),
      ],
    );
  }
}

class GridSection extends StatelessWidget {
  final List<ChatbotMessageData> data;
  final ChatbotMessageResponse response;
  final WidgetRef ref;

  const GridSection(
      {super.key,
      required this.data,
      required this.ref,
      required this.response});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Lottie.asset(
          height: getHeight(50.h),
          width: getWidth(50.w),
          Assets.lottie.animation1737368859751,
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: data.length,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.7,
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final item = data[index];

              return GestureDetector(
                onTap: () {
                  ref.read(navigationStackController).push(
                      NavigationStackItemDetailScreen(
                          contentId: item.id ?? ""));
                },
                child: CommonImageView(
                  url: item.posterPath,
                  radius: 10.r,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
