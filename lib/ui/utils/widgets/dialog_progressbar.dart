import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/theme.dart';

class DialogProgressBar extends StatelessWidget {
  final bool isLoading;
  final bool forPagination;

  const DialogProgressBar({
    super.key,
    required this.isLoading,
    this.forPagination = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!(isLoading)) {
      return const Offstage();
    } else {
      if ((forPagination)) {
        return SizedBox(
          height: 70.h,
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
            ),
          ),
        );
      } else {
        return AbsorbPointer(
          absorbing: true,
          child: Container(
            color: AppColors.black.withOpacity(0.5),
            width: MediaQuery.of(context).size.width,
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: SizedBox(
                  child: CircularProgressIndicator(color: AppColors.white),
                ),
              ),
            ),
          ),
        );
      }
    }
  }
}
