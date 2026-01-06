import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/widgets/common_bg_container.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';
import 'package:vista_flicks/ui/screens/main/bookmark/helper/all_book_mark_shimmer.dart';

import '../../../../core/values/size_constant.dart';
import '../../../../core/widgets/common_image_view.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../../framework/controller/main/bookmark/bookmark_controller.dart';
import '../../../../gen/assets.gen.dart';
import '../../../routing/navigation_stack_item.dart';
import '../../../routing/stack.dart';

class SeeAllBookmarkScreen extends ConsumerStatefulWidget {
  const SeeAllBookmarkScreen({super.key});
  @override
  ConsumerState<SeeAllBookmarkScreen> createState() =>
      _SeeAllBookmarkScreenState();
}

class _SeeAllBookmarkScreenState extends ConsumerState<SeeAllBookmarkScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final bookmarkScreenWatch = ref.watch(bookmarkController);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        // ref.read(navigationStackController).pop();
        _searchController.text = "";
        bookmarkScreenWatch.getAllBookmarkListAPI(context,
            ref: ref, search: "");
      },
      child: Scaffold(
        backgroundColor: AppColors.black,
        // extendBodyBehindAppBar: true,
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: AppColors.black,
          foregroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                ref.read(navigationStackController).pop();
                _searchController.text = "";
                bookmarkScreenWatch.getAllBookmarkListAPI(context,
                    ref: ref, search: "");
              },
              icon: Icon(Icons.arrow_back)),
          title: _isSearching
              ? CustomTextFormField(
                  isReadOnly: false,
                  // isEnable: false,
                  onSaved: (value) {
                    bookmarkScreenWatch.pageNo = 1;
                    bookmarkScreenWatch.getAllBookmarkListAPI(context,
                        ref: ref, search: value, limit: '12');
                  },
                  onChanged: (value) {
                    bookmarkScreenWatch.startSearchTimer(context, ref, value);
                    // bookmarkScreenWatch.debouncer.call(() {
                    //   bookmarkScreenWatch.pageNo = 1;
                    //   bookmarkScreenWatch.getAllBookmarkListAPI(context,
                    //       ref: ref, search: value, limit: '12');
                    // });
                  },
                  controller: _searchController,

                  hintText: "Search...",
                )
              : MyRegularText(
                  "All Bookmarks (${bookmarkScreenWatch.allBookmarkListState.success?.data?.totalResults})"),
          actions: [
            if (!_isSearching)
              Padding(
                padding: EdgeInsets.only(right: getWidth(16)),
                child: IconButton(
                  icon: SvgPicture.asset(
                    Assets.icons.tablerIconSearch,
                    color: AppColors.primeryTxt,
                  ),
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                ),
              )
          ],
        ),
        // appBar: AppBar(
        //   backgroundColor: AppColors.black,
        //   foregroundColor: Colors.white,
        //   systemOverlayStyle: SystemUiOverlayStyle.light,
        //   centerTitle: true,
        //   title: MyRegularText(
        //     "All Bookmarks (${bookmarkScreenWatch.allBookmarkListState.success?.data?.totalResults})",
        //   ),
        //   actions: [
        //     Padding(
        //       padding: EdgeInsets.only(right: getWidth(16)),
        //       child: SvgPicture.asset(
        //         Assets.icons.tablerIconSearch,
        //         color: AppColors.primeryTxt,
        //       ),
        //     )
        //   ],
        // ),
        body: CommonBgContainer(
          child: Column(
            children: [
              bookmarkScreenWatch.allBookmarkListState.isLoading
                  ? Expanded(child: AllBookMarkShimmer())
                  : bookmarkScreenWatch.allBookmarkList.isNotEmpty
                      ? Expanded(
                          child: GridView.builder(
                            shrinkWrap: true,
                            itemCount:
                                bookmarkScreenWatch.allBookmarkList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, childAspectRatio: 0.7),
                            itemBuilder: (context, index) {
                              var allBookMark =
                                  bookmarkScreenWatch.allBookmarkList[index];
                              return Padding(
                                padding: EdgeInsets.all(3),
                                child: GestureDetector(
                                  onTap: () {
                                    ref.read(navigationStackController).push(
                                          NavigationStackItem.detail(
                                            contentId:
                                                allBookMark.contentId ?? "",
                                          ),
                                        );
                                  },
                                  child: CommonImageView(
                                    radius: 6,
                                    height: getHeight(147),
                                    width: getWidth(110),
                                    fit: BoxFit.fitHeight,
                                    url: allBookMark.imageUrl ?? "",
                                    // imagePath: Assets.images.p13.path,
                                    // imagePath: Assets.images.p9.path,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : MyRegularText("No Bookmarks found"),
            ],
          ),
        ),
      ),
    );
  }
}

//
// class SeeAllBookmarkScreen extends GetView<BookmarkController> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.black,
//       // extendBodyBehindAppBar: true,
//       // resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         backgroundColor: AppColors.black,
//         foregroundColor: Colors.white,
//         systemOverlayStyle: SystemUiOverlayStyle.light,
//         centerTitle: true,
//         title: MyRegularText("All Bookmarks (28)"),
//         actions: [
//           Padding(
//             padding: EdgeInsets.only(right: getWidth(16)),
//             child: SvgPicture.asset(
//               Assets.icons.tablerIconSearch,
//               color: AppColors.primeryTxt,
//             ),
//           )
//         ],
//       ),
//       body: CommonBgContainer(
//         child: Column(
//           children: [
//             Expanded(
//               child: GridView.builder(
//                 itemCount: 20,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3, childAspectRatio: 0.7),
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: EdgeInsets.all(3),
//                     child: CommonImageView(
//                       radius: 6,
//                       height: getHeight(147),
//                       width: getWidth(110),
//                       fit: BoxFit.fitHeight,
//                       imagePath: Assets.images.p13.path,
//                       // imagePath: Assets.images.p9.path,
//                     ),
//                   );
//                 },
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
