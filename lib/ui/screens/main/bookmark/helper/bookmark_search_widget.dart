import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/widgets/custom_text_form_field.dart';

import '../../../../../framework/controller/main/bookmark/bookmark_controller.dart';
import '../../../../utils/helper/base_widget.dart';

class BookmarkSearchWidget extends ConsumerWidget with BaseConsumerWidget {
  const BookmarkSearchWidget({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final bookmarkScreenWatch = ref.watch(bookmarkController);
    return CustomTextFormField(
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
      controller: bookmarkScreenWatch.bookmarkSearchController,
      prefix: SizedBox(
        width: getWidth(10),
        height: getHeight(10),
        child: const SizedBox(
          width: 24,
          child: Icon(
            CupertinoIcons.search,
            color: AppColors.primeryTxt,
          ),
          // child: SvgPicture.asset(
          //   Assets.icons.tablerIconSearch,
          //   color: AppColors.primeryTxt,
          // ),
        ),
      ),
      hintText: "Search by movie, actor, director...",
    );
  }
}

// class BookmarkSearchWidget extends GetView<BookmarkController> {
//   const BookmarkSearchWidget({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         print("Got ot next");
//         Get.toNamed(Routes.SEARCHINEXPLORE);
//       },
//       child: CustomTextFormField(
//         isReadOnly: false,
//         isEnable: false,
//         onChanged: (value) {},
//         prefix: SizedBox(
//           width: getWidth(10),
//           height: getHeight(10),
//           child: const SizedBox(
//             width: 24,
//             child: Icon(
//               CupertinoIcons.search,
//               color: AppColors.primeryTxt,
//             ),
//             // child: SvgPicture.asset(
//             //   Assets.icons.tablerIconSearch,
//             //   color: AppColors.primeryTxt,
//             // ),
//           ),
//         ),
//         hintText: "Search by movie, actor, director...",
//       ),
//     );
//   }
// }
