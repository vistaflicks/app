import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';
import 'package:vista_flicks/framework/repository/chat/model/group_details_response_model.dart';
import 'package:vista_flicks/ui/routing/navigation_stack_item.dart';
import 'package:vista_flicks/ui/routing/stack.dart';

import '../../../../../utils/helper/base_widget.dart';

class GroupListWidget extends ConsumerWidget with BaseConsumerWidget {
  final List<GroupDetailsResponseModel>? groupList;

  const GroupListWidget({
    super.key,
    required this.groupList,
  });

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(top: getHeight(10.h), bottom: 50.h),
      itemCount: groupList?.length,
      physics: ScrollPhysics(),
      itemBuilder: (context, index) {
        var avatarLength = groupList?[index].members?.length;
        // if (groupList?[index].members?.length) {
        //   avatarLength = groupList?[index].members?.length;
        // }
        return GestureDetector(
          onTap: () {
            ref.read(navigationStackController).push(
                NavigationStackItem.singleGroup(
                    groupDetailsResponseModel: groupList?[index]));
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: getHeight(0)),
                leading: avatarLength == 1
                    ? SizedBox(
                        width: getWidth(60.w),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            groupList?[index].members?.first.userImage ?? '',
                          ),
                        ),
                      )
                    : SizedBox(
                        width: 60.w,
                        child: Wrap(
                          spacing: 2,
                          runSpacing: 2,
                          children: List.generate(
                            (avatarLength! > 4 ? 4 : avatarLength),
                            (i) {
                              // For the 4th avatar, if there are more than 4 members, show +X
                              if (i == 3 && avatarLength > 4) {
                                return SizedBox(
                                  height: getHeight(25.h),
                                  width: getWidth(25.w),
                                  child: CircleAvatar(
                                    backgroundColor: AppColors.red,
                                    child: Text(
                                      // '+${avatarLength - 3}',
                                      '+${avatarLength - 3}',
                                      style: BaseTextStyle.textXxs.copyWith(
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
                                    groupList?[index].members?[i].userImage ??
                                        '',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                // leading: avatarLength == 1
                //     ? SizedBox(
                //         height: getHeight(50.h),
                //         width: getWidth(50.w),
                //         child: CircleAvatar(
                //           radius: 14,
                //           backgroundImage: NetworkImage(
                //             groupList?[index].members?.first.userImage ?? '',
                //           ),
                //         ),
                //       )
                //     : Stack(
                //         children: [
                //           SizedBox(
                //             width: 60.w,
                //             height: 60.h,
                //             child: Stack(
                //               children: [
                //                 Wrap(
                //                   spacing: 2,
                //                   runSpacing: 2,
                //                   children: List.generate(
                //                     (avatarLength! > 4 ? 4 : avatarLength),
                //                     (i) {
                //                       return SizedBox(
                //                         height: getHeight(25.h),
                //                         width: getWidth(25.w),
                //                         child: CircleAvatar(
                //                           radius: 14,
                //                           backgroundImage: NetworkImage(
                //                             groupList?[index]
                //                                     .members?[i]
                //                                     .userImage ??
                //                                 '',
                //                           ),
                //                         ),
                //                       );
                //                     },
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //           if (avatarLength! > 4)
                //             Positioned(
                //               bottom: -4,
                //               right: -5,
                //               child: Container(
                //                 padding: EdgeInsets.symmetric(
                //                     horizontal: 6, vertical: 2),
                //                 decoration: BoxDecoration(
                //                   color: AppColors.red,
                //                   borderRadius: BorderRadius.circular(10),
                //                 ),
                //                 child: Text(
                //                   '+${avatarLength! - 4}',
                //                   style: BaseTextStyle.textS.copyWith(
                //                     color: Colors.white,
                //                     fontWeight: FontWeight.bold,
                //                   ),
                //                 ),
                //               ),
                //             ),
                //         ],
                //       ),

                // leading: avatarLength == 1
                //     ? SizedBox(
                //         // height: getHeight(40.h),
                //         width: getWidth(60.w),
                //         child: CircleAvatar(
                //           // radius: 14,
                //           backgroundImage: NetworkImage(
                //             groupList?[index].members?.first.userImage ?? '',
                //           ),
                //         ),
                //       )
                //     : SizedBox(
                //         width: 60.w,
                //         child: Wrap(
                //           children: List.generate(
                //             (avatarLength! > 4 ? 4 : avatarLength),
                //             (i) {
                //               return SizedBox(
                //                 height: getHeight(25.h),
                //                 width: getWidth(25.w),
                //                 child: CircleAvatar(
                //                   radius: 15,
                //                   backgroundImage: NetworkImage(
                //                       groupList?[index].members?[i].userImage ??
                //                           ''),
                //                 ),
                //               );
                //             },
                //           ),
                //         ),
                //       ),

                // horizontalTitleGap: 10.w,
                title: MyRegularText(
                  groupList?[index].groupName ?? '',
                  style: BaseTextStyle.lableM,
                ),
                subtitle: MyRegularText(
                  "${groupList?[index].members?.length} Members",
                  style: BaseTextStyle.textS
                      .copyWith(color: AppColors.secondaryTxt),
                ),
              ),
              if (!avatarLength!.isNaN)
                Divider(
                  height: 1.h,
                  color: AppColors.border.withOpacity(0.6),
                )
            ],
          ),
        );
      },
    );
  }
}
