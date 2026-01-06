import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/framework/utils/extension/context_extension.dart';
import 'package:vista_flicks/framework/utils/extension/extension.dart';
import 'package:vista_flicks/ui/utils/const/app_constants.dart';

import '../../../../../../core/values/app_colours.dart';
import '../../../../../../core/values/size_constant.dart';
import '../../../../../../core/values/text_styles/base_textstyle.dart';
import '../../../../../../gen/assets.gen.dart';

class GroupChatBubble extends StatelessWidget {
  final String text;
  final bool isSender;
  final String sendByName;
  final String sendByImage;
  final String sendTime;

  final bool showAvatar;

  // final Widget? icon;

  const GroupChatBubble({
    super.key,
    required this.text,
    required this.isSender,
    required this.sendByName,
    required this.sendByImage,
    required this.sendTime,
    required this.showAvatar,
    // this.icon
  });

  @override
  Widget build(BuildContext context) {
    showLog('sendByImage $sendByImage');
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        // isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // if (!isSender && showAvatar)
              //   SizedBox(
              //     width: getWidth(40.w),
              //     height: getHeight(40.h),
              //     child: CircleAvatar(
              //       backgroundImage: sendByImage != ''
              //           ? NetworkImage(sendByImage)
              //           : AssetImage(Assets.images.av11.path)
              //               as ImageProvider<Object>,
              //     ),
              //   ),
              // if (!isSender) getHorizonatlWidth(9),
              // Flexible(
              //   child: Container(
              //     margin: EdgeInsets.symmetric(vertical: isSender ? 0 : 8),
              //     padding: EdgeInsets.symmetric(
              //         horizontal: getWidth(10.w), vertical: getHeight(9.h)),
              //     constraints: BoxConstraints(maxWidth: context.width * .8),
              //     decoration: BoxDecoration(
              //       color: isSender
              //           ? AppColors.red
              //           : AppColors.black.withOpacity(0.5),
              //       border: Border.all(
              //           width: 1,
              //           color: isSender ? AppColors.red : Color(0xff272727)),
              //       borderRadius: BorderRadius.circular(10.r),
              //     ),
              //     child: Column(
              //       crossAxisAlignment: isSender
              //           ? CrossAxisAlignment.end
              //           : CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           text,
              //           style: BaseTextStyle.textM,
              //         ),
              //         Text(
              //           sendTime,
              //           style: BaseTextStyle.textXxs,
              //         ).paddingOnly(top: 5.h)
              //       ],
              //     ),
              //   ),
              // ),
              // if (isSender) getHorizonatlWidth(9),
              // if (isSender && showAvatar)
              //   SizedBox(
              //     width: getWidth(40.w),
              //     height: getHeight(40.h),
              //     child: CircleAvatar(
              //       backgroundImage: sendByImage != ''
              //           ? NetworkImage(sendByImage)
              //           : AssetImage(Assets.images.av11.path)
              //               as ImageProvider<Object>,
              //     ),
              //   )
              !isSender && showAvatar
                  ? SizedBox(
                      width: getWidth(24.w),
                      height: getHeight(24.h),
                      child: CircleAvatar(
                        backgroundImage: sendByImage != ''
                            ? NetworkImage(sendByImage)
                            : AssetImage(Assets.images.av11.path)
                                as ImageProvider<Object>,
                      ),
                    )
                  : SizedBox(
                      width: 24.w,
                    ),
              getHorizonatlWidth(9),
              Flexible(
                child: Container(
                  // margin: EdgeInsets.symmetric(vertical: isSender ? 0 : 8),
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(10.w),
                      vertical: getHeight(isSender ? 5.h : 9.h)),
                  constraints: BoxConstraints(maxWidth: context.width * .8),
                  decoration: BoxDecoration(
                    color: isSender
                        ? AppColors.red
                        : AppColors.black.withOpacity(0.5),
                    border: Border.all(
                        width: 0.5,
                        color: isSender
                            ? AppColors.transparent
                            // : AppColors.transparent
                            : Color(0xff272727)),
                    borderRadius: isSender
                        ? BorderRadius.only(
                            topLeft: Radius.circular(10.r),
                            topRight: Radius.circular(10.r),
                            bottomLeft: Radius.circular(10.r),
                            bottomRight: Radius.circular(2.r))
                        : BorderRadius.only(
                            topLeft: Radius.circular(10.r),
                            topRight: Radius.circular(10.r),
                            bottomLeft: Radius.circular(2.r),
                            bottomRight: Radius.circular(10.r)),
                  ),
                  child: Column(
                    crossAxisAlignment: isSender
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: BaseTextStyle.textM,
                      ),
                      if (showAvatar)
                        Text(
                          sendTime,
                          style: BaseTextStyle.textXxs.copyWith(
                              fontSize: 8.sp,
                              color: AppColors.primeryTxt.withOpacity(0.7)),
                        ).paddingOnly(top: 7.h)
                    ],
                  ),
                ),
              ),
              getHorizonatlWidth(9.h),
              isSender && showAvatar
                  ? SizedBox(
                      width: getWidth(24.w),
                      height: getHeight(24.h),
                      child: CircleAvatar(
                        backgroundImage: sendByImage != ''
                            ? NetworkImage(sendByImage)
                            : AssetImage(Assets.images.av11.path)
                                as ImageProvider<Object>,
                      ),
                    )
                  : SizedBox(
                      width: 24.w,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
