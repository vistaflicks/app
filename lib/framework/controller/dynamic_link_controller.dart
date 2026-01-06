import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vista_flicks/framework/controller/main/reel/reels_controller.dart';
import 'package:vista_flicks/ui/routing/navigation_stack_item.dart';
import 'package:vista_flicks/ui/routing/stack.dart';

// State class to hold the dynamic link state
class DynamicLinkState {
  final bool isLoading;
  final String? error;
  final String? shareUrl;
  final NavigationStackItem? pendingNavigation;
  final bool isNavigating;

  DynamicLinkState({
    this.isLoading = false,
    this.error,
    this.shareUrl,
    this.pendingNavigation,
    this.isNavigating = false,
  });

  DynamicLinkState copyWith({
    bool? isLoading,
    String? error,
    String? shareUrl,
    NavigationStackItem? pendingNavigation,
    bool? isNavigating,
  }) {
    return DynamicLinkState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      shareUrl: shareUrl ?? this.shareUrl,
      pendingNavigation: pendingNavigation ?? this.pendingNavigation,
      isNavigating: isNavigating ?? this.isNavigating,
    );
  }
}

// Provider for the DynamicLinkController
final dynamicLinkControllerProvider =
    StateNotifierProvider<DynamicLinkController, DynamicLinkState>((ref) {
  return DynamicLinkController(ref);
});

class DynamicLinkController extends StateNotifier<DynamicLinkState> {
  final Ref ref;

  DynamicLinkController(this.ref) : super(DynamicLinkState()) {
    _initDynamicLinks();
  }

  StreamController<String> controllerData = StreamController<String>();
  StreamController<String> controllerInitSession = StreamController<String>();
  StreamSubscription<Map>? streamSubscription;

  // Add a flag to track if the link was clicked
  bool _wasLinkClicked = false;

  @override
  void dispose() {
    streamSubscription?.cancel();
    controllerData.close();
    controllerInitSession.close();
    super.dispose();
  }

  Future<void> _initDynamicLinks() async {
    log('Initializing Branch SDK...');
    await FlutterBranchSdk.init(
      enableLogging: true,
      branchAttributionLevel: BranchAttributionLevel.NONE,
    );
    log('Branch SDK initialized');

    // Check for initial deep link data
    final initialData = await FlutterBranchSdk.getLatestReferringParams();
    log('Initial deep link data: $initialData');

    if (initialData.containsKey('+clicked_branch_link') &&
        initialData['+clicked_branch_link'] == true) {
      log('Processing initial deep link data');
      extractDeepLinkData(initialData);
    }
  }

  void listenDynamicLinks() {
    log('Setting up deep link listener...');
    streamSubscription = FlutterBranchSdk.listSession().listen((data) async {
      log('Received deep link data: $data');
      controllerData.sink.add(data.toString());

      if (data.containsKey('+clicked_branch_link') &&
          data['+clicked_branch_link'] == true) {
        log('Processing deep link from listener');
        extractDeepLinkData(data);
      }
    }, onError: (error) {
      log('Branch SDK Error: ${error.toString()}');
    });

    // Check for any pending deep links
    FlutterBranchSdk.getLatestReferringParams().then((data) {
      log('Checking for pending deep links: $data');
      if (data.containsKey('+clicked_branch_link') &&
          data['+clicked_branch_link'] == true) {
        log('Processing pending deep link');
        extractDeepLinkData(data);
      }
    });
  }

  void extractDeepLinkData(Map<dynamic, dynamic> data) {
    log('Processing deep link data: $data');

    // Check if this is a clicked link
    _wasLinkClicked = data.containsKey('+clicked_branch_link') &&
        data['+clicked_branch_link'] == true;

    // Extract parameters directly from the data map
    String? contentId = data['contentId'] as String?;
    String? type = data['type'] as String?;
    String? reelId = data['reelId'] as String?;

    log('Extracted parameters - contentId: $contentId, type: $type, reelId: $reelId, wasClicked: $_wasLinkClicked');

    if (contentId != null && type != null) {
      // Create a URI with the extracted parameters
      Uri uri = Uri(
        scheme: 'https',
        path: 'content',
        queryParameters: {
          'id': contentId,
          'type': type,
          if (reelId != null && reelId.isNotEmpty) 'reelId': reelId,
        },
      );

      log('Created URI for navigation: $uri');
      _handleDynamicLink(uri);
    } else {
      log('Required parameters not found in deep link data');
    }
  }

  Future<void> saveAndShare(
    BuildContext context,
    String content, {
    String? image,
    VoidCallback? fun,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      if (image != null) {
        // Download the image
        final response = await http.get(Uri.parse(image));
        final directory = await getTemporaryDirectory();
        final file = File('${directory.path}/image.png');
        await file.writeAsBytes(response.bodyBytes);

        // Create a formatted text that includes both content and link
        final formattedText = '''
$content

Check it out on VistaReels: ${state.shareUrl}
''';

        // Share both the image and text
        final result = await Share.shareXFiles(
          [XFile(file.path)],
          text: formattedText,
          subject: "VistaReels Post",
        );

        if (result.status == ShareResultStatus.success) {
          fun?.call();
        }
      } else {
        // For text-only sharing, include the link in a more prominent way
        final formattedText = '''
$content

Check it out on VistaReels: ${state.shareUrl}
''';

        final result = await Share.share(
          formattedText,
          subject: "VistaReels Post",
        );

        if (result.status == ShareResultStatus.success) {
          fun?.call();
        }
      }
    } catch (e) {
      log('Error during sharing: $e');
    }

    state = state.copyWith(isLoading: false);
  }

  Future<void> createImageDynamicLink(
    bool short,
    String link,
    String content, {
    VoidCallback? fun,
    BuildContext? context,
  }) async {
    if (context == null) {
      log("Error: Context is null when creating image dynamic link");
      return;
    }

    showLoaderDialog(context);

    BranchUniversalObject buo = BranchUniversalObject(
      canonicalIdentifier: 'content/$link',
      title: 'VistaReels Post',
      contentMetadata: BranchContentMetaData()
        ..addCustomMetadata("id", link)
        ..addCustomMetadata("type", "image"),
    );

    BranchLinkProperties lp = BranchLinkProperties()
      ..addControlParam("id", link)
      ..addControlParam("type", "image");

    BranchResponse response = await FlutterBranchSdk.getShortUrl(
      buo: buo,
      linkProperties: lp,
    );

    if (response.success) {
      state = state.copyWith(shareUrl: Uri.parse(response.result).toString());
      await saveAndShare(context, content, fun: fun);
      Navigator.pop(context);
    } else {
      log("Error creating link: ${response.errorMessage}");
    }

    state = state.copyWith(error: response.errorMessage);
  }

  Future<void> createDynamicLink(
    bool short,
    String content, {
    String? image,
    String? contentId,
    String? reelId,
    VoidCallback? fun,
    BuildContext? context,
  }) async {
    if (context == null) {
      log("Error: Context is null when creating dynamic link");
      return;
    }

    showLoaderDialog(context);

    BranchUniversalObject buo = BranchUniversalObject(
      canonicalIdentifier: 'content/$contentId',
      title: 'VistaReels Post',
      contentMetadata: BranchContentMetaData()
        ..addCustomMetadata(
            "type", reelId != null && reelId.isNotEmpty ? "reel" : "content")
        ..addCustomMetadata("contentId", contentId ?? "")
        ..addCustomMetadata("reelId", reelId ?? ""),
    );

    BranchLinkProperties lp = BranchLinkProperties()
      ..addControlParam(
          "type", reelId != null && reelId.isNotEmpty ? "reel" : "content")
      ..addControlParam("contentId", contentId ?? "")
      ..addControlParam("reelId", reelId ?? "");

    BranchResponse response = await FlutterBranchSdk.getShortUrl(
      buo: buo,
      linkProperties: lp,
    );

    if (response.success) {
      state = state.copyWith(shareUrl: Uri.parse(response.result).toString());
      Navigator.pop(context);
      await saveAndShare(context, content, image: image, fun: fun);
    } else {
      log("Error creating link: ${response.errorMessage}");
    }

    state = state.copyWith(error: response.errorMessage);
  }

  void showLoaderDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 10),
            const Text("Loading..."),
          ],
        ),
      ),
    );
  }

  void _handleDynamicLink(Uri uri) {
    final params = uri.queryParameters;
    final type = params['type'];
    final id = params['id'];
    final reelId = params['reelId'];

    log('Handling dynamic link - type: $type, id: $id, reelId: $reelId');

    if (type == null || id == null) {
      log('Missing required parameters in URI: $uri');
      return;
    }

    // Check if we're already navigating
    if (state.isNavigating) {
      log('Navigation already in progress, skipping duplicate navigation');
      return;
    }

    // Only proceed if this is a direct deep link click
    if (!_wasLinkClicked) {
      log('Not a direct deep link click, skipping navigation');
      return;
    }

    // Pause all videos in the reels list before navigation
    final reelsControllerInstance = ref.read(reelsController);
    for (var reel in reelsControllerInstance.reelsList) {
      if (reel.videoPlayerController != null) {
        reel.videoPlayerController?.pause();
      }
    }

    // Store the navigation intent in state
    NavigationStackItem? newNavigation;
    if (reelId != null && reelId.isNotEmpty) {
      newNavigation = NavigationStackItem.reel(reelId: reelId, contentId: id);
      log('Setting navigation to reel: $reelId, content: $id');
    } else if (id.isNotEmpty) {
      newNavigation = NavigationStackItem.detail(contentId: id);
      log('Setting navigation to detail: $id');
    }

    // Update state and immediately attempt navigation
    state = state.copyWith(
      pendingNavigation: newNavigation,
      isNavigating: true,
    );
    log('Navigation state updated');

    // Attempt navigation immediately
    _attemptNavigation();
  }

  void _attemptNavigation() {
    if (state.pendingNavigation != null && state.isNavigating) {
      try {
        log('Attempting immediate navigation to: ${state.pendingNavigation}');

        // Get the current navigation stack
        final currentStack = ref.read(navigationStackController);

        // Check if we're already on the target page by comparing the navigation items
        final isAlreadyOnPage = currentStack.items.any(
            (item) => item.toString() == state.pendingNavigation.toString());

        if (!isAlreadyOnPage) {
          // If we're not already on the target page, push the new navigation
          ref.read(navigationStackController).push(state.pendingNavigation!);
          log('Navigation completed successfully');
        } else {
          log('Already on target page, skipping navigation');
        }
      } catch (e) {
        log('Error during navigation: $e');
        // If navigation fails, we'll try again when the app resumes
      } finally {
        // Only reset the navigation state if it's a valid navigation
        if (state.pendingNavigation != null) {
          state = state.copyWith(
            pendingNavigation: null,
            isNavigating: false,
          );
          log('Navigation state reset');
        }
      }
    }
  }

  // Method to be called from the UI to handle pending navigation
  void handlePendingNavigation() {
    log('Handling pending navigation - pending: ${state.pendingNavigation != null}, navigating: ${state.isNavigating}');
    _attemptNavigation();
  }
}
