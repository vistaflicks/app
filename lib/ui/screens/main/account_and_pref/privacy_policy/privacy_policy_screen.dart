import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/framework/controller/main/account_and_pref/privacy_policy/privacy_policy_controller.dart';
import 'package:vista_flicks/ui/utils/widgets/common_html_view.dart';

import '../../../../../core/values/app_colours.dart';
import '../../../../../core/values/size_constant.dart';
import '../../../../../core/values/text_styles/base_textstyle.dart';
import '../../../../../core/widgets/common_bg_container.dart';
import '../../../../../core/widgets/my_regular_text.dart';
import '../../../../utils/helper/base_widget.dart';
import '../../../../utils/widgets/dialog_progressbar.dart';

class PrivacyPolicyScreen extends ConsumerStatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  ConsumerState<PrivacyPolicyScreen> createState() =>
      _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends ConsumerState<PrivacyPolicyScreen>
    with BaseConsumerStatefulWidget {
  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final privacyPolicyWatch = ref.read(privacyPolicyController);
      privacyPolicyWatch.disposeController(isNotify: true);
      await privacyPolicyWatch.termsOfUseListApi(context);
    });
  }

  @override
  Widget buildPage(BuildContext context) {
    final privacyPolicyWatch = ref.watch(privacyPolicyController);
    return Scaffold(
      backgroundColor: AppColors.black.withOpacity(0.2),
      appBar: AppBar(
        backgroundColor: AppColors.black,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        centerTitle: true,
        foregroundColor: AppColors.primeryTxt,
        title: MyRegularText(
          "Privacy Policy",
          style: BaseTextStyle.headerM,
        ),
      ),
      body: CommonBgContainer(
        padding: EdgeInsets.symmetric(
            horizontal: getWidth(16.w), vertical: getHeight(10.h)),
        child: privacyPolicyWatch.privacyPolicyApiState.isLoading
            ? DialogProgressBar(isLoading: true)
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "At Vista Reels, we value your privacy and are committed to protecting your personal information. This Privacy Policy explains how we collect, use, and safeguard your data when you use our app and services.",
                      style: BaseTextStyle.textS
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: privacyPolicyWatch.PrivacyPolicyList.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return CommonPointWidget(
                          point: privacyPolicyWatch
                              .PrivacyPolicyList[index].description,
                        );
                      },
                    )
                    // CommonPointWidget(
                    //   point: "Information We Collect",
                    //   paragraph:
                    //       "With a passion for storytelling and a keen eye on the ever-evolving entertainment industry, we curate the best movies and shows, providing insights, trailers, and recommendations tailored to your preferences. Whether you're looking for the next binge-worthy series or an exciting new film, Vista Flicks is your go-to destination for navigating the vast world of digital entertainment.",
                    // ),
                    // CommonPointWidget(
                    //   point: "How We Use Your Information",
                    //   paragraph:
                    //       "The information we collect helps us personalize your experience, recommend content that fits your preferences, and improve the app’s functionality. We may use this data to fix bugs, optimize performance, and send you important updates or promotional content (though you can opt out of these communications at any time). Additionally, we use your information to provide you with customer support, respond to inquiries, and address any issues you may encounter.",
                    // ),
                    // CommonPointWidget(
                    //   point: "Data Sharing and Third-Party Services",
                    //   paragraph:
                    //       "We want to assure you that Vista Flicks does not sell or rent your personal data to third parties. However, we may share certain information with trusted service providers that help us with analytics, app functionality, and customer support. It’s important to note that Vista Flicks provides redirections to third-party OTT platforms, but we are not responsible for the content, security practices, or privacy policies of these external platforms. We encourage you to review their respective privacy policies before using their services.",
                    // ),
                    // CommonPointWidget(
                    //   point: "Data Protection and Security",
                    //   paragraph:
                    //       "We are dedicated to ensuring your personal data is safe. We use encryption methods to protect sensitive information and store data on secure servers to prevent unauthorized access. We also implement regular security checks and updates to keep our systems protected and up to date.",
                    // ),
                    // CommonPointWidget(
                    //   point: "Your Rights and Choices",
                    //   paragraph:
                    //       "You have full control over your personal information. You can access and update your account details at any time. If you wish to stop receiving promotional emails, you can easily unsubscribe from them, and you can also disable notifications in your app settings. If you would like to delete your account and remove your personal data from our records, simply contact our support team, and we will assist you.",
                    // ),
                    // CommonPointWidget(
                    //   point: "Changes to This Privacy Policy",
                    //   paragraph:
                    //       "We may update this Privacy Policy from time to time. Any significant changes will be posted on this page, and we may notify you if necessary. By continuing to use Vista Flicks after these updates, you accept the revised Privacy Policy.",
                    // ),
                    // CommonPointWidget(
                    //   point: "Contact Us",
                    //   paragraph:
                    //       "If you have any questions or concerns about this Privacy Policy, please don’t hesitate to get in touch with us. You can reach us by email at privacy@vistaflicks.com or call us at +1 234 567 8900. By using Vista Flicks, you agree to this Privacy Policy.",
                    // ),
                  ],
                ),
              ),
      ),
    );
  }
}

class CommonPointWidget extends StatelessWidget {
  final point;

  // final paragraph;

  const CommonPointWidget({
    required this.point,
    // required this.paragraph,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getVerticalHeight(10.h),
        CommonHtmlView(
          dataString: "$point",
          textStyle: BaseTextStyle.textS.copyWith(fontWeight: FontWeight.w500),
        ),
        // Text(
        //   paragraph,
        //   style: BaseTextStyle.textS.copyWith(
        //       fontWeight: FontWeight.w500, color: AppColors.secondaryTxt),
        // ),
      ],
    );
  }
}
