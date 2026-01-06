import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/ui/utils/theme/theme.dart';

import '../../../../../core/values/app_colours.dart';

class ExploreShimmer extends StatelessWidget {
  const ExploreShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Shimmer.fromColors(
        baseColor: AppColors.black.withOpacity(0.2),
        highlightColor: AppColors.black,
        child: Column(
          children: [
            getVerticalHeight(50),
            Container(
              height: 20,
              width: MediaQuery.sizeOf(context).width,
              color: AppColors.primary,
            ),
            getVerticalHeight(20),
            Container(
              height: 30,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.primary,
              ),
            ),
            getVerticalHeight(20),
            Container(
              height: 150,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.primary,
              ),
            ),
            getVerticalHeight(20),
            ...List.generate(
              10,
              (index) {
                return SizedBox(
                  height: 250,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 20,
                            width: 100,
                            color: AppColors.primary,
                          ),
                          Container(
                            height: 20,
                            width: 100,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                      getVerticalHeight(10),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 10,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 200,
                                  width: 150,
                                  margin: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.primary,
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
