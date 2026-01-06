import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/framework/utils/extension/string_extension.dart';
import 'package:vista_flicks/ui/utils/helper/base_widget.dart';

import '../../../../../framework/provider/network/network.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_strings.g.dart';
import '../../../theme/text_style.dart';
import '../calendar_controller.dart';

class CustomDatePicketActionButtons extends ConsumerWidget
    with BaseConsumerWidget {
  final GestureTapCallback? onCancelTap;
  final GestureTapCallback? onOkTap;
  final Function(DateTime? selectedDate, {bool? isOkPressed}) getDateCallback;

  const CustomDatePicketActionButtons({
    super.key,
    this.onCancelTap,
    this.onOkTap,
    required this.getDateCallback,
  });

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        TextButton(
          onPressed: () {
            if (onCancelTap != null) {
              getDateCallback(null);
              onCancelTap?.call();
            }
            Navigator.pop(context);
          },
          child: Text(
            LocaleKeys.keyCancel.localized,
            style: TextStyles.medium
                .copyWith(fontSize: 14.sp, color: AppColors.blue),
          ),
        ),
        TextButton(
          onPressed: () {
            if (onOkTap != null) {
              // getDateCallback(ref.read(calendarController).selectedDate, isOkPressed: true);
              onOkTap?.call();
            }
            getDateCallback.call(ref.read(calendarController).selectedDate,
                isOkPressed: true);
            Navigator.pop(context);
          },
          child: Text(
            LocaleKeys.keyOk.localized,
            style: TextStyles.medium
                .copyWith(fontSize: 14.sp, color: AppColors.blue),
          ),
        ),
      ],
    );
  }
}
