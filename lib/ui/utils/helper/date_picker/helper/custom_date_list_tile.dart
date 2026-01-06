import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/framework/utils/extension/extension.dart';

import '../../../../../framework/provider/network/network.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/text_style.dart';
import '../../base_widget.dart';
import '../calendar_controller.dart';

class CustomDateListTile extends ConsumerWidget with BaseConsumerWidget {
  final DateTime? currentDate;
  final bool selectDateOnTap;
  final Function(DateTime? selectedDate, {bool? isOkPressed})? getDateCallback;

  const CustomDateListTile({
    super.key,
    this.selectDateOnTap = false,
    this.getDateCallback,
    required this.currentDate,
  });

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final calendarWatch = ref.watch(calendarController);
    bool isDateSelected =
        (calendarWatch.selectedDate.day == currentDate?.day) &&
            (calendarWatch.selectedDate.month == currentDate?.month) &&
            (calendarWatch.selectedDate.year == currentDate?.year);
    return InkWell(
      onTap: () {
        if (currentDate != null) {
          calendarWatch.updateSelectedDate(selectedDate: currentDate!);
        }
      },
      child: Opacity(
        opacity: calendarWatch.isDateAvailable(currentDate) ? 1 : 0.4,
        child: Container(
          alignment: Alignment.center,
          height: 35.h,
          width: 35.w,
          decoration: isDateSelected
              ? const BoxDecoration(
                  color: AppColors.blue, shape: BoxShape.circle)
              : null,
          child: currentDate != null
              ? Text(
                  currentDate!.day.toString(),
                  style: TextStyles.medium.copyWith(
                      fontSize: 16.sp,
                      color:
                          isDateSelected ? AppColors.white : AppColors.black),
                ).paddingAll(5.r)
              : const Offstage(),
        ),
      ),
    );
  }
}
