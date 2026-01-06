import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';

import '../../../../../../framework/controller/main/inbox/inbox_home/inbox_home_controller.dart';
import '../../../../../utils/helper/base_widget.dart';

class CreateNewGroupTxtWidget extends ConsumerWidget with BaseConsumerWidget {
  const CreateNewGroupTxtWidget({
    super.key,
  });

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final createNewGroupTxtWidgetWatch = ref.watch(inboxHomeController);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyRegularText(
          "Create New Group",
          style: BaseTextStyle.lableL.copyWith(fontWeight: FontWeight.w600),
        ),
        getVerticalHeight(10.h),
        SizedBox(
          width: getWidth(343.w),
          child: Text(
            "Create group and share movies and web series previews with friends.",
            style: BaseTextStyle.textM.copyWith(fontSize: 16, color: AppColors.secondaryTxt),
          ),
        ),
        getVerticalHeight(10.h),
      ],
    );
  }
}
