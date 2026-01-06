import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vista_flicks/core/values/size_constant.dart';

import '../../../../../core/values/app_colours.dart';

class SocialLoginButtonWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final String? assets;
  final bool isLoading;

  const SocialLoginButtonWidget({
    this.onTap,
    this.assets,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: getWidth(104),
        height: getHeight(50),
        decoration: BoxDecoration(
            color: AppColors.black11.withOpacity(0.6),
            borderRadius: BorderRadius.circular(100)),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator(
                  color: Colors.white,
                )
              : SvgPicture.asset(
                  assets!,
                ),
        ),
      ),
    );
  }
}
