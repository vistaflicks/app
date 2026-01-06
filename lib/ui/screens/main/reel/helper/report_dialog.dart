import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/framework/controller/main/reel/reels_controller.dart';
import 'package:vista_flicks/framework/utils/extension/extension.dart';
import 'package:vista_flicks/ui/utils/widgets/common_dialogs.dart';
import 'package:vista_flicks/ui/utils/widgets/common_form_field.dart';
import 'package:vista_flicks/ui/utils/widgets/dropdown/common_form_field_dropdown.dart';

import '../../../../../core/values/text_styles/base_textstyle.dart';
import '../../../../../framework/provider/network/network.dart';
import '../../../../utils/widgets/common_button.dart';

class ReportDialog extends ConsumerWidget {
  const ReportDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reelsScreenWatch = ref.watch(reelsController);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Report",
          style: BaseTextStyle.headerM.copyWith(fontSize: 50.sp),
        ).paddingOnly(top: 15.h),
        SizedBox(
          width: 250.w,
          child: Text(
            "Submitting a report helps us improve your experience. You won't be able to edit the report after submission.",
            style: BaseTextStyle.headerM.copyWith(fontSize: 15.sp),
          ).paddingOnly(top: 15.h),
        ),
        // CommonInputFormField(
        //   textEditingController: reelsScreenWatch.reportController,
        //   hintText: "Enter you report here......",
        //   maxLines: 5,
        //   backgroundColor: AppColors.border,
        //   borderColor: AppColors.border,
        //   borderRadius: BorderRadius.circular(16.r),
        // ).paddingSymmetric(vertical: 10.h, horizontal: 15.w),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
          child: CommonDropdownInputFormField<String>(
            menuItems: reelsScreenWatch.reportReasons,
            hintText: 'Select a reason',
            borderColor: AppColors.border,
            borderRadius: 16.r,
            isEnabled: true,
            // Set dropdown open background color to white
            // and selected item text style to white
            selectedItemBuilder: (context) {
              return reelsScreenWatch.reportReasons.map((item) {
                final isSelected = item == reelsScreenWatch.selectedReason;
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item,
                    style: BaseTextStyle.headerM.copyWith(
                      fontSize: 15.sp,
                      color: isSelected ? Colors.white : AppColors.black,
                    ),
                  ),
                );
              }).toList();
            },
            // Set dropdown menu background color
            items: reelsScreenWatch.reportReasons
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: BaseTextStyle.headerM
                          .copyWith(fontSize: 15.sp, color: AppColors.black),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              reelsScreenWatch.selectedReason = value;
              if (reelsScreenWatch.selectedReason != 'Other') {
                reelsScreenWatch.reportController.clear();
              }
              reelsScreenWatch.updateWidget();
            },
          ),
        ),
        // Show text field only if 'Other' is selected
        if (reelsScreenWatch.selectedReason == 'Other')
          CommonInputFormField(
            textEditingController: reelsScreenWatch.reportController,
            hintText: "Enter your report here...",
            maxLines: 5,
            backgroundColor: AppColors.border,
            borderColor: AppColors.border,
            borderRadius: BorderRadius.circular(16.r),
          ).paddingSymmetric(vertical: 10.h, horizontal: 15.w),
        CommonButton(
          buttonText: 'Report',
          buttonEnabledColor: AppColors.red,
          borderRadius: BorderRadius.circular(100.r),
          buttonTextStyle: BaseTextStyle.headerM
              .copyWith(fontSize: 15.sp, color: Colors.white),
          onTap: () {
            final isOther = reelsScreenWatch.selectedReason == 'Other';
            final reportText = reelsScreenWatch.reportController.text;
            final reason =
                isOther ? reportText : reelsScreenWatch.selectedReason;
            if (reason?.isNotEmpty == true) {
              reelsScreenWatch
                  .postReport(context: context, report: reason)
                  .whenComplete(
                () {
                  Navigator.of(context).pop();
                  reelsScreenWatch.reportController.clear();
                  showSuccessDialog(
                    context,
                    "Report submitted successfully",
                    "Thank you for your feedback!",
                    () {},
                  );
                },
              );
            }
          },
        ).paddingSymmetric(vertical: 10.h, horizontal: 15.w),
        CommonButton(
          buttonText: 'Cancel',
          buttonEnabledColor: AppColors.black,
          borderRadius: BorderRadius.circular(100.r),
          buttonTextStyle: BaseTextStyle.headerM
              .copyWith(fontSize: 15.sp, color: Colors.white),
          onTap: () {
            reelsScreenWatch.reportController.clear();
            Navigator.of(context).pop();
          },
        ).paddingSymmetric(vertical: 10.h, horizontal: 15.w),
      ],
    );
  }
}
