// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter_svg/svg.dart';

import '../../../framework/provider/network/network.dart';
import '../helper/base_widget.dart';
import 'cache_image.dart';

class CommonImage extends StatelessWidget with BaseStatelessWidget {
  final String strIcon;
  final ColorFilter? colorFilter;
  final Color? imgColor;
  final double? height;
  final double? width;
  final BoxFit? boxFit;
  final double? topLeftRadius;
  final double? topRightRadius;
  final double? bottomLeftRadius;
  final double? bottomRightRadius;
  final bool isFileImage;

  const CommonImage({
    super.key,
    required this.strIcon,
    this.imgColor,
    this.height,
    this.width,
    this.boxFit,
    this.colorFilter,
    this.bottomLeftRadius,
    this.bottomRightRadius,
    this.topLeftRadius,
    this.topRightRadius,
    this.isFileImage = false,
  });

  @override
  Widget buildPage(BuildContext context) {
    return isFileImage == true
        ? ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topLeftRadius ?? 0.0),
              topRight: Radius.circular(topRightRadius ?? 0.0),
              bottomRight: Radius.circular(bottomRightRadius ?? 0.0),
              bottomLeft: Radius.circular(bottomLeftRadius ?? 0.0),
            ),
            child: Image.file(
              File(strIcon),
              height: height,
              width: width,
              color: imgColor,
              fit: boxFit ?? BoxFit.scaleDown,
            ),
          )
        : strIcon.contains('http') || strIcon.contains('https')
            ? CacheImage(
                imageURL: strIcon,
                height: height,
                width: width,
                boxFit: boxFit ?? BoxFit.scaleDown,
                bottomLeftRadius: bottomLeftRadius,
                bottomRightRadius: bottomRightRadius,
                topLeftRadius: topLeftRadius,
                topRightRadius: topRightRadius,
              )
            : (strIcon.contains('.svg'))
                ? ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(topLeftRadius ?? 0.0),
                      topRight: Radius.circular(topRightRadius ?? 0.0),
                      bottomRight: Radius.circular(bottomRightRadius ?? 0.0),
                      bottomLeft: Radius.circular(bottomLeftRadius ?? 0.0),
                    ),
                    child: SvgPicture.asset(
                      strIcon,
                      colorFilter: colorFilter,
                      color: imgColor,
                      height: height,
                      width: width,
                      fit: boxFit ?? BoxFit.scaleDown,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(topLeftRadius ?? 0.0),
                      topRight: Radius.circular(topRightRadius ?? 0.0),
                      bottomRight: Radius.circular(bottomRightRadius ?? 0.0),
                      bottomLeft: Radius.circular(bottomLeftRadius ?? 0.0),
                    ),
                    child: Image.asset(
                      strIcon,
                      height: height,
                      width: width,
                      color: imgColor,
                      fit: boxFit ?? BoxFit.scaleDown,
                    ),
                  );
  }
}
