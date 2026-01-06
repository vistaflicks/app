import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vista_flicks/framework/controller/main/account_and_pref/terms_of_use/terms_of_use_controller.dart';

import '../../../../../core/values/app_colours.dart';
import '../../../../../core/values/size_constant.dart';
import '../../../../../core/values/text_styles/base_textstyle.dart';
import '../../../../../core/widgets/common_bg_container.dart';
import '../../../../../core/widgets/my_regular_text.dart';
import '../../../../utils/helper/base_widget.dart';
import '../../../../utils/widgets/dialog_progressbar.dart';

class TermsOfUseScreen extends ConsumerStatefulWidget {
  const TermsOfUseScreen({super.key});

  @override
  ConsumerState<TermsOfUseScreen> createState() => _TermsOfUseScreenState();
}

class _TermsOfUseScreenState extends ConsumerState<TermsOfUseScreen>
    with BaseConsumerStatefulWidget {
  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final termsOfUseWatch = ref.read(termsOfUseController);
      termsOfUseWatch.disposeController(isNotify: true);
      await termsOfUseWatch.termsOfUseListApi(context);
    });
  }

  @override
  Widget buildPage(BuildContext context) {
    final termsOfUseWatch = ref.watch(termsOfUseController);
    return Scaffold(
      backgroundColor: AppColors.black.withOpacity(0.2),
      appBar: AppBar(
        backgroundColor: AppColors.black,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        centerTitle: true,
        foregroundColor: AppColors.primeryTxt,
        title: MyRegularText(
          "Terms of Use",
          style: BaseTextStyle.headerM,
        ),
      ),
      body: CommonBgContainer(
        padding: EdgeInsets.symmetric(
            horizontal: getWidth(16), vertical: getHeight(10)),
        child: termsOfUseWatch.termsOfUseApiState.isLoading
            ? DialogProgressBar(isLoading: true)
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome to Vista Reels! By using our app, you agree to these Terms of Use. Please read them carefully before proceeding.",
                      style: BaseTextStyle.textS
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    getVerticalHeight(20),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: termsOfUseWatch.termsOfUseList.length,
                      itemBuilder: (context, index) {
                        return CommonExpansionTile(
                          title:
                              "${index + 1}.  ${termsOfUseWatch.termsOfUseList[index].question.toString()}",
                          sunTitle: termsOfUseWatch.termsOfUseList[index].answer
                              .toString(),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class CommonExpansionTile extends StatelessWidget {
  final String title;
  final String sunTitle;

  const CommonExpansionTile({
    required this.title,
    required this.sunTitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          title,
          style: BaseTextStyle.textXs,
        ),
        collapsedBackgroundColor: AppColors.transparent,
        childrenPadding: EdgeInsets.symmetric(horizontal: getWidth(16)),
        children: [
          Text(
            sunTitle,
            style: BaseTextStyle.lableS,
          ),
        ],
      ),
    );
  }
}
