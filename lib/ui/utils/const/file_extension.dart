import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

extension FileExtension on File {

  // double getFileSizeInMB() {
  //   int sizeInBytes = lengthSync();
  //   double sizeInMb = sizeInBytes / (1024 * 1024);
  //   return sizeInMb;
  // }
  ///Usage:- fileObject.testCompressAndGetFile().then((value) {fileObject = value});
  Future<File> compressFile({int percentage = 40}) async {
    final int lastIndex = path.lastIndexOf(RegExp(r'.jp'));
    final String split = path.substring(0, lastIndex);
    final String targetPath = '${split}_out${path.substring(lastIndex)}';
    final result = await FlutterImageCompress.compressAndGetFile(
        absolute.path, targetPath,
        quality: percentage,
        minWidth: 600,
        minHeight: 300
    );
    return File(result!.path);
  }


}