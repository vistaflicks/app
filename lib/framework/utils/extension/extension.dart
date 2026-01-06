import 'dart:ui' as ui show WindowPadding;

import 'package:flutter/material.dart';

part 'align_extension.dart';
part 'padding_extension.dart';

extension StringCasingExtension on String {
  String capitalizeFirst() {
    if (isEmpty) return '';
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}
