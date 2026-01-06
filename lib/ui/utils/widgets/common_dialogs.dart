import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/framework/utils/extension/context_extension.dart';
import 'package:vista_flicks/framework/utils/extension/extension.dart';
import 'package:vista_flicks/framework/utils/extension/string_extension.dart';

import '../../../core/values/app_colours.dart';
import '../../../framework/provider/network/network.dart';
import '../../../framework/utils/local_storage/session.dart';
import '../anim/fade_box_transition.dart';
import '../theme/app_strings.g.dart';
import '../theme/text_style.dart';
import 'common_button.dart';
import 'common_image.dart';
import 'common_text.dart';

void showSuccessDialogue({
  required BuildContext context,
  required String strIcon,
  required String successMessage,
  String? successDescription,
  required String buttonText,
  void Function()? onTap,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return FadeBoxTransition(
        child: Dialog(
          elevation: 0.0,
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          backgroundColor: AppColors.primeryTxt,
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.98,
            child: Consumer(
              builder: (context, ref, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 40.h),
                    if (strIcon != '')
                      CommonImage(
                        strIcon: strIcon,
                        height: 105.h,
                        width: 105.h,
                        boxFit: BoxFit.fitWidth,
                      ).paddingOnly(bottom: 48.h),
                    if (successMessage != '')
                      Text(
                        successMessage,
                        textAlign: TextAlign.center,
                        style: TextStyles.medium
                            .copyWith(fontSize: 18.sp, color: AppColors.black),
                      ).paddingOnly(bottom: 12.h),
                    if (successDescription?.isNotEmpty ?? false)
                      Text(
                        successDescription!,
                        textAlign: TextAlign.center,
                        style: TextStyles.medium
                            .copyWith(color: AppColors.primeryTxt),
                      ).paddingOnly(bottom: 40.h),
                    CommonButton(
                      buttonText: buttonText,
                      buttonTextStyle: TextStyles.regular
                          .copyWith(color: AppColors.primeryTxt),
                      height: 50.h,
                      width: 200.w,
                      buttonEnabledColor: AppColors.red,
                      isButtonEnabled: true,
                      onTap: onTap,
                    ),
                    SizedBox(height: 40.h),
                  ],
                );
              },
            ),
          ),
        ),
      );
    },
  );
}

/// Confirmation dialog  message
showConfirmationDialog(
  BuildContext context,
  String title,
  String message,
  String btn1Name,
  String btn2Name,
  Function(bool isPositive) didTakeAction,
) {
  return showDialog(
      barrierDismissible: true,
      context: context,
      barrierColor: AppColors.lightGray1.withOpacity(0.5),
      builder: (context) => FadeBoxTransition(
            child: Dialog(
              backgroundColor: AppColors.black,
              surfaceTintColor: AppColors.black,
              insetPadding: EdgeInsets.all(16.sp),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r)),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        left: 16.w, right: 16.w, top: 22.h, bottom: 15.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        message == ''
                            ? SizedBox(height: 20.h)
                            : const SizedBox(),
                        CommonText(
                          title: title,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          textStyle: TextStyles.semiBold.copyWith(
                            color: AppColors.primeryTxt,
                            fontSize: 18.sp,
                          ),
                        ),
                        message != ''
                            ? SizedBox(height: 10.h)
                            : const SizedBox(),
                        CommonText(
                          title: message,
                          maxLines: 100,
                          textAlign: TextAlign.center,
                          textStyle: TextStyles.regular.copyWith(
                            color: AppColors.primeryTxt.withOpacity(0.8),
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CommonButton(
                                width: 139.w,
                                height: 49.h,
                                isButtonEnabled: true,
                                buttonText: btn1Name,
                                borderRadius: BorderRadius.circular(30.r),
                                borderWidth: 1.w,
                                onTap: () {
                                  Navigator.pop(context);
                                  Future.delayed(
                                      const Duration(milliseconds: 80), () {
                                    didTakeAction(true);
                                  });
                                },
                                borderColor: AppColors.black,
                                buttonEnabledColor: AppColors.primeryTxt,
                                buttonTextColor: AppColors.lightGray1),
                            SizedBox(width: 15.w),
                            CommonButton(
                                buttonText: btn2Name,
                                width: 139.w,
                                height: 49.h,
                                borderWidth: 1.w,
                                isButtonEnabled: true,
                                borderRadius: BorderRadius.circular(30.r),
                                onTap: () {
                                  Navigator.pop(context);
                                  Future.delayed(
                                      const Duration(milliseconds: 80), () {
                                    didTakeAction(false);
                                  });
                                },
                                borderColor: AppColors.black,
                                buttonEnabledColor: AppColors.lightGray1,
                                buttonTextColor: AppColors.primeryTxt),
                          ],
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
}

showSuccessDialog(
  BuildContext context,
  String title,
  String message,
  Function()? didDismiss, {
  IconData? icon,
}) {
  final navigator = Navigator.of(context, rootNavigator: true);

  if (didDismiss != null) {
    Future.delayed(const Duration(seconds: 2), () {
      navigator.pop();
      didDismiss.call();
    });
  }
  return showDialog(
    barrierDismissible: false,
    context: context,
    barrierColor: AppColors.black.withOpacity(0.8),
    builder: (context) => FadeBoxTransition(
      child: Dialog(
        backgroundColor: AppColors.primeryTxt,
        surfaceTintColor: AppColors.primeryTxt,
        insetPadding: EdgeInsets.all(16.sp),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon ?? Icons.check_circle,
                size: 120.sp,
                color: AppColors.green,
              ).paddingOnly(bottom: 20.h),
              title != ''
                  ? CommonText(
                      title: title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      textStyle: TextStyles.semiBold.copyWith(
                        color: AppColors.black,
                        fontSize: 22.sp,
                      ),
                    ).paddingOnly(bottom: 20.h)
                  : const Offstage(),
              CommonText(
                title: message,
                textAlign: TextAlign.center,
                maxLines: 10,
                textStyle: TextStyles.medium.copyWith(
                  color: AppColors.black.withOpacity(0.8),
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    ),
  );
}

showCommonWebDialog({
  key,
  required BuildContext context,
  required Widget dialogBody,
  double? width,
  bool? barrierDismissible,
  double? height,
}) {
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible ?? false,
    builder: (context) {
      return FadeBoxTransition(
        child: Dialog(
          key: key,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primeryTxt,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(30.r),
            ),
            width: width ?? context.width * 0.5,
            height: height ?? context.height * 0.6,
            child: dialogBody,
          ),
        ),
      );
    },
  );
}

GlobalKey errorDialogKey = GlobalKey();

showCommonErrorDialog({
  required BuildContext context,
  required String message,
  TextStyle? textStyle,
  Function()? onButtonTap,
  double? height,
  double? width,
}) {
  if (errorDialogKey.currentState == null &&
      errorDialogKey.currentContext == null) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return FadeBoxTransition(
          child: AlertDialog(
            key: errorDialogKey,
            backgroundColor: Colors.white,
            insetPadding: const EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Builder(
              builder: (BuildContext context) {
                return SizedBox(
                  width: width ?? context.width * 0.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Wrap(
                        children: [
                          Text(
                            message,
                            style: textStyle ??
                                TextStyles.medium.copyWith(
                                  color: AppColors.primeryTxt,
                                  fontSize: 16.sp,
                                ),
                            maxLines: 10,
                            textAlign: TextAlign.center,
                          )
                        ],
                      ).paddingOnly(bottom: 30),
                      CommonButton(
                        height: 45,
                        width: 100,
                        buttonText: LocaleKeys.keyOk.localized,
                        isButtonEnabled: true,
                        onTap: onButtonTap ??
                            () {
                              Navigator.of(context).pop();
                            },
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

showLoadingDialogWeb({
  GlobalKey? key,
  required BuildContext context,
  required String title,
  bool isDismissible = true,
  String message = '',
  double? dialogWidth,
  double? titleFontSize,
  double? messageFontSize,
  bool? isLoading,
}) {
  return showDialog(
    barrierDismissible: isDismissible,
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        key: key,
        backgroundColor: AppColors.primeryTxt,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: SizedBox(
          width: dialogWidth,
          height: context.height * 0.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: context.height * 0.01),
              if (title.isNotEmpty)
                CommonText(
                  title: title,
                  fontSize: context.height * 0.026,
                  clrfont: AppColors.black,
                  textAlign: TextAlign.center,
                ),
              if (message.isNotEmpty)
                CommonText(
                  title: message,
                  fontSize: context.height * 0.020,
                  clrfont: AppColors.black,
                  maxLines: 5,
                  textAlign: TextAlign.center,
                ),
              SizedBox(height: context.height * 0.005),
              const CircularProgressIndicator(color: AppColors.black),
            ],
          ).paddingSymmetric(
            horizontal: context.width * 0.030,
            vertical: context.height * 0.030,
          ),
        ),
      );
    },
  );
}

/// Widget Dialog
showWidgetDialog(
  BuildContext context,
  Widget? widget,
  Function()? didDismiss, {
  bool isDismissDialog = false,
  int autoDismissTimer = 0,
  GlobalKey? dialogKey,
}) {
  showDialog(
    barrierDismissible: isDismissDialog,
    context: context,
    barrierColor: AppColors.black.withOpacity(0.8),
    builder: (context) => FadeBoxTransition(
      child: Dialog(
        key: dialogKey,
        surfaceTintColor: AppColors.black,
        backgroundColor: AppColors.black,
        insetPadding: EdgeInsets.all(10.sp),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(20.r)),
        ),
        child: Wrap(
          children: [
            // const Align(
            //   alignment: Alignment.topRight,
            //   child: CloseButton(),
            // ),
            widget!
          ],
        ),
      ),
    ),
  );

  if (autoDismissTimer > 0) {
    Future.delayed(Duration(seconds: autoDismissTimer), () {
      if (didDismiss != null) {
        didDismiss();
      }
    });
  } else {
    if (isDismissDialog) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        didDismiss!();
      });
    }
  }
}

/// Image Viewer Dialog
showImageViewerDialog(
  BuildContext context,
  Widget? widget,
  Function()? didDismiss, {
  bool isDismissDialog = false,
  int autoDismissTimer = 0,
  GlobalKey? dialogKey,
}) {
  showDialog(
    barrierDismissible: isDismissDialog,
    context: context,
    barrierColor: AppColors.black.withOpacity(0.8),
    builder: (context) => FadeBoxTransition(
      child: Dialog(
        key: dialogKey,
        surfaceTintColor: AppColors.primeryTxt,
        backgroundColor: AppColors.primeryTxt,
        insetPadding: EdgeInsets.all(10.sp),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: Alignment.topRight,
              child: CloseButton(),
            ),
            InteractiveViewer(child: widget!),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    ),
  );

  if (autoDismissTimer > 0) {
    Future.delayed(Duration(seconds: autoDismissTimer), () {
      if (didDismiss != null) {
        didDismiss();
      }
    });
  } else {
    if (isDismissDialog) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        didDismiss!();
      });
    }
  }
}

/// Message Dialog
showMessageDialog(BuildContext context, String message, Function()? didDismiss,
    {String? title}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    barrierColor: AppColors.black.withOpacity(0.8),
    builder: (context) => FadeBoxTransition(
      child: Dialog(
        backgroundColor: AppColors.primeryTxt,
        surfaceTintColor: AppColors.primeryTxt,
        insetPadding: EdgeInsets.all(16.sp),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              title != null
                  ? CommonText(
                      title: title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      textStyle: TextStyles.bold
                          .copyWith(color: AppColors.black, fontSize: 22.sp),
                    ).paddingOnly(bottom: 10.h)
                  : const Offstage(),
              CommonText(
                title: message,
                textAlign: TextAlign.center,
                maxLines: 5,
                textStyle: TextStyles.medium.copyWith(
                    color: AppColors.black.withOpacity(0.8), fontSize: 14.sp),
              ),
              SizedBox(height: 20.h),
              CommonButton(
                buttonTextColor: AppColors.primeryTxt,
                isButtonEnabled: true,
                buttonEnabledColor: AppColors.red,
                borderColor: AppColors.red,
                width: 150.w,
                buttonText: LocaleKeys.keyOk.localized,
                onTap: () {
                  Navigator.pop(context);
                  if (didDismiss != null) {
                    Future.delayed(
                      const Duration(milliseconds: 80),
                      () {
                        didDismiss();
                      },
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    ),
  );
}

/// Login Dialog
showLoginDialog(BuildContext context, String message, Function()? didDismiss,
    {String? title}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    barrierColor: AppColors.black.withOpacity(0.8),
    builder: (context) => FadeBoxTransition(
      child: Dialog(
        backgroundColor: AppColors.primeryTxt,
        surfaceTintColor: AppColors.primeryTxt,
        insetPadding: EdgeInsets.all(16.sp),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              title != null
                  ? CommonText(
                      title: title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      textStyle: TextStyles.bold
                          .copyWith(color: AppColors.black, fontSize: 22.sp),
                    ).paddingOnly(bottom: 10.h)
                  : const Offstage(),
              CommonText(
                title: message,
                textAlign: TextAlign.center,
                maxLines: 5,
                textStyle: TextStyles.medium.copyWith(
                    color: AppColors.black.withOpacity(0.8), fontSize: 14.sp),
              ),
              SizedBox(height: 20.h),
              CommonButton(
                buttonTextColor: AppColors.primeryTxt,
                isButtonEnabled: true,
                buttonEnabledColor: AppColors.red,
                borderColor: AppColors.red,
                width: 150.w,
                buttonText: LocaleKeys.keyLogIn.localized,
                onTap: () {
                  Navigator.pop(context);
                  if (didDismiss != null) {
                    Future.delayed(
                      const Duration(milliseconds: 80),
                      () {
                        didDismiss();
                      },
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    ),
  );
}

/// Logout Dialog
showLogoutDialog(BuildContext context, WidgetRef ref) {
  showConfirmationDialog(
      context,
      LocaleKeys.keyLogout.localized,
      LocaleKeys.keyLogoutConfirmationMessageWeb.localized,
      LocaleKeys.keyLogout.localized,
      LocaleKeys.keyCancel.localized, (isPositive) {
    if (isPositive) {
      Session.sessionLogout(ref);
    }
  });
}

/// Session Expiry Dialog
sessionExpiryDialog(BuildContext context) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    barrierColor: AppColors.black.withOpacity(0.8),
    builder: (context) => Consumer(
      builder: (context, ref, _) {
        return Dialog(
          backgroundColor: AppColors.primeryTxt,
          surfaceTintColor: AppColors.primeryTxt,
          insetPadding: EdgeInsets.all(16.sp),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 25.w, vertical: 30.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: CommonText(
                          title: LocaleKeys.keyYourSessionExpiredNote.localized,
                          textAlign: TextAlign.center,
                          maxLines: 10,
                          textStyle: TextStyles.medium.copyWith(
                              color: AppColors.black, fontSize: 16.sp),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      CommonButton(
                        buttonTextColor: AppColors.primeryTxt,
                        buttonEnabledColor: AppColors.red,
                        isButtonEnabled: true,
                        borderColor: AppColors.red,
                        width: 150.w,
                        buttonText: LocaleKeys.keySignIn.localized,
                        onTap: () {
                          Navigator.pop(context);
                          Session.sessionLogout(ref);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

/// Exit DialogBox
showExitDialog(BuildContext context) {
  return showDialog(
    barrierDismissible: true,
    context: context,
    barrierColor: AppColors.black.withOpacity(0.8),
    builder: (context) => FadeBoxTransition(
      child: Dialog(
        backgroundColor: AppColors.primeryTxt,
        surfaceTintColor: AppColors.primeryTxt,
        insetPadding: EdgeInsets.all(30.sp),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  left: 16.w, right: 16.w, top: 22.h, bottom: 15.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommonText(
                    title: LocaleKeys.keyAreYouSureWantToExitFromApp.localized,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    textStyle: TextStyles.semiBold.copyWith(
                      color: AppColors.black,
                      fontSize: 20.sp,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  CommonText(
                    title: LocaleKeys.keyAnyUnsavedProgressWillBeLost.localized,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    textStyle: TextStyles.regular.copyWith(
                      color: AppColors.black.withOpacity(0.8),
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonButton(
                          height: 49.h,
                          isButtonEnabled: true,
                          buttonText: LocaleKeys.keyExit.localized,
                          borderRadius: BorderRadius.circular(10.r),
                          borderWidth: 1.w,
                          onTap: () {
                            Navigator.pop(context);
                            Future.delayed(const Duration(milliseconds: 80),
                                () {
                              exit(0);
                            });
                          },
                          borderColor: AppColors.red,
                          buttonEnabledColor: AppColors.red,
                          buttonTextColor: AppColors.primeryTxt),
                      CommonButton(
                          buttonText: LocaleKeys.keyCancel.localized,
                          height: 49.h,
                          borderWidth: 1.w,
                          isButtonEnabled: true,
                          borderRadius: BorderRadius.circular(0),
                          onTap: () {
                            Navigator.pop(context);
                            Future.delayed(
                                const Duration(milliseconds: 80), () {});
                          },
                          borderColor: AppColors.primeryTxt,
                          buttonEnabledColor: AppColors.primeryTxt,
                          buttonTextColor: AppColors.lightGray1),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Common Success Dialog
