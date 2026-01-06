// Reviews Tab
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/core/widgets/common_image_view.dart';
import 'package:vista_flicks/ui/routing/navigation_stack_item.dart';
import 'package:vista_flicks/ui/routing/stack.dart';

import '../../../../../../core/values/size_constant.dart';
import '../../../../../../framework/controller/main/preview_and_detail/detail/detail_controller.dart';
import '../../../../../../gen/assets.gen.dart';

class ReviewsTab extends ConsumerWidget {
  final String? contentId;
  const ReviewsTab({super.key, required this.contentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsTabWatch = ref.watch(detailController);
    return reviewsTabWatch.getReviewModelState.success?.data?.isEmpty == true
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getVerticalHeight(30),
              Lottie.asset(
                  // animate: false,
                  height: getHeight(150.h),
                  width: getWidth(150.w),
                  fit: BoxFit.fitWidth,
                  Assets.lottie.dataNotFound2),
              Text(
                "No Review Found",
                style: BaseTextStyle.textMl,
              )
            ],
          )
        : GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.7,
            ),
            itemCount:
                reviewsTabWatch.getReviewModelState.success?.data?.length ?? 0,
            itemBuilder: (context, index) {
              var review =
                  reviewsTabWatch.getReviewModelState.success?.data?[index];
              return GestureDetector(
                onTap: () {
                  ref.read(navigationStackController).push(
                      NavigationStackItemReelScreen(
                          reelId: review?.id ?? "",
                          contentId: contentId ?? ""));
                },
                child: CommonImageView(
                  url: review?.thumbnailUrl ?? "",
                  radius: 8.0,
                  fit: BoxFit.cover,
                ),
              );
              // Container(
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(8.0),
              //     image: DecorationImage(
              //       image: AssetImage(reviewsTabWatch.reviewImg[index].path),
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // );
            },
          );
  }
}
