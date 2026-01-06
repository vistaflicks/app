import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/ui/utils/helper/base_widget.dart';

import '../../../framework/provider/network/network.dart';
import '../theme/app_colors.dart';

class CommonCheckBox extends StatelessWidget with BaseStatelessWidget {
  const CommonCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.checkColor,
    this.shape,
    this.fillColor,
    this.selectedBorder,
    this.unSelectedBorder,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final Color? activeColor;
  final Color? checkColor;
  final Color? fillColor;
  final Color? selectedBorder;
  final Color? unSelectedBorder;
  final OutlinedBorder? shape;

  @override
  Widget buildPage(BuildContext context) {
    return Checkbox(
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(3.r),
                bottomRight: Radius.circular(3.r)),
          ),
      fillColor: MaterialStatePropertyAll(fillColor),
      activeColor: activeColor ?? AppColors.white,
      checkColor: checkColor ?? AppColors.black,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      side: MaterialStateBorderSide.resolveWith(
        (states) {
          if (states.contains(MaterialState.selected)) {
            return BorderSide(
                color: selectedBorder ?? AppColors.transparent, width: 1.w);
          } else {
            return BorderSide(
                color: selectedBorder ?? AppColors.transparent, width: 1.w);
          }
        },
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
