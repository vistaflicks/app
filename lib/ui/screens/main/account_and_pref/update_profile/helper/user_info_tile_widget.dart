import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/core/widgets/common_image_view.dart';
import 'package:vista_flicks/framework/controller/auth/on_boarding/on_boarding_controller.dart';
import 'package:vista_flicks/gen/assets.gen.dart';

import '../../../../../../framework/utils/local_storage/session.dart';
import '../../../../../utils/helper/base_widget.dart';

class UserInfoTileWidget extends ConsumerWidget with BaseConsumerWidget {
  const UserInfoTileWidget({
    super.key,
  });

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    var userInfoTileWatch = ref.watch(onBoardingController);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: getWidth(100),
          height: getHeight(100),
          child: CommonImageView(
            radius: 50,
            url: userInfoTileWatch.getProfileApiState.success?.data?.avatar ??
                Session.userProfileImage,
            imagePath: Assets.images.profileImg.path,
          ),
        ),
        getHorizonatlWidth(10),
        Expanded(
          child: Text(
            // "${userInfoTileWatch.getProfileApiState.success?.data?.firstName} ${userInfoTileWatch.getProfileApiState.success?.data?.lastName} ",
            "${Session.userFirstName} ${Session.userLastName} ",
            style: BaseTextStyle.lableMl.copyWith(fontWeight: FontWeight.w600),
            maxLines: 2,
          ),
        )
      ],
    );
  }
}
