import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/framework/utils/extension/context_extension.dart';
import 'package:vista_flicks/framework/utils/extension/extension.dart';

import '../../../../framework/provider/network/network.dart';
import '../../theme/app_colors.dart';
import '../base_widget.dart';
import 'custom_date_picker.dart';

class ShowDatePicketWidgetWeb extends ConsumerWidget with BaseConsumerWidget {
  final Widget dateWidget;
  final bool isStartDate;
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime? selectedDate, {bool? isOkPressed}) getDateCallback;
  final Function updateIsDatePickerVisible;
  GlobalKey? calanderKey;

  ShowDatePicketWidgetWeb(
      {super.key,
      required this.dateWidget,
      required this.isStartDate,
      required this.startDate,
      required this.endDate,
      required this.updateIsDatePickerVisible,
      required this.getDateCallback,
      this.calanderKey});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    // final orderListWatch = ref.watch(serviceHistoryController);
    return PopupMenuButton(
      surfaceTintColor: AppColors.transparent,
      color: AppColors.white,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints.expand(
        width: context.width * 0.5,
        height: context.height * 0.55,
      ),
      enabled: true,
      //enabled: (isStartDate == false ? orderListWatch.startDate != null : true),
      tooltip: '',
      clipBehavior: Clip.hardEdge,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.r),
        ),
      ),
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry>[
          PopupMenuItem(
            key: calanderKey,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: CustomDatePicker(
                selectDateOnTap: true,
                width: context.width * 0.5,
                height: context.height * 0.5,
                bubbleDirection: isStartDate,
                //    bubbleColor: AppColors.white,
                initialDate: isStartDate ? startDate : endDate,
                firstDate: isStartDate
                    ? DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day - 30)
                    : startDate,
                lastDate: DateTime.now(),
                getDateCallback: getDateCallback,
                onOkTap: () {
                  updateIsDatePickerVisible();
                  // orderListWatch.updateIsDatePickerVisible(false);
                },
                onCancelTap: () {
                  updateIsDatePickerVisible();
                  // orderListWatch.updateIsDatePickerVisible(false);
                },
              ).paddingSymmetric(horizontal: 15.w),
            ),
          ),
        ];
      },
      offset: Offset(0, context.height * 0.08),
      child: dateWidget,
    );
  }
}
