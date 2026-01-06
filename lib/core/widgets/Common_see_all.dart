import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/widgets/common_image_view.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';
import 'package:vista_flicks/framework/controller/main/explore/explore_controller.dart';
import 'package:vista_flicks/gen/assets.gen.dart';
import 'package:vista_flicks/ui/screens/main/bookmark/helper/all_book_mark_shimmer.dart';

import '../../ui/routing/navigation_stack_item.dart';
import '../../ui/routing/stack.dart';
import 'common_bg_container.dart';

class CommonSeeAllScreen extends ConsumerStatefulWidget {
  final String title;

  const CommonSeeAllScreen({
    required this.title,
    super.key,
  });

  @override
  ConsumerState<CommonSeeAllScreen> createState() => _CommonSeeAllScreenState();
}

class _CommonSeeAllScreenState extends ConsumerState<CommonSeeAllScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final exploreScreenWatch = ref.read(exploreController);

      await exploreScreenWatch.getHomeViewAllAPI(type: widget.title);
    });
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final exploreState = ref.watch(exploreController);
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (exploreState.hasMoreData &&
          !exploreState.getHomeViewAllState.isLoadMore) {
        ref
            .read(exploreController.notifier)
            .getHomeViewAllAPI(type: widget.title, isLoadMore: true);
      }

      ref
          .read(exploreController.notifier)
          .getHomeViewAllAPI(type: widget.title, isLoadMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final exploreState = ref.watch(exploreController);

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        centerTitle: true,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                onChanged: (value) {
                  print("value ==========> $value");
                  exploreState.getHomeViewAllAPI(
                      type: widget.title, isLoadMore: false, search: value);
                },
                autofocus: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      _searchController.clear();
                      exploreState.getHomeViewAllAPI(
                          type: widget.title, isLoadMore: false, search: "");
                    },
                  ),
                ),
              )
            : MyRegularText(widget.title),
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
      body: CommonBgContainer(
        child: exploreState.getHomeViewAllState.isLoading
            ? AllBookMarkShimmer()
            : exploreState.homeViewAllDataList.isEmpty
                ? Center(
                    child: Text("No data found",
                        style: TextStyle(color: Colors.white)))
                : Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          controller: _scrollController,
                          itemCount: exploreState.homeViewAllDataList.length +
                              (exploreState.isLoading ? 1 : 0),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.7,
                          ),
                          itemBuilder: (context, index) {
                            if (index ==
                                exploreState.homeViewAllDataList.length) {
                              return Center(
                                  child:
                                      CircularProgressIndicator()); // Show bottom loader
                            }

                            var item = exploreState.homeViewAllDataList[index];
                            return GestureDetector(
                              onTap: () {
                                ref.read(navigationStackController).push(
                                    NavigationStackItem.detail(
                                        contentId: item.contentId ?? ""));
                              },
                              child: Padding(
                                padding: EdgeInsets.all(3),
                                child: CommonImageView(
                                  radius: 6,
                                  height: getHeight(147),
                                  width: getWidth(110),
                                  fit: BoxFit.fitHeight,
                                  url: item.imageUrl,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
