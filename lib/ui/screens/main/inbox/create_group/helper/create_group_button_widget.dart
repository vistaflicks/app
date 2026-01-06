import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/core/widgets/custom_button.dart';
import 'package:vista_flicks/framework/controller/main/inbox/inbox_home/inbox_home_controller.dart';

import '../../../../../utils/helper/base_widget.dart';

class CreateGroupButtonWidget extends ConsumerWidget with BaseConsumerWidget {
  const CreateGroupButtonWidget({
    super.key,
  });

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final createGroupButtonWidgetWatch = ref.watch(inboxHomeController);
    return CustomButton(
      style: BaseTextStyle.buttonM.copyWith(
        color: (createGroupButtonWidgetWatch.isInputValid)
            ? AppColors.primeryTxt
            : AppColors.placeholder,
      ),
      color: (createGroupButtonWidgetWatch.isInputValid)
          ? AppColors.red
          : AppColors.black.withOpacity(.6), // Default color when invalid
      text: "Create Group",
      fun: (createGroupButtonWidgetWatch.isInputValid)
          ? () {
              // Handle group creation logic
              // Get.toNamed(Routes.INITINVITEFRD);
            }
          : () {},
    );
  }
}
