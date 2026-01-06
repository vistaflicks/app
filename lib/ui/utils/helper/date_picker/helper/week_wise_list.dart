import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../framework/provider/network/network.dart';
import '../../base_widget.dart';
import '../calendar_controller.dart';
import 'custom_date_list.dart';

class WeekWiseList extends ConsumerWidget with BaseConsumerWidget {
  final Function(DateTime? selectedDate, {bool? isOkPressed})? getDateCallback;
  final bool selectDateOnTap;

  const WeekWiseList({
    super.key,
    this.selectDateOnTap = false,
    this.getDateCallback,
  });

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final calendarWatch = ref.watch(calendarController);
    return calendarWatch.animationController == null
        ? const Offstage()
        : SlideTransition(
            position:
                calendarWatch.slideAnimation ?? calendarWatch.defaultAnimation,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                calendarWatch.dayWiseMonthlyList.length,
                (dayIndex) => CustomDateList(
                    dateList: calendarWatch.dayWiseMonthlyList[dayIndex],
                    getDateCallback: getDateCallback,
                    selectDateOnTap: selectDateOnTap),
              ),
            ),
          );
  }
}
