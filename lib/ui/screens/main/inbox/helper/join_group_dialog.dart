import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/framework/controller/main/inbox/single_group/single_group_controller.dart';
import 'package:vista_flicks/framework/utils/extension/extension.dart';
import 'package:vista_flicks/ui/utils/theme/text_style.dart';
import 'package:vista_flicks/ui/utils/theme/theme.dart';
import 'package:vista_flicks/ui/utils/widgets/common_button.dart';
import 'package:vista_flicks/ui/utils/widgets/common_text.dart';

class JoinGroupDialog extends ConsumerWidget {
  final String groupId;
  final Function() onCancelCall;
  final Function() onJoinCall;

  const JoinGroupDialog({super.key, required this.groupId, required this.onCancelCall, required this.onJoinCall});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final singleGroupScreenWatch = ref.watch(singleGroupController);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 60,
          child: Wrap(
            children: List.generate(
              singleGroupScreenWatch.getGroupDetailsResponseModel?.members?.length ?? 0,
              // 4,
              (i) {
                return SizedBox(
                  height: getHeight(25),
                  width: getWidth(25),
                  child: CircleAvatar(
                    radius: 15,
                    //backgroundImage: NetworkImage(singleGroupScreenWatch.getGroupDetailsResponseModel?.members?[i].userImage ?? ''),
                    backgroundColor: Colors.grey[800],
                  ),
                );
              },
            ),
          ),
        ).alignAtCenter(),
        CommonText(
          title: singleGroupScreenWatch.getGroupDetailsResponseModel?.groupName ?? 'TEST',
          textStyle: BaseTextStyle.headerM.copyWith(fontSize: 20.sp),
        ).paddingOnly(top: 15.h),
        CommonText(
          title: 'Created by ${(singleGroupScreenWatch.getGroupDetailsResponseModel?.admins?.isNotEmpty ?? false) ? singleGroupScreenWatch.getGroupDetailsResponseModel?.admins?.first.userName ?? 'TEST' : 'TEST'}',
          textStyle: BaseTextStyle.headerM.copyWith(fontSize: 14.sp),
        ).paddingOnly(top: 5.h),
        CommonText(
          title: '${singleGroupScreenWatch.getGroupDetailsResponseModel?.members?.length} Members',
          textStyle: BaseTextStyle.headerM.copyWith(fontSize: 14.sp),
        ).paddingOnly(top: 5.h),
        CommonButton(
          buttonText: 'Join Group',
          buttonEnabledColor: AppColors.red,
          borderRadius: BorderRadius.circular(100.r),
          buttonTextStyle: BaseTextStyle.headerM.copyWith(fontSize: 15.sp, color: Colors.white),
          onTap: () {
            onJoinCall();
          },
        ).paddingOnly(top: 15.h),
        CommonButton(
          buttonText: 'Cancel',
          buttonEnabledColor: AppColors.black,
          borderRadius: BorderRadius.circular(100.r),
          buttonTextStyle: BaseTextStyle.headerM.copyWith(fontSize: 15.sp, color: Colors.white),
          onTap: () {
            onCancelCall();
          },
        ).paddingOnly(top: 15.h)
      ],
    ).paddingAll(20.h);
  }
}
