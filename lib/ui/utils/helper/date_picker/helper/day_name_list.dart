import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../framework/provider/network/network.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/text_style.dart';
import '../../base_widget.dart';
import '../calendar_controller.dart';

class DayNameList extends ConsumerWidget with BaseConsumerWidget {
  const DayNameList({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final calendarWatch = ref.watch(calendarController);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        calendarWatch.day.length,
        (index) => Container(
          // height: 0.04.h,
          // width: 0.05.w,

          height: 50.h,
          width: 50.w,
          alignment: Alignment.center,
          child: Text(
            calendarWatch.day[index].weekDayName.substring(0, 3),
            style: TextStyles.medium
                .copyWith(fontSize: 16.sp, color: AppColors.black),
          ),
        ),
      ),
    );
  }
}
