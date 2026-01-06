import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vista_flicks/framework/dependency_injection/inject.dart';
import 'package:vista_flicks/framework/provider/network/network.dart';
import 'package:vista_flicks/ui/utils/const/app_constants.dart';

import '../../../ui/utils/helper/group_chat_manager/group_chat_manager.dart';

final inviteFriendController =
    ChangeNotifierProvider((ref) => getIt<InviteFriendController>());

@injectable
class InviteFriendController extends ChangeNotifier {
  bool isLoading = false;

  updateIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  /// Capture Widget
  final ScreenshotController screenshotController = ScreenshotController();

  /// Share QR Code
  Future<void> shareQRCode({required String joinLink}) async {
    try {
      updateIsLoading(true);
      final Uint8List? image = await screenshotController.capture();
      if (image != null) {
        final directory = await getTemporaryDirectory();
        final filePath = "${directory.path}/qr.png";
        final file = File(filePath);
        await file.writeAsBytes(image);

        await Share.shareXFiles(
          [XFile(file.path)],
          text: "Join my group chat on VistaReels App!\n$joinLink",
          subject: "VistaReels Group Invite",
        );
      }
      updateIsLoading(false);
    } catch (e) {
      showLog('Error $e');
    } finally {
      updateIsLoading(false);
    }
  }

  /// Share QR Code and Capture From Widget
  Future<void> shareQRCodeCaptureFromWidget({required String joinLink}) async {
    try {
      updateIsLoading(true);
      final uri = Uri.parse(joinLink);
      final groupId = uri.queryParameters['groupId'];
      final Uint8List image = await screenshotController.captureFromWidget(
        QrImageView(
          data: '$staticGroupChatUrl$groupId',
          version: QrVersions.auto,
          size: 200.0,
          backgroundColor: Colors.white,
        ),
      );
      final directory = await getTemporaryDirectory();
      final filePath = "${directory.path}/qr.png";
      final file = File(filePath);
      await file.writeAsBytes(image);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: "Join my group chat on VistaReels App!\n$joinLink",
        subject: "VistaReels Group Invite",
      );
      updateIsLoading(false);
    } catch (e) {
      showLog('Error $e');
    } finally {
      updateIsLoading(false);
    }
  }

  String groupName = '';

  /// Get Group Details
  getGroupDetails(String groupUrl) async {
    final uri = Uri.parse(groupUrl);
    final groupId = uri.queryParameters['groupId'];

    final groupDetails =
        await GroupChatManager.instance.getGroupDetails(groupId ?? '');

    groupName = groupDetails?.groupName ?? '';
    notifyListeners();
  }
}
