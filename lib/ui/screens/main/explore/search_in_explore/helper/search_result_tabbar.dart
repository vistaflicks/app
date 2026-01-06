import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/values/app_colours.dart';
import '../../../../../../core/values/size_constant.dart';
import '../../../../../../framework/controller/main/explore/explore_controller.dart';
import 'common_tab_view.dart';

class SearchResultTabBar extends ConsumerWidget {
  const SearchResultTabBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResultTabBarScreenWatch = ref.watch(exploreController);
    return Expanded(
      child: Column(
        children: [
          TabBar(
            padding: EdgeInsets.all(0),
            indicatorPadding: EdgeInsets.all(0),
            labelColor: AppColors.primeryTxt,
            unselectedLabelColor: AppColors.secondaryTxt,
            indicatorColor: AppColors.red,
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(
                text: "Movies",
              ),
              Tab(
                text: "Series",
              ),
            ],
          ),
          getVerticalHeight(10),
          // Tab Bar View
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TabBarView(
                children: [
                  CommonTabView(),
                  CommonTabView(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
