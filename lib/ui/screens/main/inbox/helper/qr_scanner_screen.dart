import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/framework/utils/extension/context_extension.dart';
import 'package:vista_flicks/ui/routing/stack.dart';
import 'package:vista_flicks/ui/utils/helper/base_widget.dart';
import 'package:vista_flicks/ui/utils/widgets/dialog_progressbar.dart';

import '../../../../../framework/controller/main/inbox/single_group/single_group_controller.dart';

class QRCodeScannerScreen extends ConsumerStatefulWidget {
  const QRCodeScannerScreen({super.key});

  @override
  ConsumerState<QRCodeScannerScreen> createState() =>
      _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends ConsumerState<QRCodeScannerScreen>
    with BaseConsumerStatefulWidget {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final singleGroupScreenWatch = ref.watch(singleGroupController);
      singleGroupScreenWatch.disposeQrViewController();
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    final singleGroupScreenWatch = ref.watch(singleGroupController);

    if (defaultTargetPlatform == TargetPlatform.android) {
      singleGroupScreenWatch.qrViewController?.pauseCamera();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      singleGroupScreenWatch.qrViewController?.resumeCamera();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    final singleGroupScreenWatch = ref.watch(singleGroupController);
    return Scaffold(
      // backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        leading: IconButton(
            onPressed: () {
              ref.read(navigationStackController).pop();
            },
            icon: const Icon(
              Icons.close,
              color: AppColors.primeryTxt,
            )),
        title: const Text(
          'Scan Vista Reels QR Code',
          style: BaseTextStyle.headerM,
        ),
      ),
      body: Stack(
        children: [
          bodyWidget(),
          DialogProgressBar(isLoading: singleGroupScreenWatch.isLoading),
        ],
      ),
    );
  }

  Widget bodyWidget() {
    final singleGroupScreenWatch = ref.watch(singleGroupController);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Stack(
            children: [
              QRView(
                key: singleGroupScreenWatch.qrKey,
                onQRViewCreated: (controller) {
                  singleGroupScreenWatch.onQRViewCreated(
                      context, controller, ref);
                },
                overlay: QrScannerOverlayShape(
                  borderRadius: 10.r,
                  // borderLength: 100,
                  // cutOutSize: 300,
                  cutOutHeight: 400.h,
                  cutOutWidth: 300.w,
                  borderColor: AppColors.placeholder,
                  overlayColor: AppColors.lightGray2,
                ),
              ),
              Positioned(
                bottom: context.height * .12,
                left: context.width * .1,
                child: const Text(
                  'Scan Vista Reels QR Code to join the group',
                  style: BaseTextStyle.lableM,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
