import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/widgets/common_bg_container.dart';
import 'package:vista_flicks/framework/utils/extension/context_extension.dart';
import 'package:vista_flicks/ui/utils/helper/base_widget.dart';

import '../../../../framework/controller/auth/on_boarding/on_boarding_controller.dart';
import 'helper/continue_with_widget.dart';
import 'helper/sent_buttons_widget.dart';

class OnBoardingScreen extends ConsumerStatefulWidget {
  final bool isEmail;

  const OnBoardingScreen({super.key, required this.isEmail});

  @override
  ConsumerState<OnBoardingScreen> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends ConsumerState<OnBoardingScreen>
    with BaseConsumerStatefulWidget {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final onBoardingWatch = ref.read(onBoardingController);
      onBoardingWatch.disposeController(isNotify: true);
      onBoardingWatch.onInit(inputController);
      onBoardingWatch.isEmail = widget.isEmail;
    });
  }

  /// input controller
  final TextEditingController inputController = TextEditingController();

  @override
  Widget buildPage(BuildContext context) {
    final onBoardingWatch = ref.read(onBoardingController);
    print(
        "Email  controller.isEmail.value =============> : ${onBoardingWatch.isEmail}");

    print("Email  isPhoneLogin =============> : ${widget.isEmail}");
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      /// body
      body: CommonBgContainer(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getVerticalHeight(100),

              /// Continue with Email / Phone Widget
              ContinueWithWidget(
                  isEmail: widget.isEmail, inputController: inputController),
              getVerticalHeight(context.height * .4),

              /// Send Button Widget
              SentButtonsWidget(
                  isEmail: widget.isEmail, inputController: inputController)
            ],
          ),
        ),
      ),
    );
  }
}
