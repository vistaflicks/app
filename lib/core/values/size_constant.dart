import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

getHeight(double height) {
  return height.h;
}

getWidth(double width) {
  return width.w;
}

getRadious(double redius) {
  return redius.r;
}

getFontSize(size) {
  return size.sp;
}

Widget getVerticalHeight(double height) {
  return SizedBox(
    height: getHeight(height),
  );
}

Widget getHorizonatlWidth(double width) {
  return SizedBox(
    width: getWidth(width),
  );
}

const Duration commonDuration = Duration(milliseconds: 500);
