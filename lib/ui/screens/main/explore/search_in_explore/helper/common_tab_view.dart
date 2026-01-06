import 'package:flutter/material.dart';

import '../../../../../../core/values/size_constant.dart';
import '../../../../../../core/widgets/common_image_view.dart';
import '../../../../../../gen/assets.gen.dart';

class CommonTabView extends StatelessWidget {
  const CommonTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(3),
                child: CommonImageView(
                  radius: 6,
                  height: getHeight(147),
                  width: getWidth(114),
                  imagePath: Assets.images.p6.path,
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
