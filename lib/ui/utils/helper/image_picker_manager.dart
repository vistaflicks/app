import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vista_flicks/framework/utils/extension/extension.dart';
import 'package:vista_flicks/framework/utils/extension/string_extension.dart';
import 'package:vista_flicks/ui/utils/widgets/common_text.dart';

import '../../../framework/provider/network/network.dart';
import '../../../gen/assets.gen.dart';
import '../const/app_constants.dart';
import '../theme/app_colors.dart';
import '../theme/app_strings.g.dart';
import '../theme/text_style.dart';
import '../widgets/common_image.dart';
// import 'package:wechat_assets_picker/wechat_assets_picker.dart';

/*
Required permissions for iOS
NSCameraUsageDescription :- ${PRODUCT_NAME} is require camera permission to choose user profile photo.
NSPhotoLibraryUsageDescription :- ${PRODUCT_NAME} is require photos permission to choose user profile photo.

Required permissions for Android
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.CAMERA"/>

<!--Image Cropper-->
       <activity
           android:name="com.yalantis.ucrop.UCropActivity"
           android:exported="true"
           android:screenOrientation="portrait"
           android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>
* */

class ImagePickerManager {
  ImagePickerManager._privateConstructor();

  static final ImagePickerManager instance =
      ImagePickerManager._privateConstructor();

  final ImagePicker picker = ImagePicker();
  final ImageCropper cropper = ImageCropper();

  var imgSelectOption = {
    LocaleKeys.keyCamera.localized,
    LocaleKeys.keyGallery.localized,
    LocaleKeys.keyDocument.localized,
    LocaleKeys.keyVideo.localized,
    LocaleKeys.keyImage.localized,
  };

  /*
  Open Picker
  Usage:- File? file = await ImagePickerManager.instance.openPicker(context);
  * */

  Future<FileResult?> openPicker(
    BuildContext context, {
    String? title,
    double? ratioX,
    double? ratioY,
    CropStyle? cropStyle,
    Function? onRemoveCallBack,
  }) async {
    await Permission.camera.request();
    String type = '';
    String subType = '';
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.black.withOpacity(0.3),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, state) {
            return Container(
              margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, -4),
                    blurRadius: 12.r,
                    spreadRadius: 0,
                    color: AppColors.black.withOpacity(0.12),
                  ),
                  BoxShadow(
                    offset: const Offset(0, 4),
                    blurRadius: 12.r,
                    spreadRadius: 0,
                    color: AppColors.black.withOpacity(0.10),
                  ),
                ],
              ),
              padding: EdgeInsets.only(left: 29.w, right: 29.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      /// Camera
                      GestureDetector(
                        onTap: () async {
                          subType = LocaleKeys.keyImage.localized;
                          final cameraPermission =
                              await Permission.camera.status;
                          showLog('cameraPermission $cameraPermission');
                          if (cameraPermission == PermissionStatus.granted) {
                            type = LocaleKeys.keyCamera.localized;
                          } else {
                            commonToaster(LocaleKeys
                                .keyCameraPermissionNotGranted.localized);
                          }
                          Navigator.pop(context);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CommonImage(
                              strIcon: Assets.icons.svgPickFromCamera,
                              height: 40.h,
                              width: 40.h,
                              boxFit: BoxFit.scaleDown,
                              imgColor: AppColors.primary,
                            ),
                            CommonText(
                              title: LocaleKeys.keyCamera.localized,
                              textStyle: TextStyles.regular.copyWith(
                                color: AppColors.primary,
                                fontSize: 13.sp,
                              ),
                            ).paddingOnly(top: 10.h),
                          ],
                        ),
                      ),
                      // PopupMenuButton(
                      //   itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      //     PopupMenuItem(
                      //       onTap: () async {
                      //         subType = LocaleKeys.keyImage.localized;
                      //         final cameraPermission =
                      //             await Permission.camera.status;
                      //         showLog('cameraPermission $cameraPermission');
                      //         if (cameraPermission ==
                      //             PermissionStatus.granted) {
                      //           type = LocaleKeys.keyCamera.localized;
                      //         } else {
                      //           commonToaster(LocaleKeys
                      //               .keyCameraPermissionNotGranted.localized);
                      //         }
                      //         Navigator.pop(context);
                      //       },
                      //       child: Text(LocaleKeys.keyImage.localized),
                      //     ),
                      //     if (onRemoveCallBack == null)
                      //       PopupMenuItem(
                      //         onTap: () async {
                      //           subType = LocaleKeys.keyVideo.localized;
                      //           final cameraPermission =
                      //               await Permission.camera.status;
                      //           showLog('cameraPermission $cameraPermission');
                      //           if (cameraPermission ==
                      //               PermissionStatus.granted) {
                      //             type = LocaleKeys.keyCamera.localized;
                      //           } else {
                      //             commonToaster(LocaleKeys
                      //                 .keyCameraPermissionNotGranted.localized);
                      //           }
                      //           Navigator.pop(context);
                      //         },
                      //         child: Text(LocaleKeys.keyVideo.localized),
                      //       ),
                      //   ],
                      //   child: commonImageTitleWidget(
                      //       Assets.icons.svgPickFromCamera,
                      //       LocaleKeys.keyCamera.localized,
                      //       null),
                      // ),

                      /// Gallery

                      GestureDetector(
                        onTap: () async {
                          subType = LocaleKeys.keyImage.localized;
                          type = LocaleKeys.keyGallery.localized;
                          Navigator.pop(context);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CommonImage(
                              strIcon: Assets.icons.svgPickFromGallery,
                              height: 40.h,
                              width: 40.h,
                              boxFit: BoxFit.scaleDown,
                              imgColor: AppColors.primary,
                            ),
                            CommonText(
                              title: LocaleKeys.keyGallery.localized,
                              textStyle: TextStyles.regular.copyWith(
                                color: AppColors.primary,
                                fontSize: 13.sp,
                              ),
                            ).paddingOnly(top: 10.h),
                          ],
                        ),
                      ),
                      // PopupMenuButton(
                      //   itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      //     PopupMenuItem(
                      //       onTap: () async {
                      //         subType = LocaleKeys.keyImage.localized;
                      //         type = LocaleKeys.keyGallery.localized;
                      //         Navigator.pop(context);
                      //       },
                      //       child: Text(LocaleKeys.keyImage.localized),
                      //     ),
                      //     if (onRemoveCallBack == null)
                      //       PopupMenuItem(
                      //         onTap: () async {
                      //           subType = LocaleKeys.keyVideo.localized;
                      //           type = LocaleKeys.keyGallery.localized;
                      //           Navigator.pop(context);
                      //         },
                      //         child: Text(LocaleKeys.keyVideo.localized),
                      //       ),
                      //   ],
                      //   child: commonImageTitleWidget(
                      //       Assets.icons.svgPickFromGallery,
                      //       LocaleKeys.keyGallery.localized,
                      //       null),
                      // ),

                      /// Document
                      if (onRemoveCallBack == null)
                        commonImageTitleWidget(Assets.icons.svgPickDocument,
                            LocaleKeys.keyDocument.localized, () {
                          type = LocaleKeys.keyDocument.localized;
                          Navigator.pop(context);
                        }),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: double.infinity,
                            height: 50.h,
                            decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(10.r)),
                            alignment: Alignment.center,
                            child: Text(
                              LocaleKeys.keyCancel.localized,
                              style: TextStyles.semiBold
                                  .copyWith(color: AppColors.redLight),
                            ),
                          ),
                        ),
                      ),
                      // if (onRemoveCallBack != null) SizedBox(width: 10.w),
                      // Visibility(
                      //   visible: onRemoveCallBack != null,
                      //   child: Expanded(
                      //     child: InkWell(
                      //       onTap: () {
                      //         Navigator.pop(context);
                      //         onRemoveCallBack?.call();
                      //       },
                      //       child: Container(
                      //         width: double.infinity,
                      //         height: 50.h,
                      //         decoration: BoxDecoration(
                      //             color: AppColors.white,
                      //             borderRadius: BorderRadius.circular(10.r)),
                      //         alignment: Alignment.center,
                      //         child: Text(
                      //           LocaleKeys.keyRemove.localized,
                      //           style: TextStyles.semiBold.copyWith(
                      //               color: AppColors.secondaryPrimary),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    File? croppedFile;
    if (type.isNotEmpty) {
      /// Document
      if (type == LocaleKeys.keyDocument.localized) {
        FilePickerResult? result = await FilePicker.platform.pickFiles();

        if (result != null) {
          List<File> files = result.paths.map((path) => File(path!)).toList();
          if (files.isNotEmpty) {
            croppedFile = files.first;
          }
        } else {
          commonToaster('Canceled by used');
        }
      }

      /// Camera
      else if (type == LocaleKeys.keyCamera.localized) {
        XFile? pickedFile = (subType == LocaleKeys.keyImage.localized)
            ? await picker.pickImage(
                source: ImageSource.camera,
              )
            : await picker.pickVideo(
                source: ImageSource.camera,
              );

        showLog('pickedFile At Camera: $pickedFile');

        if (pickedFile != null &&
            pickedFile.path != '' &&
            subType == LocaleKeys.keyImage.localized) {
          CroppedFile? cropImage =
              (await cropper.cropImage(sourcePath: pickedFile.path));

          if (cropImage != null && cropImage.path != '') {
            croppedFile = File(cropImage.path);
          }
        } else if (pickedFile != null &&
            pickedFile.path != '' &&
            subType == LocaleKeys.keyVideo.localized) {
          croppedFile = File(pickedFile.path);
        }
      } else if (type == LocaleKeys.keyGallery.localized) {
        XFile? pickedFile = (subType == LocaleKeys.keyImage.localized)
            ? await picker.pickImage(
                source: ImageSource.gallery,
              )
            : await picker.pickVideo(
                source: ImageSource.gallery,
              );

        showLog('pickedFile At Gallery: $pickedFile');

        if (pickedFile != null &&
            pickedFile.path != '' &&
            subType == LocaleKeys.keyImage.localized) {
          CroppedFile? cropImage = (await cropper.cropImage(
            sourcePath: pickedFile.path,
          ));

          if (cropImage != null && cropImage.path != '') {
            croppedFile = File(cropImage.path);
          }
        } else if (pickedFile != null &&
            pickedFile.path != '' &&
            subType == LocaleKeys.keyVideo.localized) {
          croppedFile = File(pickedFile.path);
        }
      }
      // showLog('croppedFile $croppedFile');
      // showLog('type $type');
      // showLog('type $subType');
      return FileResult(
          file: croppedFile!, fileType: getFileType(type, subType));
    } else {}
    return null;
  }

  getFileType(String type, String subtype) {
    if (type == LocaleKeys.keyCamera.localized) {
      return subtype;
    } else if (type == LocaleKeys.keyGallery.localized) {
      return subtype;
    } else {
      return type;
    }
  }

  /*
  Open Multi Picker
  Usage:- Future<List<File>?> files = ImagePickerManager.instance.openMultiPicker(context);
  * */
  // Future<List<File>?> openMultiPicker(BuildContext context, RequestType type, {int maxAssets = 1}) async {
  //   final List<AssetEntity>? result = await AssetPicker.pickAssets(
  //     context,
  //     pickerConfig: AssetPickerConfig(
  //       maxAssets: maxAssets,
  //       themeColor: AppColors.primary,
  //       requestType: type,
  //     ),
  //   );
  //
  //   List<File> files = [];
  //   if ((result ?? []).isNotEmpty) {
  //     for (final AssetEntity entity in result!) {
  //       final File? file = await entity.file;
  //       files.add(file!);
  //     }
  //   }
  //
  //   return files;
  // }

  Future<int> openMultipleImagePicker(BuildContext context,
      {String? title}) async {
    String str = '';

    await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor: AppColors.black.withOpacity(0.3),
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, state) {
            return Container(
              color: AppColors.transparent,
              padding: EdgeInsets.only(left: 29.w, right: 29.w),
              height: 225.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10.r)),
                    child: Column(
                      children: [
                        Visibility(
                          visible: title != null && title.isNotEmpty,
                          child: Padding(
                            padding: EdgeInsets.only(top: 20.h, bottom: 5.h),
                            child: Text(
                              title ?? ''.localized,
                              maxLines: 2,
                              style:
                                  TextStyles.medium.copyWith(fontSize: 18.sp),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            str = imgSelectOption.elementAt(0);
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 30.h, bottom: 15.h),
                            alignment: Alignment.center,
                            child: Text(
                              LocaleKeys.keyCamera.localized,
                              style: TextStyles.medium
                                  .copyWith(color: AppColors.primary),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20.w, right: 20.w),
                          child: const Divider(
                            height: 1,
                            color: AppColors.greyLight,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            str = imgSelectOption.elementAt(1);
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 15.h, bottom: 30.h),
                            alignment: Alignment.center,
                            child: Text(
                              LocaleKeys.keyGallery.localized,
                              style: TextStyles.medium
                                  .copyWith(color: AppColors.primary),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50.h,
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10.r)),
                      alignment: Alignment.center,
                      child: Text(
                        LocaleKeys.keyCancel.localized,
                        style: TextStyles.semiBold
                            .copyWith(color: AppColors.redLight),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        });
    return str == 'camera' ? 0 : (str == 'gallery' ? 1 : -1);
  }

  /// Common Image Title widget
  commonImageTitleWidget(String image, String title, Function? onTap) {
    return IgnorePointer(
      ignoring: onTap == null,
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            onTap.call();
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonImage(
              strIcon: image,
              height: 40.h,
              width: 40.h,
              boxFit: BoxFit.scaleDown,
              imgColor: AppColors.primary,
            ),
            CommonText(
              title: title,
              textStyle: TextStyles.regular.copyWith(
                color: AppColors.primary,
                fontSize: 13.sp,
              ),
            ).paddingOnly(top: 10.h),
          ],
        ),
      ),
    );
  }

  ///Handle Document After Picker
// handleDocumentAfterPicker(BuildContext context, Function(List<File>) resultBlock) async {
//   List<File> files = [];
//   FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true,type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx'],);
//
//   if(result != null) {
//     // files = result.paths.map((path) => PickedFile(path ?? "")).toList();
//     files = result.paths.map((path) => File(path ?? "")).toList();
//   }
//   resultBlock(files);
// }
}

class FileResult {
  final File file;
  final String fileType;

  FileResult({required this.file, required this.fileType});
}
