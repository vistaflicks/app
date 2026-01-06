import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/framework/controller/main/inbox/inbox_home/inbox_home_controller.dart';
import 'package:vista_flicks/framework/repository/chat/model/group_details_response_model.dart';
import 'package:vista_flicks/framework/utils/extension/context_extension.dart';
import 'package:vista_flicks/framework/utils/extension/extension.dart';
import 'package:vista_flicks/framework/utils/local_storage/session.dart';
import 'package:vista_flicks/ui/utils/helper/base_widget.dart';
import 'package:vista_flicks/ui/utils/helper/group_chat_manager/group_chat_manager.dart';

import '../../../../../core/values/app_colours.dart';
import '../../../../../core/values/size_constant.dart';
import 'helper/group_list_widget.dart';
import 'helper/inbox_top_appbar_widget.dart';

class InboxHomeScreen extends ConsumerStatefulWidget {
  const InboxHomeScreen({super.key});

  @override
  ConsumerState<InboxHomeScreen> createState() => _InboxHomeScreenState();
}

class _InboxHomeScreenState extends ConsumerState<InboxHomeScreen>
    with BaseConsumerStatefulWidget {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final inboxHomeScreenWatch = ref.watch(inboxHomeController);
      inboxHomeScreenWatch.disposeController(isNotify: true);
      inboxHomeScreenWatch.inboxHomeNotifier();
    });
  }

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: getWidth(16)),
        color: AppColors.black,
        child: Column(
          children: [
            // getVerticalHeight(20),
            getVerticalHeight(Platform.isAndroid ? 20 : 60),

            const InboxTopAppbarWidget().paddingOnly(bottom: 10.h),
            StreamBuilder<List<GroupDetailsResponseModel>>(
              stream: GroupChatManager.instance.getGroupsStream(Session.userId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final groups = snapshot.data!;

                if (groups.isEmpty) {
                  return SizedBox(
                    height: context.height * 0.8,
                    child: Center(
                      child: Text("You're not in any groups."),
                    ),
                  );
                }
                List<GroupDetailsResponseModel>? groupList = snapshot.data;
                return Expanded(
                  child: GroupListWidget(
                    groupList: groupList,
                  ).paddingOnly(bottom: 20.h),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
