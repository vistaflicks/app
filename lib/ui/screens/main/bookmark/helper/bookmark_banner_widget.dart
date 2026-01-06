import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/widgets/common_image_view.dart';
import 'package:vista_flicks/framework/controller/main/bookmark/bookmark_controller.dart';
import 'package:vista_flicks/gen/assets.gen.dart';
import 'package:vista_flicks/ui/routing/navigation_stack_item.dart';
import 'package:vista_flicks/ui/routing/stack.dart';

import '../../../../utils/helper/base_widget.dart';

class BookmarkBannerWidget extends ConsumerWidget with BaseConsumerWidget {
  const BookmarkBannerWidget({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final bookmarkScreenWatch = ref.watch(bookmarkController);
    return bookmarkScreenWatch.bookmarkBannerList.isEmpty
        ? const SizedBox()
        : CarouselSlider(
            options: CarouselOptions(
              height: getHeight(160),
              viewportFraction: 1,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
              autoPlay: true,
            ),
            items: List.generate(
              bookmarkScreenWatch.bookmarkBannerList.length,
              (index) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    ref.read(navigationStackController).push(
                          NavigationStackItem.detail(
                            contentId: bookmarkScreenWatch
                                    .bookmarkBannerList[index].contentId ??
                                "",
                          ),
                        );
                  },
                  child: CommonImageView(
                    borderRadius: BorderRadius.circular(10.r),
                    fit: BoxFit.contain,
                    imagePath: Assets.images.banner.path,
                    url: bookmarkScreenWatch.bookmarkBannerList[index].imageUrl,
                  ),
                );
              },
            ),
          );
  }
}
