import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:vista_flicks/core/widgets/common_bg_container.dart';
import 'package:vista_flicks/framework/utils/extension/context_extension.dart';
import 'package:vista_flicks/ui/screens/main/bookmark/helper/all_book_mark_shimmer.dart';
import 'package:vista_flicks/ui/screens/main/bookmark/helper/book_mark_banner_shinner.dart';
import 'package:vista_flicks/ui/utils/helper/base_widget.dart';

import '../../../../core/values/size_constant.dart';
import '../../../../core/values/text_styles/base_textstyle.dart';
import '../../../../framework/controller/main/bookmark/bookmark_controller.dart';
import '../../../../gen/assets.gen.dart';
import 'helper/bookmark_banner_widget.dart';
import 'helper/bookmark_search_widget.dart';
import 'helper/see_all_and_bookmarks_widget.dart';
import 'helper/top_bookmark_txt_widget.dart';

class BookmarkScreen extends ConsumerStatefulWidget {
  const BookmarkScreen({super.key});

  @override
  ConsumerState<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends ConsumerState<BookmarkScreen>
    with BaseConsumerStatefulWidget {
  final TextEditingController bookmarkSearchController =
      TextEditingController();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final bookmarkScreenWatch = ref.read(bookmarkController);
      bookmarkScreenWatch.allBookmarkListState.isLoading = true;
      bookmarkScreenWatch.disposeController(isNotify: true);
      await bookmarkScreenWatch.getBannerListAPI(context, ref: ref);

      if (mounted) {
        // await bookmarkScreenWatch.getAllBookmarkListAPI(context, ref: ref, search: 'Love');

        await bookmarkScreenWatch.getAllBookmarkListAPI(context,
            ref: ref, search: '', limit: '12');
      }
    });
    super.initState();
  }

  @override
  Widget buildPage(BuildContext context) {
    final bookmarkScreenWatch = ref.watch(bookmarkController);
    return Scaffold(
      body: CommonBgContainer(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getVerticalHeight(Platform.isAndroid ? 20 : 60),

            const TopBookmarkTxtWidget(),
            // getVerticalHeight(15),
            const BookmarkSearchWidget(),
            // getVerticalHeight(20),
            bookmarkScreenWatch.bookmarkBannerListState.isLoading
                ? BookMarkBannerShimmer()
                : bookmarkScreenWatch.bookmarkBannerList.isNotEmpty
                    ? const BookmarkBannerWidget()
                    : SizedBox(),
            bookmarkScreenWatch.allBookmarkListState.isLoading
                ? AllBookMarkShimmer()
                : bookmarkScreenWatch.allBookmarkListState.success?.data
                            ?.results?.isNotEmpty ==
                        true
                    ? const SeeAllAndBookmarksWidget()
                    : SizedBox(
                        height: context.height / 2.5,
                        width: context.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(

                                // animate: false,
                                height: getHeight(150.h),
                                width: getWidth(150.w),
                                fit: BoxFit.fitWidth,
                                Assets.lottie.dataNotFound2),
                            Text(
                              "No Bookmark Found",
                              style: BaseTextStyle.textMl,
                            )
                          ],
                        ),
                      ),
            getVerticalHeight(20.h),
          ],
        ),
      )),
    );
  }
}
// class BookmarkScreen extends GetView<BookmarkController> {
//   const BookmarkScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CommonBgContainer(
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 getVerticalHeight(50),
//                 const TopBookmarkTxtWidget(),
//                 getVerticalHeight(15),
//                 const BookmarkSearchWidget(),
//                 getVerticalHeight(20),
//                 const BookmarkBannerWidget(),
//                 const SeeAllAndBookmarksWidget(),
//                 getVerticalHeight(20),
//               ],
//             ),
//           )),
//     );
//   }
// }
//
