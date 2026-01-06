import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/widgets/common_image_view.dart';
import 'package:vista_flicks/framework/controller/dynamic_link_controller.dart';
import 'package:vista_flicks/framework/controller/main/preview_and_detail/detail/detail_controller.dart';
import 'package:vista_flicks/framework/repository/chat/model/message_list_response_model.dart';
import 'package:vista_flicks/ui/screens/main/preview_and_detail/detail/helper/about_tab_widget.dart';
import 'package:vista_flicks/ui/screens/main/preview_and_detail/detail/helper/review_tab_widget.dart';
import 'package:vista_flicks/ui/screens/main/preview_and_detail/detail/helper/similar_tab_widget.dart';
import 'package:vista_flicks/ui/utils/widgets/dialog_progressbar.dart';

import '../../../../../core/values/size_constant.dart';
import '../../../../../core/values/text_styles/base_textstyle.dart';
import '../../../../../framework/controller/main/inbox/single_group/single_group_controller.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../utils/widgets/common_group_selection_sheet.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final String contentId;

  const DetailScreen({super.key, required this.contentId});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  TextEditingController searchTxtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final detailControllerWatch = ref.read(detailController);
      detailControllerWatch.disposeController(isNotify: true);
      await detailControllerWatch.getAboutContectAPI(context,
          contentId: widget.contentId);
      await detailControllerWatch.getReviewAPI(context,
          contentId: widget.contentId);
      await detailControllerWatch.getSimilarAPI(context,
          contentId: widget.contentId);
      detailControllerWatch.filteredGroupList = detailControllerWatch.groupList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailScreenWatch = ref.watch(detailController);
    final singleGroupScreenWatch = ref.watch(singleGroupController);
    return Stack(
      children: [
        DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: Colors.black,
            body: NestedScrollView(
              // physics: NeverScrollableScrollPhysics(),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: MediaQuery.of(context).size.height * 0.4,
                    pinned: true,
                    backgroundColor: Colors.black,
                    leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: SvgPicture.asset(
                        height: getHeight(30),
                        width: getWidth(30),
                        Assets.icons.svgBack,
                        color: AppColors.primeryTxt,
                      ),
                    ),
                    actions: [
                      GestureDetector(
                        onTap: () {
                          detailScreenWatch.selectedGroups.clear();
                          showModalBottomSheet(
                              backgroundColor: AppColors.black,
                              isScrollControlled: true,
                              builder: (context) => CommonGroupSelectionSheet(
                                    searchTxtController: searchTxtController,
                                    media: MessageMedia(
                                        mediaUrl: detailScreenWatch
                                            .getAboutContentModelState
                                            .success!
                                            .data!
                                            .posterPath,
                                        mediaId: detailScreenWatch
                                            .getAboutContentModelState
                                            .success!
                                            .data!
                                            .id,
                                        mediaType: "content"),
                                  ),
                              context: context);
                        },
                        child: SvgPicture.asset(
                          Assets.icons.tablerIconSend,
                          color: AppColors.primeryTxt,
                        ),
                      ),
                      SizedBox(width: 20),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () async {
                          final dynamicLinkController =
                              ref.read(dynamicLinkControllerProvider.notifier);
                          await dynamicLinkController.createDynamicLink(
                            true,
                            detailScreenWatch.getAboutContentModelState.success!
                                    .data!.title ??
                                "",
                            contentId: detailScreenWatch
                                    .getAboutContentModelState
                                    .success!
                                    .data!
                                    .id ??
                                "",
                            context: context,
                            image: detailScreenWatch.getAboutContentModelState
                                    .success!.data!.posterPath ??
                                "",
                          );
                        },
                        child: SvgPicture.asset(
                          Assets.icons.tablerIconShare,
                          color: AppColors.primeryTxt,
                        ),
                      ),
                      SizedBox(width: 20),
                      // SvgPicture.asset(
                      //   Assets.icons.tablerIconDotsVertical,
                      //   color: AppColors.primeryTxt,
                      // ),
                      // SizedBox(width: 20),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      expandedTitleScale: 10,
                      collapseMode: CollapseMode.pin,
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Image.asset(
                          //   Assets.images.detailBg.path,
                          //   fit: BoxFit.cover,
                          // ),
                          detailScreenWatch.getAboutContentModelState.isLoading
                              ? Shimmer.fromColors(
                                  baseColor:
                                      AppColors.primeryTxt.withOpacity(0.2),
                                  highlightColor: AppColors.black,
                                  child: Container(
                                    height: 100,
                                    color: Colors.black,
                                  ),
                                )
                              : CommonImageView(
                                  fit: BoxFit.cover,
                                  url: detailScreenWatch
                                          .getAboutContentModelState
                                          .success
                                          ?.data
                                          ?.posterPath ??
                                      "",
                                ),
                          Container(
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.1),
                                  Colors.black,
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text(
                                detailScreenWatch.getAboutContentModelState
                                        .success?.data?.title ??
                                    '',
                                style: BaseTextStyle.headerXl,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _TabBarDelegate(
                      const TabBar(
                        physics: NeverScrollableScrollPhysics(),
                        indicatorColor: AppColors.red,
                        labelColor: AppColors.primeryTxt,
                        indicatorSize: TabBarIndicatorSize.tab,
                        unselectedLabelColor: AppColors.secondaryTxt,
                        dividerColor: AppColors.border,
                        tabs: [
                          Tab(text: 'About'),
                          Tab(text: 'Reviews'),
                          Tab(text: 'Similar'),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  AboutTab(),
                  ReviewsTab(contentId: widget.contentId),
                  SimilarTab(),
                ],
              ),
            ),
          ),
        ),
        DialogProgressBar(
            isLoading: detailScreenWatch.similarListState.isLoading ||
                detailScreenWatch.getAboutContentModelState.isLoading)
      ],
    );
  }

// void showGroupSelectionModal(BuildContext context, WidgetRef ref,
//     TextEditingController searchTxtController) {
//   final detailScreenWatch = ref.watch(detailController);
//   final singleGroupScreenWatch = ref.watch(singleGroupController);
//   showModalBottomSheet(
//     backgroundColor: AppColors.black,
//     isScrollControlled: true,
//     context: context,
//     builder: (context) => StreamBuilder<List<GroupDetailsResponseModel>>(
//       stream: GroupChatManager.instance.getGroupsStream(Session.userId),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         ref.read(detailController).groupList = snapshot.data!;
//         List<GroupDetailsResponseModel> groupList =
//             detailScreenWatch.filteredGroupList.isEmpty &&
//                     searchTxtController.text.isEmpty
//                 ? detailScreenWatch.groupList
//                 : detailScreenWatch.filteredGroupList;
//
//         if (groupList.isEmpty) {
//           return Container(
//             padding: const EdgeInsets.all(16.0),
//             height: context.height * 0.7,
//             child: Column(
//               children: [
//                 CustomTextFormField(
//                   controller: searchTxtController,
//                   prefix: Icon(CupertinoIcons.search,
//                       color: AppColors.primeryTxt),
//                   contentPadding: EdgeInsets.zero,
//                   fillColor: AppColors.lightGray1,
//                   hintText: "Search group name",
//                   onChanged: (value) => detailScreenWatch.onSearch(value),
//                 ),
//                 SizedBox(height: context.height * .2),
//                 const Center(child: Text("You're not in any groups.")),
//               ],
//             ),
//           );
//         }
//
//         return StatefulBuilder(
//           builder: (context, setState) => DraggableScrollableSheet(
//             expand: false,
//             initialChildSize: 0.7,
//             maxChildSize: 0.95,
//             builder: (context, scrollController) {
//               return Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Stack(
//                   alignment: Alignment.bottomCenter,
//                   children: [
//                     Column(
//                       children: [
//                         CustomTextFormField(
//                           controller: searchTxtController,
//                           prefix: Icon(CupertinoIcons.search,
//                               color: AppColors.primeryTxt),
//                           contentPadding: EdgeInsets.zero,
//                           fillColor: AppColors.lightGray1,
//                           hintText: "Search group name",
//                           onChanged: (value) =>
//                               detailScreenWatch.onSearch(value),
//                         ),
//                         const SizedBox(height: 16),
//                         Expanded(
//                           child: GridView.builder(
//                             controller: scrollController,
//                             itemCount: groupList.length,
//                             gridDelegate:
//                                 const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 3,
//                               mainAxisSpacing: 12,
//                               crossAxisSpacing: 12,
//                             ),
//                             itemBuilder: (context, index) {
//                               var avatarLength =
//                                   groupList[index].members?.length ?? 0;
//                               final isSelected = detailScreenWatch
//                                   .selectedGroups
//                                   .contains(index);
//                               return GestureDetector(
//                                 onTap: () {
//                                   ref
//                                       .read(detailController)
//                                       .toggleSelection(index);
//                                   setState(() {});
//                                 },
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: isSelected
//                                         ? AppColors.red.withOpacity(0.1)
//                                         : Colors.transparent,
//                                     border: Border.all(
//                                       color: isSelected
//                                           ? AppColors.red
//                                           : AppColors.black,
//                                       width: isSelected ? 2 : 1,
//                                     ),
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   padding: const EdgeInsets.all(8),
//                                   child: Column(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.center,
//                                     children: [
//                                       SizedBox(
//                                         width: 60.w,
//                                         child: Wrap(
//                                           spacing: 2,
//                                           runSpacing: 2,
//                                           children: List.generate(
//                                             (avatarLength > 4
//                                                 ? 4
//                                                 : avatarLength),
//                                             (i) {
//                                               // For the 4th avatar, if there are more than 4 members, show +X
//                                               if (i == 3 &&
//                                                   avatarLength > 4) {
//                                                 return SizedBox(
//                                                   height: getHeight(25.h),
//                                                   width: getWidth(25.w),
//                                                   child: CircleAvatar(
//                                                     backgroundColor:
//                                                         AppColors.red,
//                                                     child: Text(
//                                                       // '+${avatarLength - 3}',
//                                                       '+${avatarLength - 3}',
//                                                       style: BaseTextStyle
//                                                           .textXxs
//                                                           .copyWith(
//                                                         color: Colors.white,
//                                                         // fontWeight: FontWeight.bold,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 );
//                                               }
//                                               return SizedBox(
//                                                 height: getHeight(25.h),
//                                                 width: getWidth(25.w),
//                                                 child: CircleAvatar(
//                                                   radius: 15,
//                                                   backgroundImage:
//                                                       NetworkImage(
//                                                     groupList[index]
//                                                             .members?[i]
//                                                             .userImage ??
//                                                         '',
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(height: 8),
//                                       Text(
//                                         groupList[index].groupName ?? "",
//                                         style: BaseTextStyle.textS
//                                             .copyWith(color: Colors.white),
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                     if (detailScreenWatch.selectedGroups.isNotEmpty)
//                       Positioned(
//                         bottom: 10.h,
//                         left: 10.h,
//                         right: 10.h,
//                         child: CustomButton(
//                           width: MediaQuery.of(context).size.width,
//                           text: "Send To Group",
//                           fun: () {
//                             print(
//                                 "detailScreenWatch.filteredGroupList.first.groupId.toString() ==== > ${detailScreenWatch.filteredGroupList.first.groupId.toString()}");
//                             singleGroupScreenWatch.textController.text =
//                                 "textController";
//                             singleGroupScreenWatch.sendMessage(
//                                 media: MessageMedia(
//                                     mediaUrl: detailScreenWatch
//                                         .getAboutContentModelState
//                                         .success!
//                                         .data!
//                                         .posterPath,
//                                     mediaId: detailScreenWatch
//                                         .getAboutContentModelState
//                                         .success!
//                                         .data!
//                                         .id),
//                                 groupId: detailScreenWatch
//                                     .filteredGroupList.first.groupId
//                                     .toString());
//                           },
//                         ),
//                       ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     ),
//   );
// }
}

// Keeps Tab Bar pinned
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate(this.tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.black,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) => false;
}

//
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:vista_flicks/core/values/app_colours.dart';
// import 'package:vista_flicks/core/values/size_constant.dart';
//
// import '../../../../gen/assets.gen.dart';
// import 'detail_controller.dart';
//
// class DetailPage extends GetView<DetailController> {
//   const DetailPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: NestedScrollView(
//           headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//             return [
//               // SliverAppBar(
//               //   expandedHeight: 250.0,
//               //   leading: IconButton(
//               //       onPressed: () {},
//               //       icon: Icon(
//               //         Icons.arrow_back,
//               //         color: AppColors.primeryTxt,
//               //       )),
//               //   actions: [
//               //     SvgPicture.asset(
//               //       Assets.icons.tablerIconSend,
//               //       color: AppColors.primeryTxt,
//               //     ),
//               //     getHorizonatlWidth(20),
//               //     SvgPicture.asset(
//               //       Assets.icons.tablerIconShare,
//               //       color: AppColors.primeryTxt,
//               //     ),
//               //     getHorizonatlWidth(20),
//               //     SvgPicture.asset(
//               //       Assets.icons.tablerIconDotsVertical,
//               //       color: AppColors.primeryTxt,
//               //     ),
//               //     getHorizonatlWidth(20),
//               //   ],
//               //   pinned: true,
//               //   backgroundColor: Colors.black,
//               //   flexibleSpace: FlexibleSpaceBar(
//               //     background: Image.asset(
//               //       Assets.images.detailBg.path,
//               //       // Replace with actual image URL
//               //       fit: BoxFit.contain,
//               //     ),
//               //   ),
//               //   // Tab Bar
//               //   bottom: TabBar(
//               //     indicatorColor: Colors.red,
//               //     labelColor: Colors.red,
//               //     unselectedLabelColor: Colors.white,
//               //     tabs: const [
//               //       Tab(text: 'About'),
//               //       Tab(text: 'Reviews'),
//               //       Tab(text: 'Similar'),
//               //     ],
//               //   ),
//               // ),
//               SliverAppBar(
//                 expandedHeight: 250.0,
//                 leading: IconButton(
//                   onPressed: () {},
//                   icon: Icon(
//                     Icons.arrow_back,
//                     color: AppColors.primeryTxt,
//                   ),
//                 ),
//                 actions: [
//                   SvgPicture.asset(
//                     Assets.icons.tablerIconSend,
//                     color: AppColors.primeryTxt,
//                   ),
//                   getHorizonatlWidth(20),
//                   SvgPicture.asset(
//                     Assets.icons.tablerIconShare,
//                     color: AppColors.primeryTxt,
//                   ),
//                   getHorizonatlWidth(20),
//                   SvgPicture.asset(
//                     Assets.icons.tablerIconDotsVertical,
//                     color: AppColors.primeryTxt,
//                   ),
//                   getHorizonatlWidth(20),
//                 ],
//                 pinned: true,
//                 backgroundColor: Colors.black,
//                 flexibleSpace: FlexibleSpaceBar(
//                   background: Stack(
//                     fit: StackFit.expand,
//                     children: [
//                       Image.asset(
//                         Assets.images.detailBg.path,
//                         fit: BoxFit.cover,
//                       ),
//                       Container(
//                         color: Colors.black.withOpacity(
//                             0.5), // Add overlay for better visibility
//                       ),
//                       Align(
//                         alignment: Alignment.center,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 16.0, vertical: 8.0),
//                           child: Text(
//                             "Movie Title Here",
//                             // Replace with dynamic movie title
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 bottom: PreferredSize(
//                   preferredSize: const Size.fromHeight(50),
//                   child: Container(
//                     color: Colors.black, // Ensure the background is solid
//                     child: const TabBar(
//                       indicatorColor: Colors.red,
//                       labelColor: Colors.red,
//                       unselectedLabelColor: Colors.white,
//                       tabs: [
//                         Tab(text: 'About'),
//                         Tab(text: 'Reviews'),
//                         Tab(text: 'Similar'),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ];
//           },
//           body: TabBarView(
//             children: [
//               // About Tab
//               SingleChildScrollView(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'About',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8.0),
//                     const Text(
//                       'With the price on his head ever increasing, John Wick uncovers a path to defeating The High Table. But before he can earn his freedom, Wick must face off against a new enemy with powerful alliances across the globe and forces that turn old friends into foes.',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     const SizedBox(height: 16.0),
//                     Wrap(
//                       spacing: 8.0,
//                       runSpacing: 8.0,
//                       children: const [
//                         TagChip(label: 'ACTION EPIC'),
//                         TagChip(label: 'GUN FU'),
//                         TagChip(label: 'ONE-PERSON ARMY ACTION'),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               // Reviews Tab
//               ListView.builder(
//                 padding: const EdgeInsets.all(16.0),
//                 itemCount: 5,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 16.0),
//                     child: ListTile(
//                       tileColor: Colors.grey[800],
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       title: Text(
//                         'Review ${index + 1}',
//                         style: const TextStyle(color: Colors.white),
//                       ),
//                       subtitle: const Text(
//                         'This is a sample review.',
//                         style: TextStyle(color: Colors.white70),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               // Similar Tab
//               GridView.builder(
//                 padding: const EdgeInsets.all(16.0),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3,
//                     crossAxisSpacing: 8.0,
//                     mainAxisSpacing: 8.0,
//                     childAspectRatio: 0.7),
//                 itemCount: 6,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8.0),
//                       image: DecorationImage(
//                         image: AssetImage(
//                           Assets
//                               .images.p6.path, // Replace with actual image URL
//                         ),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class TagChip extends StatelessWidget {
//   final String label;
//
//   const TagChip({super.key, required this.label});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
//       decoration: BoxDecoration(
//         color: Colors.grey[800],
//         borderRadius: BorderRadius.circular(16.0),
//       ),
//       child: Text(
//         label,
//         style: const TextStyle(color: Colors.white),
//       ),
//     );
//   }
// }
