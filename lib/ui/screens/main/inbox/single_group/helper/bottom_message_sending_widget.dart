import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/framework/utils/extension/context_extension.dart';
import 'package:vista_flicks/gen/assets.gen.dart';
import 'package:vista_flicks/ui/utils/helper/base_widget.dart';

import '../../../../../../framework/controller/main/inbox/single_group/single_group_controller.dart';

class BottomMessageSendingWidget extends ConsumerWidget with BaseConsumerWidget {
  const BottomMessageSendingWidget({
    super.key,
  });

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final bottomMessageSendingWidgetWatch = ref.watch(singleGroupController);
    return SafeArea(
      child: Container(
        width: context.width,
        color: AppColors.black,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getWidth(16.w), vertical: 10.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  // Text Field
                  Expanded(
                    child: TextField(
                      controller: bottomMessageSendingWidgetWatch.textController,
                      style: const TextStyle(color: AppColors.primeryTxt),
                      decoration: InputDecoration(
                        hintText: "Message...",
                        hintStyle: TextStyle(color: AppColors.primeryTxt.withOpacity(0.6)),
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
                    onTap: () => bottomMessageSendingWidgetWatch.sendMessage(groupId: ''),
                    child: SvgPicture.asset(
                      Assets.icons.tablerIconSend,
                      color: AppColors.red,
                    ),
                  )
                ],
              ),
              getVerticalHeight(20.h)
            ],
          ),
        ),
      ),
    );
  }
}
