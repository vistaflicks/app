import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';

import '../../../../../../framework/controller/main/inbox/inbox_home/inbox_home_controller.dart';
import '../../../../../utils/helper/base_widget.dart';

class InviteCheckButtonWidget extends ConsumerWidget with BaseConsumerWidget {
  const InviteCheckButtonWidget({
    super.key,
  });

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final inviteCheckButtonWidgetWatch = ref.watch(inboxHomeController);
    return CheckboxListTile(
      title: MyRegularText(
        "Allow users to invite more members",
        style: BaseTextStyle.textM.copyWith(
          color: inviteCheckButtonWidgetWatch.isInputValid ? AppColors.primeryTxt : AppColors.secondaryTxt, // Dim color when disabled
        ),
      ),
      checkColor: AppColors.black,
      value: inviteCheckButtonWidgetWatch.isCheckboxChecked,
      onChanged: inviteCheckButtonWidgetWatch.isInputValid
          ? (bool? newValue) {
              inviteCheckButtonWidgetWatch.toggleCheckbox();
              // inviteCheckButtonWidgetWatch.isCheckboxChecked =
              //     newValue ?? false;
            }
          : null,
      // Disable checkbox when input is empty
      activeColor: AppColors.green,
      contentPadding: const EdgeInsets.all(0),
      side: BorderSide(color: inviteCheckButtonWidgetWatch.isInputValid ? AppColors.primeryTxt : AppColors.placeholder),
      checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
