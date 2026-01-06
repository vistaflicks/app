import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:vista_flicks/ui/routing/navigation_stack_item.dart';
import 'package:vista_flicks/ui/routing/stack.dart';

import '../../../../../../core/values/size_constant.dart';
import '../../../../../../core/values/text_styles/base_textstyle.dart';
import '../../../../../../framework/controller/main/preview_and_detail/detail/detail_controller.dart';
import '../../../../../../gen/assets.gen.dart';

class SimilarTab extends ConsumerWidget {
  const SimilarTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final similarScreenWatch = ref.watch(detailController);
    final data = similarScreenWatch.similarListState.success?.data ?? [];

    return similarScreenWatch.isLoading
        ? const Center(child: CircularProgressIndicator())
        : data.isEmpty
            ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(
                        // animate: false,
                        height: getHeight(150.h),
                        width: getWidth(150.w),
                        fit: BoxFit.fitWidth,
                        Assets.lottie.dataNotFound2),
                    Text(
                      "No Review Found",
                      style: BaseTextStyle.textMl,
                    )
                  ],
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.7,
                ),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final imageUrl = similarScreenWatch
                      .similarListState.success?.data?[index].imageUrl;

                  return GestureDetector(
                    onTap: () {
                      final navigationStack =
                          ref.read(navigationStackController);
                      final contentId = similarScreenWatch
                              .similarListState.success?.data?[index].id ??
                          "";

                      final newScreen =
                          NavigationStackItem.detail(contentId: contentId);

                      if (!navigationStack.isScreenAlreadyInStack(newScreen)) {
                        navigationStack.pushRemove(newScreen);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: imageUrl != null && imageUrl.isNotEmpty
                            ? DecorationImage(
                                image: CachedNetworkImageProvider(imageUrl),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      // child: imageUrl == null || imageUrl.isEmpty
                      //     ? const Center(child: Icon(Icons.broken_image))
                      //     : null,
                    ),
                  );
                },
              );
  }
}
