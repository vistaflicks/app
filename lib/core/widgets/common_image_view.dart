// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vista_flicks/core/utils/config.dart';

class CommonImageView extends StatelessWidget {
  ///[url] is required parameter for fetching network image
  String? url;
  String? name;
  double? radius;
  String? imagePath;
  String? svgPath;
  String? svgUrl;
  File? file;
  double? height;
  double? width;
  BorderRadiusGeometry? borderRadius;
  Color? color;
  final BoxFit fit;
  final String placeHolder;

  ///a [CommonNetworkImageView] it can be used for showing any network images
  /// it will shows the placeholder image if image is not found on network
  CommonImageView({
    super.key,
    this.url,
    this.svgUrl,
    this.borderRadius,
    this.imagePath,
    this.svgPath,
    this.file,
    this.height,
    this.radius,
    this.name,
    this.width,
    this.color,
    this.fit = BoxFit.fill,
    this.placeHolder = Config.kNoImage,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(radius ?? 0),
      child: _buildImageView(),
    );
  }

  Widget _buildImageView() {
    if (svgUrl != null && svgUrl!.isNotEmpty) {
      return SizedBox(
        height: height,
        width: width,
        child: SvgPicture.network(
          svgUrl!,
          height: height,
          width: width,
          fit: fit,
          color: color,
        ),
      );
    } else if (svgPath != null && svgPath!.isNotEmpty) {
      return SizedBox(
        height: height,
        width: width,
        child: SvgPicture.asset(
          svgPath!,
          height: height,
          width: width,
          fit: fit,
          color: color,
        ),
      );
    } else if (file != null && file!.path.isNotEmpty) {
      return Image.file(
        file!,
        height: height,
        width: width,
        fit: fit,
        color: color,
      );
    } else if (url != null && url!.isNotEmpty) {
      return CachedNetworkImage(
        height: height,
        width: width,
        fit: fit,
        imageUrl: url!,
        errorWidget: (context, url, error) => Image.network(
          Config.kNoImage,
          height: height,
          width: width,
          fit: fit,
        ),
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Colors.white,
          child: SizedBox(
            height: height,
            width: width,
          ),
        ),
      );
    } else if (imagePath != null && imagePath!.isNotEmpty) {
      return Image.asset(
        imagePath!,
        height: height,
        width: width,
        color: color,
        fit: fit,
      );
    } else {
      return Image.asset(
        placeHolder,
        height: height,
        width: width,
        color: color,
        fit: fit,
      );
    }
    // return const SizedBox();
  }
}
