import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../const/app_constants.dart';
import '../helper/base_widget.dart';

class CacheImage extends StatelessWidget with BaseStatelessWidget {
  final String imageURL;
  final double? height;
  final double? topLeftRadius;
  final double? topRightRadius;
  final double? bottomLeftRadius;
  final double? bottomRightRadius;
  final double? width;
  final bool? setPlaceHolder;
  final String? placeholderImage;
  final BoxFit? boxFit;
  final BoxShape? shape;

  const CacheImage({
    super.key,
    required this.imageURL,
    this.height,
    this.width,
    this.setPlaceHolder = true,
    this.placeholderImage,
    this.boxFit,
    this.bottomLeftRadius,
    this.bottomRightRadius,
    this.topLeftRadius,
    this.topRightRadius,
    this.shape,
  });

  @override
  Widget buildPage(BuildContext context) {
    return (imageURL == '')
        ? placeHolderWidget(height: height, width: width)
        : CachedNetworkImage(
            imageUrl: imageURL,
            imageBuilder: (context, imageProvider) => Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(topLeftRadius ?? 0.0),
                  topRight: Radius.circular(topRightRadius ?? 0.0),
                  bottomRight: Radius.circular(bottomRightRadius ?? 0.0),
                  bottomLeft: Radius.circular(bottomLeftRadius ?? 0.0),
                ),
                image: DecorationImage(
                    image: imageProvider, fit: boxFit ?? BoxFit.fill),
              ),
            ),
            placeholder: (context, url) {
              return SizedBox(height: height, width: width);
              // return placeHolderWidget(height: height, width: width);
            },
            errorWidget: (context, url, error) =>
                placeHolderWidget(height: height, width: width),
          );
  }
}
