import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:vista_flicks/ui/error/web/error_404_web.dart';

import '../utils/const/app_enums.dart';
import '../utils/helper/base_widget.dart';
import 'mobile/error_404_mobile.dart';

class Error extends StatelessWidget with BaseStatelessWidget {
  final ErrorType? errorType;

  const Error({super.key, this.errorType});

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return const Error404Mobile();
      },
      desktop: (BuildContext context) {
        return ErrorWeb(errorType: errorType);
      },
      tablet: (BuildContext context) {
        return OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return orientation == Orientation.landscape
                ? ErrorWeb(errorType: errorType)
                : const Error404Mobile();
          },
        );
      },
    );
  }
}
