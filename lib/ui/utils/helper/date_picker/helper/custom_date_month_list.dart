import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/framework/utils/extension/extension.dart';
import 'package:vista_flicks/ui/utils/anim/animation_extension.dart';

import '../../../../../framework/provider/network/network.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/text_style.dart';
import '../../base_widget.dart';
import '../calendar_controller.dart';

class CustomDateMonthList extends ConsumerStatefulWidget {
  const CustomDateMonthList({super.key});

  @override
  ConsumerState<CustomDateMonthList> createState() =>
      _CustomDateMonthListState();
}

class _CustomDateMonthListState extends ConsumerState<CustomDateMonthList>
    with SingleTickerProviderStateMixin, BaseConsumerStatefulWidget {
  AnimationController? _animController;
  late Animation<Offset> _offSetAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    if (_animController != null) {
      final curve =
          CurvedAnimation(curve: Curves.decelerate, parent: _animController!);
      _offSetAnim =
          Tween<Offset>(begin: const Offset(0, -0.1), end: const Offset(0, 0))
              .animate(curve);
      if (mounted) {
        if (!(_animController?.isDisposed ?? false)) {
          _animController?.forward().orCancel;
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animController?.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    final calendarWatch = ref.watch(calendarController);
    return _animController != null
        ? FadeTransition(
            opacity: _animController!,
            child: SlideTransition(
              position: _offSetAnim,
              child: GridView.builder(
                padding: EdgeInsets.zero,
                itemCount: calendarWatch.month.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Opacity(
                    opacity: calendarWatch.isMonthAvailable(index) ? 1 : 0.4,
                    child: InkWell(
                      onTap: () {
                        if (calendarWatch.isMonthAvailable(index)) {
                          calendarWatch.updateDisplayDate(
                              displayDate: DateTime(
                                  calendarWatch.displayDate.year,
                                  calendarWatch.month[index].month));
                          calendarWatch.updateWidgetDisplayed(
                              widgetDisplayed: WidgetDisplayed.day);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: calendarWatch.selectedMonth ==
                                      calendarWatch.month[index] &&
                                  calendarWatch.displayDate.year ==
                                      calendarWatch.selectedDate.year
                              ? AppColors.blue
                              : null,
                        ),
                        child: Text(
                          calendarWatch.month[index].monthName.substring(0, 3),
                          style: TextStyles.medium.copyWith(
                              fontSize: 16.5.sp,
                              color: calendarWatch.selectedMonth ==
                                          calendarWatch.month[index] &&
                                      calendarWatch.displayDate.year ==
                                          calendarWatch.selectedDate.year
                                  ? AppColors.white
                                  : AppColors.black),
                        ),
                      ),
                    ).paddingSymmetric(horizontal: 10.w, vertical: 8.h),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, mainAxisExtent: 0.08.sh),
              ),
            ),
          )
        : const Offstage();
  }
}
