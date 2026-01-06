import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/core/widgets/common_image_view.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';
import 'package:vista_flicks/gen/assets.gen.dart';
import 'package:vista_flicks/ui/routing/navigation_stack_item.dart';
import 'package:vista_flicks/ui/routing/stack.dart';

import '../../../../../framework/controller/main/bookmark/bookmark_controller.dart';

class SeeAllAndBookmarksWidget extends ConsumerStatefulWidget {
  const SeeAllAndBookmarksWidget({super.key});

  @override
  ConsumerState<SeeAllAndBookmarksWidget> createState() =>
      _SeeAllAndBookmarksWidgetState();
}

class _SeeAllAndBookmarksWidgetState
    extends ConsumerState<SeeAllAndBookmarksWidget> {
  @override
  Widget build(BuildContext context) {
    final bookmarkScreenWatch = ref.watch(bookmarkController);
    return Column(
      children: [
        getVerticalHeight(20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyRegularText(
              "All Bookmarks (${bookmarkScreenWatch.allBookmarkList.length})",
              style: BaseTextStyle.headerM,
            ),
            GestureDetector(
              onTap: () async {
                ref
                    .read(navigationStackController)
                    .push(NavigationStackItem.seeAllBookmark());

                await bookmarkScreenWatch.getAllBookmarkListAPI(context,
                    ref: ref, search: '', limit: '20');
              },
              child: MyRegularText(
                "VIEW ALL",
                style: BaseTextStyle.lableXs.copyWith(color: AppColors.red),
              ),
            ),
          ],
        ),
        getVerticalHeight(10.h),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.7,
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5),
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          // itemCount: movies.length,
          itemCount: bookmarkScreenWatch.allBookmarkList.length > 12
              ? 12
              : bookmarkScreenWatch.allBookmarkList.length,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.all(3.r),
            child: GestureDetector(
              onTap: () {
                ref.read(navigationStackController).push(
                    NavigationStackItem.detail(
                        contentId: bookmarkScreenWatch
                                .allBookmarkList[index].contentId ??
                            ""));
              },
              child: CommonImageView(
                radius: 6.r,
                height: getHeight(140.h),
                width: getWidth(100.w),
                fit: BoxFit.cover,
                imagePath: Assets.images.p13.path,
                url: bookmarkScreenWatch.allBookmarkList[index].imageUrl,
                // imagePath: Assets.images.p9.path,
              ),
            ),
          ),
        ),
        getVerticalHeight(50.h),
      ],
    );
  }
}
