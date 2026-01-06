// About Tab
// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vista_flicks/core/utils/config.dart';
import 'package:vista_flicks/core/utils/url_launchers.dart';
import 'package:vista_flicks/framework/controller/main/preview_and_detail/model/get_about_content_model.dart';
import 'package:vista_flicks/framework/utils/extension/string_extension.dart';
import 'package:vista_flicks/gen/assets.gen.dart';
import 'package:vista_flicks/ui/screens/main/preview_and_detail/detail/helper/about_shimmer.dart';
import 'package:vista_flicks/ui/utils/widgets/common_text.dart';

import '../../../../../../core/values/app_colours.dart';
import '../../../../../../core/values/size_constant.dart';
import '../../../../../../core/values/text_styles/base_textstyle.dart';
import '../../../../../../core/widgets/common_image_view.dart';
import '../../../../../../core/widgets/my_regular_text.dart';
import '../../../../../../framework/controller/main/preview_and_detail/detail/detail_controller.dart';

class AboutTab extends ConsumerWidget {
  const AboutTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutTabWatch = ref.watch(detailController);
    if (aboutTabWatch.getAboutContentModelState.isLoading) {
      return AboutShimmer();
    }
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (aboutTabWatch
                  .getAboutContentModelState.success?.data?.imdbRating !=
              null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  // height: 50,
                  // width: 50,
                  Assets.images.imdb,
                ),
                // Row(
                //   children: [
                //     SvgPicture.asset(
                //       // height: 50,
                //       // width: 50,
                //       Assets.images.imdb,
                //     ),
                //     getHorizonatlWidth(10),
                //     MyRegularText(
                //       "${aboutTabWatch.getAboutContentModelState.success?.data?.imdbRating ?? "0"}",
                //       // "7.7/10 350k Reviews",
                //       style: BaseTextStyle.textM,
                //     ),
                //   ],
                // ),

                GestureDetector(
                  onTap: () {
                    UrlLaunchers.openLink(
                        link: aboutTabWatch
                            .getAboutContentModelState.success?.data?.imdbRating
                        // "https://www.imdb.com/title/tt0468569/?ref_=chttp_t_3",
                        );
                  },
                  child: SvgPicture.asset(
                    Assets.icons.tablerIconArrowDownLeft,
                    color: AppColors.secondaryTxt,
                  ),
                )
              ],
            ),
          getVerticalHeight(20),
          Row(
            children: [
              SvgPicture.asset(
                height: getHeight(18),
                Assets.icons.tablerIconClockHour7,
                color: AppColors.primeryTxt,
              ),
              getHorizonatlWidth(10),
              MyRegularText(
                formatDuration(aboutTabWatch
                        .getAboutContentModelState.success?.data?.duration ??
                    ''),
                style: BaseTextStyle.textM,
              ),
              getHorizonatlWidth(40),
              SvgPicture.asset(
                height: getHeight(18),
                Assets.icons.tablerIconCalendarEvent,
                color: AppColors.primeryTxt,
              ),
              getHorizonatlWidth(10),
              MyRegularText(
                (aboutTabWatch.getAboutContentModelState.success?.data
                            ?.releaseDate ??
                        '')
                    .getCustomDateTimeFromUTC('dd MMM yyyy'),
                // "24 Mar 2024",
                style: BaseTextStyle.textM,
              ),
            ],
          ),
          getVerticalHeight(20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                aboutTabWatch.getAboutContentModelState.success?.data?.genres
                        ?.length ??
                    0,
                (index) {
                  var genre = aboutTabWatch
                      .getAboutContentModelState.success?.data?.genres?[index];
                  return Container(
                    decoration: BoxDecoration(color: AppColors.lightGray2),
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.symmetric(horizontal: getWidth(5)),
                    child: MyRegularText(
                      genre?.name ?? "",
                      style: BaseTextStyle.lableXs,
                    ),
                  );
                },
              ),
            ),
          ),
          getVerticalHeight(20),
          MyRegularText(
            "About",
            style: BaseTextStyle.lableM.copyWith(color: AppColors.secondaryTxt),
          ),
          getVerticalHeight(10),
          Text(
            aboutTabWatch.getAboutContentModelState.success?.data?.about ?? "",
            // "With the price on his head ever increasing, John Wick uncovers a path to defeating The High Table. But before he can earn his freedom, Wick must face off against a new enemy with powerful alliances across the globe and forces that turn old friends into foes.",
            style: BaseTextStyle.lableM.copyWith(color: AppColors.primeryTxt),
          ),
          getVerticalHeight(20),
          CastCrewWidget(
            items:
                aboutTabWatch.getAboutContentModelState.success?.data?.cast ??
                    [],
            title: "Cast",
          ),
          CastCrewWidget(
            items:
                aboutTabWatch.getAboutContentModelState.success?.data?.crew ??
                    [],
            title: "Team",
          ),
        ],
      ),
    );
  }
}

String formatDuration(String duration) {
  if (duration.isEmpty || !duration.contains(':')) return '00:00';

  List<String> parts = duration.split(':');
  String hours = parts[0].padLeft(2, '0');
  String minutes = parts[1].padLeft(2, '0');

  return '$hours:$minutes';
}

class CastCrewWidget extends StatelessWidget {
  final List<Cast> items;
  final String title;

  const CastCrewWidget({
    super.key,
    required this.items,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    // Sort by avatar presence
    List<Cast> sortedItems = List.from(items)
      ..sort((a, b) {
        int aHasImage = (a.avatar?.isNotEmpty ?? false) ? 1 : 0;
        int bHasImage = (b.avatar?.isNotEmpty ?? false) ? 1 : 0;
        return bHasImage - aHasImage; // Show images first
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: BaseTextStyle.lableM.copyWith(color: AppColors.secondaryTxt),
        ),
        getVerticalHeight(10),
        sortedItems.isEmpty
            ? CommonText(title: "$title is Not Available")
            : SizedBox(
                height: 125.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => SizedBox(
                    width: 15.w,
                  ),
                  itemCount: sortedItems.length,
                  itemBuilder: (context, index) {
                    var item = sortedItems[index];

                    return SizedBox(
                      width: 80.w,
                      // height: 125.h,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CommonImageView(
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                              url: item.avatar ?? Config.kNoUserImage,
                            ),
                          ),
                          // Text(
                          //   item.movieName ?? "",
                          //   style: BaseTextStyle.lableXs,
                          // ),
                          getVerticalHeight(5.h),
                          if (item.characterName != null)
                            MyRegularText(
                              item.characterName ?? "",
                              style: BaseTextStyle.textXs.copyWith(
                                color: AppColors.primeryTxt,
                              ),
                            ),
                          MyRegularText(
                            item.name ?? "",
                            style: BaseTextStyle.textXs
                                .copyWith(color: AppColors.secondaryTxt),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
        getVerticalHeight(20),
      ],
    );
  }
}
