import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/core/utils/config.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/core/widgets/common_image_view.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';
import 'package:vista_flicks/framework/controller/main/reel/models/get_comments.dart';
import 'package:vista_flicks/framework/utils/extension/date_time_extensions.dart';
import 'package:vista_flicks/framework/utils/local_storage/session.dart';

import '../../../../../core/values/app_colours.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';
import '../../../../../framework/controller/main/reel/reels_controller.dart';
import '../../../../../framework/provider/network/network.dart';

class ReelCommentsBottomSheet extends ConsumerStatefulWidget {
  final int reelIndex;

  const ReelCommentsBottomSheet({super.key, required this.reelIndex});

  @override
  ConsumerState<ReelCommentsBottomSheet> createState() =>
      _ReelCommentsBottomSheetState();
}

class _ReelCommentsBottomSheetState
    extends ConsumerState<ReelCommentsBottomSheet> {
  @override
  void initState() {
    super.initState();
    ref.read(reelsController).commentController.clear(); // Clear once here
  }

  @override
  Widget build(BuildContext context) {
    final comments = ref.watch(reelsController);
    final reel = comments.reelsList[widget.reelIndex];
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 5,
                width: 50,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              Expanded(
                child: comments.commentsState.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : comments.commentsList.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text("No Comments"),
                              ),
                            ],
                          )
                        : ListView.builder(
                            controller: scrollController,
                            // itemCount: 6,
                            itemCount: comments.commentsList.length,
                            itemBuilder: (context, index) {
                              final comment = comments.commentsList[index];

                              return ListTile(
                                leading: CommonImageView(
                                  height: 50.w,
                                  width: 50.w,
                                  url: comment.avatar ?? Config.kNoAvatarImage,
                                  radius: 100.r,
                                ),
                                // backgroundImage:
                                //     AssetImage(Assets.images.av10.path),

                                trailing: MyRegularText(
                                  DateTime.parse(comment.createdAt ?? "")
                                      .timeAgo(),
                                  // getFormattedDateLabel(DateTime.parse(
                                  //     comment.createdAt ?? "")),
                                  style: BaseTextStyle.textXs
                                      .copyWith(color: AppColors.secondaryTxt),
                                ),
                                title: MyRegularText(comment.comment ?? "",
                                    style: BaseTextStyle.textM),
                                subtitle: MyRegularText(
                                    comment.userName ?? "VistaReels User",
                                    style: BaseTextStyle.textXs.copyWith(
                                        color: AppColors.secondaryTxt)),
                              );
                            },
                          ),
              ),
              Padding(
                // padding: EdgeInsets.only(left: 12.w, bottom: 30.h),
                padding: EdgeInsets.only(
                    right: 10.w,
                    left: 10.w,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 10.h),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        action: TextInputAction.done,
                        onChanged: (value) {},
                        borderColor: AppColors.border,
                        hintText: "Add a comment...",
                        controller: comments.commentController,
                        // style: TextStyle(color: Colors.white),
                        // decoration: InputDecoration(
                        //   hintText:
                        //   hintStyle: TextStyle(color: Colors.white54),
                        //   border: InputBorder.none,
                        // ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        var text = comments.commentController.text;
                        if (text.isNotEmpty) {
                          comments.commentsList.insert(
                              0,
                              Result(
                                  createdAt: DateTime.now().toString(),
                                  comment: comments.commentController.text,
                                  avatar: Session.userProfileImage,
                                  userId: Session.userId,
                                  userName: Session.userFirstName));
                          // scrollController.animateTo(
                          //   scrollController.position.maxScrollExtent,
                          //   duration: const Duration(milliseconds: 100),
                          //   curve: Curves.easeOut,
                          // );
                          if (scrollController.hasClients) {
                            scrollController.animateTo(
                              scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.easeOut,
                            );
                          }

                          // scrollController.animateTo(
                          //   scrollController.position.maxScrollExtent,
                          //   duration: const Duration(milliseconds: 100),
                          //   curve: Curves.easeOut,
                          // );
                          comments.updateWidget();
                          comments.commentController.clear();
                          comments.postInteraction(
                              context: context,
                              index: widget.reelIndex,
                              comment: text);
                          reel.commentCount = (reel.commentCount ?? 0) + 1;
                        }
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
