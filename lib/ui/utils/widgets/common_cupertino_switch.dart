import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/ui/utils/helper/base_widget.dart';

import '../theme/app_colors.dart';

class CommonCupertinoSwitch extends StatelessWidget with BaseStatelessWidget {
  const CommonCupertinoSwitch({
    super.key,
    required this.switchValue,
    required this.onChanged,
  });

  /// Switch Value
  final bool switchValue;

  /// On changed switch value
  final ValueChanged<bool> onChanged;

  @override
  Widget buildPage(BuildContext context) {
    return SizedBox(
      height: 22.h,
      child: FittedBox(
        fit: BoxFit.contain,
        child: CupertinoSwitch(
          value: switchValue,
          activeColor: AppColors.green,
          trackColor: AppColors.blackLight,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
