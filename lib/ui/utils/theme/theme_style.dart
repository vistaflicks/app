import 'package:vista_flicks/ui/utils/theme/text_style.dart';

import '../../../framework/provider/network/network.dart';
import 'app_colors.dart';

class ThemeStyle {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      fontFamily: TextStyles.fontFamily,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.scaffoldBGByTheme(),
      applyElevationOverlayColor: false,
      useMaterial3: true,
      hintColor: AppColors.grey,
      primarySwatch: AppColors.colorPrimary,
      textTheme:
          Theme.of(context).textTheme.apply(bodyColor: AppColors.textByTheme()),
      splashColor: AppColors.transparent,
      highlightColor: AppColors.transparent,
      cardColor: AppColors.white,
      cardTheme: const CardTheme(surfaceTintColor: AppColors.white),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        backgroundColor: AppColors.scaffoldBGByTheme(),
      ),
      colorScheme: ColorScheme.fromSwatch(primarySwatch: AppColors.colorPrimary)
          .copyWith(background: AppColors.scaffoldBGByTheme()),
    );
  }
}
