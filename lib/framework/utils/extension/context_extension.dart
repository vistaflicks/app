import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

extension ContextExtension on BuildContext {
  double get width => MediaQuery.sizeOf(this).width;

  double get height => MediaQuery.sizeOf(this).height;

  DeviceScreenType get deviceType => getDeviceType(
        MediaQuery.of(this).size,
        const ScreenBreakpoints(desktop: 1000, tablet: 799, watch: 100),
      );

  bool get isMobileScreen => deviceType == DeviceScreenType.mobile;

  bool get isWebScreen => deviceType == DeviceScreenType.desktop;

  bool get isTablet => deviceType == DeviceScreenType.tablet;

  void get hideKeyboard => FocusScope.of(this).unfocus();

  void get nextField => FocusScope.of(this).nextFocus();
}
