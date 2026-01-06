import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vista_flicks/core/widgets/custom_text_form_field.dart';

import '../../../../../../framework/controller/main/inbox/inbox_home/inbox_home_controller.dart';
import '../../../../../utils/helper/base_widget.dart';

class GroupNameFieldWidget extends ConsumerWidget with BaseConsumerWidget {
  const GroupNameFieldWidget({
    super.key,
  });

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final groupNameFieldWidgetWatch = ref.watch(inboxHomeController);
    return CustomTextFormField(
      hintText: "Enter group name",
      controller: groupNameFieldWidgetWatch.createGroupController,
      onChanged: (value) {
        groupNameFieldWidgetWatch.isInputValid = value.trim().isNotEmpty;
      },
    );
  }
}
