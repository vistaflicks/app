import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/framework/utils/extension/context_extension.dart';

import '../../../core/values/app_colours.dart';
import '../../../core/values/size_constant.dart';
import '../../../core/values/text_styles/base_textstyle.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_form_field.dart';
import '../../../framework/controller/main/inbox/single_group/single_group_controller.dart';
import '../../../framework/controller/main/preview_and_detail/detail/detail_controller.dart';
import '../../../framework/provider/network/network.dart';
import '../../../framework/repository/chat/model/group_details_response_model.dart';
import '../../../framework/repository/chat/model/message_list_response_model.dart';
import '../../../framework/utils/local_storage/session.dart';
import '../helper/base_widget.dart';
import '../helper/group_chat_manager/group_chat_manager.dart';

class CommonGroupSelectionSheet extends ConsumerStatefulWidget {
  final MessageMedia media;
  final TextEditingController searchTxtController;

  const CommonGroupSelectionSheet({
    super.key,
    required this.searchTxtController,
    required this.media,
  });
  @override
  ConsumerState<CommonGroupSelectionSheet> createState() =>
      _CommonGroupSelectionSheetState();
}

class _CommonGroupSelectionSheetState
    extends ConsumerState<CommonGroupSelectionSheet>
    with BaseConsumerStatefulWidget {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.searchTxtController.clear();
  }

  @override
  Widget buildPage(BuildContext context) {
    final detailScreenWatch = ref.watch(detailController);
    final singleGroupScreenWatch = ref.watch(singleGroupController);

    return StreamBuilder<List<GroupDetailsResponseModel>>(
      stream: GroupChatManager.instance.getGroupsStream(Session.userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        ref.read(detailController).groupList = snapshot.data!;
        final groupList = detailScreenWatch.filteredGroupList.isEmpty &&
                widget.searchTxtController.text.isEmpty
            ? detailScreenWatch.groupList
            : detailScreenWatch.filteredGroupList;

        if (groupList.isEmpty) {
          // searchTxtController.clear();
          return Container(
            padding: const EdgeInsets.all(16.0),
            height: context.height * 0.7,
            child: Column(
              children: [
                CustomTextFormField(
                  controller: widget.searchTxtController,
                  prefix:
                      Icon(CupertinoIcons.search, color: AppColors.primeryTxt),
                  contentPadding: EdgeInsets.zero,
                  fillColor: AppColors.lightGray1,
                  hintText: "Search group name",
                  onChanged: (value) => detailScreenWatch.onSearch(value),
                ),
                SizedBox(height: context.height * .2),
                const Center(child: Text("You're not in any groups.")),
              ],
            ),
          );
        }

        return StatefulBuilder(
          builder: (context, setState) => DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.7,
            maxChildSize: 0.95,
            builder: (context, scrollController) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    children: [
                      CustomTextFormField(
                        controller: widget.searchTxtController,
                        prefix: Icon(CupertinoIcons.search,
                            color: AppColors.primeryTxt),
                        contentPadding: EdgeInsets.zero,
                        fillColor: AppColors.lightGray1,
                        hintText: "Search group name",
                        onChanged: (value) => detailScreenWatch.onSearch(value),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: GridView.builder(
                          controller: scrollController,
                          itemCount: groupList.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                          ),
                          itemBuilder: (context, index) {
                            var avatarLength =
                                groupList[index].members?.length ?? 0;
                            final isSelected = detailScreenWatch.selectedGroups
                                .contains(index);

                            return GestureDetector(
                              onTap: () {
                                ref
                                    .read(detailController)
                                    .toggleSelection(index);
                                setState(() {});
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.red.withOpacity(0.1)
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.red
                                        : AppColors.black,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 60.w,
                                      child: Wrap(
                                        spacing: 2,
                                        runSpacing: 2,
                                        children: List.generate(
                                          (avatarLength! > 4
                                              ? 4
                                              : avatarLength),
                                          (i) {
                                            // For the 4th avatar, if there are more than 4 members, show +X
                                            if (i == 3 && avatarLength > 4) {
                                              return SizedBox(
                                                height: getHeight(25.h),
                                                width: getWidth(25.w),
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      AppColors.red,
                                                  child: Text(
                                                    // '+${avatarLength - 3}',
                                                    '+${avatarLength - 3}',
                                                    style: BaseTextStyle.textXxs
                                                        .copyWith(
                                                      color: Colors.white,
                                                      // fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            return SizedBox(
                                              height: getHeight(25.h),
                                              width: getWidth(25.w),
                                              child: CircleAvatar(
                                                radius: 15,
                                                backgroundImage: NetworkImage(
                                                  groupList?[index]
                                                          .members?[i]
                                                          .userImage ??
                                                      '',
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      groupList[index].groupName ?? "",
                                      style: BaseTextStyle.textS
                                          .copyWith(color: Colors.white),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  if (detailScreenWatch.selectedGroups.isNotEmpty)
                    Positioned(
                      bottom: 10.h,
                      left: 10.h,
                      right: 10.h,
                      child: CustomButton(
                        width: MediaQuery.of(context).size.width,
                        text: "Send To Group",
                        fun: () {
                          for (var element
                              in detailScreenWatch.selectedGroups) {
                            singleGroupScreenWatch.sendMessage(
                              media: widget.media,
                              groupId: groupList[element].groupId.toString(),
                            );
                            // print(
                            //     "element==========>${groupList[element].groupId} ");
                          }
                          widget.searchTxtController.clear();
                          Navigator.pop(context);
                          // ref.read(navigationStackController).pop();
                          // singleGroupScreenWatch.sendMessage(
                          //   media: media,
                          //   groupId: detailScreenWatch
                          //       .filteredGroupList.first.groupId
                          //       .toString(),
                          // );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
