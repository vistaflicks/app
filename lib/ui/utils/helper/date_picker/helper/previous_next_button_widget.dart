import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/framework/utils/extension/extension.dart';

import '../../../../../framework/provider/network/network.dart';
import '../../../theme/app_colors.dart';
import '../../base_widget.dart';
import '../calendar_controller.dart';

class PreviousNextButtonWidget extends StatelessWidget
    with BaseStatelessWidget {
  const PreviousNextButtonWidget({super.key});

  @override
  Widget buildPage(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final calendarWatch = ref.watch(calendarController);
        return Row(
          children: [
            Opacity(
              opacity: calendarWatch.isPreviousButtonVisible() ? 1 : 0,
              child: InkWell(
                onTap: () {
                  calendarWatch.goToPreviousMonth();
                },
                child: const Icon(
                  CupertinoIcons.left_chevron,
                  color: AppColors.blue,
                ),
              ).paddingAll(5.w),
            ),
            SizedBox(width: 10.w),
            Opacity(
              opacity: calendarWatch.isForwardButtonVisible() ? 1 : 0,
              child: InkWell(
                onTap: () {
                  calendarWatch.goToNextMonth();
                },
                child: const Icon(
                  CupertinoIcons.right_chevron,
                  color: AppColors.blue,
                ),
              ).paddingAll(5.w),
            ),
          ],
        );
      },
    );
  }
}
