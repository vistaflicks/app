import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/core/utils/config.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/core/widgets/common_bg_container.dart';
import 'package:vista_flicks/core/widgets/common_image_view.dart';
import 'package:vista_flicks/core/widgets/custom_text_form_field.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';
import 'package:vista_flicks/framework/controller/main/preview_and_detail/detail/detail_controller.dart';
import 'package:vista_flicks/framework/dependency_injection/inject.dart';
import 'package:vista_flicks/framework/utils/extension/context_extension.dart';
import 'package:vista_flicks/framework/utils/extension/extension.dart';
import 'package:vista_flicks/gen/assets.gen.dart';
import 'package:vista_flicks/ui/routing/navigation_stack_item.dart';
import 'package:vista_flicks/ui/routing/stack.dart';
import 'package:vista_flicks/ui/screens/main/explore/helper/explore_shimmer.dart';
import 'package:vista_flicks/ui/utils/const/app_constants.dart';
import 'package:vista_flicks/ui/utils/helper/base_widget.dart';

import '../../../../framework/controller/main/explore/explore_controller.dart';
import 'helper/trending_on_vista_flicks_widget.dart';

final detailController = ChangeNotifierProvider(
  (ref) => getIt<DetailController>(),
);

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen>
    with BaseConsumerStatefulWidget {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      showLog(
          'initState initState initState initState initState initState initState initState initState');
      final exploreScreenWatch = ref.read(exploreController);
      exploreScreenWatch.disposeController(isNotify: true);
      await exploreScreenWatch.getExploreListAPI(context, ref: ref);
    });
  }

  @override
  Widget buildPage(BuildContext context) {
    final exploreScreenWatch = ref.watch(exploreController);
    return Scaffold(
      body: CommonBgContainer(
        padding: EdgeInsets.zero,
        child: SingleChildScrollView(
          child: exploreScreenWatch.exploreListState.isLoading
              ? ExploreShimmer()
              : exploreScreenWatch.categoryList.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getVerticalHeight(Platform.isAndroid ? 20 : 60),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const MyRegularText("Find trending movies & shows",
                                style: BaseTextStyle.headerMl),
                            getVerticalHeight(15.h),
                            GestureDetector(
                              onTap: () async {
                                await exploreScreenWatch.getSearchAPI(context,
                                    search: "");
                                exploreScreenWatch.searchController.text = "";
                                ref.read(navigationStackController).push(
                                      NavigationStackItem.searchInExplore(),
                                    );
                              },
                              child: CustomTextFormField(
                                isReadOnly: false,
                                isEnable: false,
                                onChanged: exploreScreenWatch.onSearchChanged,
                                prefix: SizedBox(
                                  width: getWidth(10.w),
                                  height: getHeight(10.w),
                                  child: Icon(
                                    CupertinoIcons.search,
                                    color: AppColors.primeryTxt,
                                  ),
                                ),
                                hintText: "Search by movie, actor, director...",
                              ),
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 16.w),
                        if (exploreScreenWatch.bannerList.isNotEmpty)
                          Column(
                            children: [
                              getVerticalHeight(20),
                              CarouselSlider(
                                options: CarouselOptions(
                                  height: getHeight(160.h),
                                  viewportFraction: 1,
                                  enlargeCenterPage: true,
                                  scrollDirection: Axis.horizontal,
                                  autoPlay: true,
                                ),
                                items: List.generate(
                                  exploreScreenWatch.bannerList.length,
                                  (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        ref
                                            .read(navigationStackController)
                                            .push(
                                              NavigationStackItem.detail(
                                                contentId: exploreScreenWatch
                                                    .bannerList[index]
                                                    .contentId,
                                              ),
                                            );
                                      },
                                      child: CommonImageView(
                                        fit: BoxFit.contain,
                                        url: exploreScreenWatch
                                                .bannerList[index].imageUrl ??
                                            '',
                                        imagePath: Assets.images.banner.path,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ListView.builder(
                          shrinkWrap: true,
                          padding: exploreScreenWatch.bannerList.isNotEmpty
                              ? EdgeInsets.zero
                              : EdgeInsets.symmetric(vertical: 10),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: exploreScreenWatch.categoryList.length,
                          itemBuilder: (context, index) {
                            if ((exploreScreenWatch
                                    .categoryList[index].data?.isNotEmpty ??
                                false)) {
                              /// Banner View
                              if (exploreScreenWatch.categoryList[index].title
                                      ?.contains("Banner Ad") ==
                                  true) {
                                return CarouselSlider(
                                  options: CarouselOptions(
                                    height: getHeight(160.h),
                                    viewportFraction: 1,
                                    enlargeCenterPage: true,
                                    scrollDirection: Axis.horizontal,
                                    autoPlay: true,
                                  ),
                                  items: List.generate(
                                    exploreScreenWatch
                                            .categoryList[index].data?.length ??
                                        0,
                                    (bannerI) {
                                      return CommonImageView(
                                        fit: BoxFit.contain,
                                        url: exploreScreenWatch
                                            .categoryList[index]
                                            .data?[bannerI]
                                            .imageUrl,
                                        imagePath: Assets.images.banner.path,
                                      );
                                    },
                                  ),
                                );
                              } else if (exploreScreenWatch
                                      .categoryList[index].title
                                      ?.contains('Trending in Vista Reels') ==
                                  true) {
                                return exploreScreenWatch.categoryList[index]
                                            .data?.isEmpty ==
                                        true
                                    ? SizedBox()
                                    : TrendingOnVistaFlicksWidget(
                                            categoryList: exploreScreenWatch
                                                .categoryList[index])
                                        .paddingSymmetric(horizontal: 16.w);
                              } else if (exploreScreenWatch
                                      .categoryList[index].title
                                      ?.contains("Actor Ad Space") ==
                                  true) {
                                return exploreScreenWatch.categoryList[index]
                                            .data?.isEmpty ==
                                        true
                                    ? SizedBox()
                                    : _adSpace(exploreScreenWatch, index);
                              } else {
                                final hasValidContent = exploreScreenWatch
                                        .categoryList[index].data?.isEmpty ==
                                    true;

                                log("hasValidContent: $hasValidContent");

                                return hasValidContent
                                    ? SizedBox()
                                    : Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              MyRegularText(
                                                exploreScreenWatch
                                                        .categoryList[index]
                                                        .title ??
                                                    '',
                                                style: BaseTextStyle.headerM,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  ref
                                                      .read(
                                                          navigationStackController)
                                                      .push(
                                                        NavigationStackItem
                                                            .commonSeeAll(
                                                          title:
                                                              exploreScreenWatch
                                                                  .categoryList[
                                                                      index]
                                                                  .title,
                                                        ),
                                                      );
                                                },
                                                child: MyRegularText(
                                                  "VIEW ALL",
                                                  style: BaseTextStyle.lableXs
                                                      .copyWith(
                                                    color: AppColors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 180.h,
                                            width: MediaQuery.sizeOf(context)
                                                .width,
                                            child: ListView.separated(
                                              separatorBuilder: (context, i) {
                                                return SizedBox(width: 3.w);
                                              },
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: ((exploreScreenWatch
                                                              .categoryList[
                                                                  index]
                                                              .data
                                                              ?.length ??
                                                          0) >
                                                      10
                                                  ? 10
                                                  : exploreScreenWatch
                                                          .categoryList[index]
                                                          .data
                                                          ?.length ??
                                                      0),
                                              itemBuilder: (context, catI) {
                                                return Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: GestureDetector(
                                                    behavior:
                                                        HitTestBehavior.opaque,
                                                    onTap: () {
                                                      exploreScreenWatch
                                                              .categoryList[
                                                                  index]
                                                              .title!
                                                              .contains(
                                                        "Actor Ad Space",
                                                      )
                                                          ? ref
                                                              .read(
                                                                  navigationStackController)
                                                              .push(
                                                                NavigationStackItem
                                                                    .detail(
                                                                  contentId: exploreScreenWatch
                                                                          .categoryList[
                                                                              index]
                                                                          .data![
                                                                              catI]
                                                                          .content![
                                                                              catI]
                                                                          .id ??
                                                                      "",
                                                                ),
                                                              )
                                                          : ref
                                                              .read(
                                                                  navigationStackController)
                                                              .push(
                                                                NavigationStackItem
                                                                    .detail(
                                                                  contentId: exploreScreenWatch
                                                                          .categoryList[
                                                                              index]
                                                                          .data?[
                                                                              catI]
                                                                          .contentId ??
                                                                      "",
                                                                ),
                                                              );
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5),
                                                      child: CommonImageView(
                                                        fit: BoxFit.cover,
                                                        radius: getRadious(6),
                                                        imagePath:
                                                            exploreScreenWatch
                                                                    .categoryList[
                                                                        index]
                                                                    .data?[catI]
                                                                    .imageUrl ??
                                                                '',
                                                        url: exploreScreenWatch
                                                                .categoryList[
                                                                    index]
                                                                .data![catI]
                                                                .imageUrl ??
                                                            Config.kNoImage,
                                                        height: 140.h,
                                                        width: 100.w,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        ],
                                      ).paddingSymmetric(
                                        horizontal: 16.w,
                                      );
                              }
                            } else {
                              return SizedBox();
                            }
                          },
                        ),
                        getVerticalHeight(
                          context.height * .1,
                        ),
                      ],
                    )
                  : const SizedBox(),
        ),
      ),
    );
  }

  ListView _adSpace(ExploreController exploreScreenWatch, int index) {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: exploreScreenWatch.categoryList[index].data?.length ?? 0,
      itemBuilder: (context, i) {
        final actorData = exploreScreenWatch.categoryList[index].data?[i];
        return Container(
          margin: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
              image: DecorationImage(
            fit: BoxFit.fitWidth,
            image: AssetImage(Assets.images.bg.path),
          )),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyRegularText(
                    "Best Of ${actorData?.name ?? ""}",
                    style: BaseTextStyle.headerM,
                  ),
                ],
              ).paddingSymmetric(
                vertical: 15.h,
              ),
              SizedBox(
                height: 180.h,
                width: context.width,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: context.width * .25,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(
                          left: context.width * .15,
                        ),
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: ((actorData?.content?.length ?? 0) > 10)
                            ? 10
                            : actorData?.content?.length,
                        itemBuilder: (context, catI) {
                          final actors = actorData?.content?[catI];
                          return Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                exploreScreenWatch.categoryList[index].title!
                                        .contains("Actor Ad Space")
                                    ? ref.read(navigationStackController).push(
                                          NavigationStackItem.detail(
                                            contentId: actors?.id ?? "",
                                          ),
                                        )
                                    : ref.read(navigationStackController).push(
                                          NavigationStackItem.detail(
                                            contentId:
                                                actorData?.contentId ?? "",
                                          ),
                                        );
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.h,
                                ),
                                child: CommonImageView(
                                  fit: BoxFit.cover,
                                  radius: getRadious(6),
                                  url: actors?.posterPath ?? '',
                                  height: 140.h,
                                  width: 100.w,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      left: 0,
                      child: CommonImageView(
                        fit: BoxFit.cover,
                        radius: getRadious(6),
                        url: actorData?.imageUrl ?? '',
                        height: 180.h,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).paddingSymmetric(
            horizontal: 10.h,
          ),
        );
      },
    );
  }
}
