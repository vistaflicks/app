import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/framework/utils/extension/extension.dart';
import 'package:vista_flicks/ui/utils/theme/text_style.dart';

import '../../../framework/provider/network/network.dart';
import '../../../gen/assets.gen.dart';
import '../../routing/stack.dart';
import '../theme/app_colors.dart';
import 'common_dialogs.dart';
import 'common_image.dart';
import 'common_text.dart';

class CommonAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final bool isLeadingEnable;
  final bool isDrawerEnable;
  final GestureTapCallback? onLeadingPress;
  final String title;
  final String? leftImage;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? drawerColor;
  final Color? titleColor;
  final Color? leftImageColor;
  final bool? centerTitle;
  final String? lottieString;
  final bool? homeScreen;
  final double? leadingWidth;
  final Widget? centerWidget;
  final bool isCenterIcon;
  final TextStyle? titleTextStyle;
  final bool isDividerRequired;
  final double? elevation;
  final bool isShowRadius;
  final bool isExtraPadding;

  const CommonAppBar({
    Key? key,
    this.isLeadingEnable = true,
    this.isDrawerEnable = false,
    this.onLeadingPress,
    this.leftImage,
    this.leftImageColor,
    this.title = '',
    this.backgroundColor,
    this.titleColor,
    this.drawerColor,
    this.actions,
    this.centerWidget,
    this.centerTitle,
    this.isCenterIcon = false,
    this.lottieString,
    this.homeScreen,
    this.leadingWidth,
    this.titleTextStyle,
    this.isDividerRequired = true,
    this.elevation,
    this.isShowRadius = false,
    this.isExtraPadding = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        AppBar(
          forceMaterialTransparency: false,
          surfaceTintColor: backgroundColor ?? AppColors.white,
          foregroundColor: backgroundColor ?? AppColors.white,
          shadowColor: backgroundColor ?? AppColors.white,
          centerTitle: centerTitle,
          leading: (isLeadingEnable)
              ? InkWell(
                  onTap: onLeadingPress ??
                      () async {
                        if (ref.read(navigationStackController).items.length >
                            1) {
                          ref.read(navigationStackController).pop();
                        } else {
                          await showExitDialog(context);
                        }
                      },
                  child: CommonImage(
                    strIcon: leftImage ?? Assets.icons.svgBack,
                    boxFit: BoxFit.scaleDown,
                    imgColor: leftImageColor,
                  ).paddingAll(8.h),
                )
              : const Offstage(),
          elevation: elevation ?? 1.h,
          actions: actions,
          backgroundColor: backgroundColor ?? AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: isShowRadius
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(12.r),
                    bottomRight: Radius.circular(12.r),
                  )
                : BorderRadius.zero,
          ),
          title: centerWidget ??
              CommonText(
                title: title,
                textAlign: TextAlign.center,
                maxLines: 2,
                textStyle: titleTextStyle ??
                    TextStyles.bold.copyWith(
                        fontSize: 18.sp,
                        color: titleColor ?? AppColors.fontBlack),
              ),
        ),
        // if (isDividerRequired) Divider(color: AppColors.greyLight, thickness: 1.h).paddingOnly(top: 5.h),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
      AppBar().preferredSize.height + (isExtraPadding ? 22.h : 0.h));
}

/*
Widget Usage
const CommonAppBar(
        title: "Home",
      ),
* */
