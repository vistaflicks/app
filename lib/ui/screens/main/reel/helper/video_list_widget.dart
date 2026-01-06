import 'dart:developer';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:vista_flicks/framework/controller/main/reel/reels_controller.dart';
import 'package:vista_flicks/framework/repository/common_response/streaming_video_response_model.dart';
import 'package:vista_flicks/framework/repository/reels/model/get_reels_list_response_model.dart';

import '../../../../utils/theme/app_colors.dart';

class VideoListWidget extends ConsumerStatefulWidget {
  final VideoData? videoListData;
  final Function() onVideoCompleteEvent;
  final ReelModel? reelModel;

  const VideoListWidget(
      {super.key,
      this.videoListData,
      required this.onVideoCompleteEvent,
      this.reelModel});

  @override
  ConsumerState<VideoListWidget> createState() => _VideoListWidgetState();
}

class _VideoListWidgetState extends ConsumerState<VideoListWidget> {
  late BetterPlayerController _controller;
  bool isError = false;
  bool isLoading = true;
  bool showMuteIcon = false;
  bool isLongPressActive = false;

  // Lock the screen orientation to portrait when the video is playing
  void _lockOrientation() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void initState() {
    super.initState();
    // _initializePlayer();
    _initializeVideoPlayer();
    _lockOrientation();
  }

  void _initializePlayer() {
    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.reelModel?.videoUrl ?? '',
      // bufferingConfiguration: BetterPlayerBufferingConfiguration(
      //   minBufferMs: 2000,
      //   maxBufferMs: 10000,
      //   bufferForPlaybackMs: 1000,
      //   bufferForPlaybackAfterRebufferMs: 2000,
      // ),
      cacheConfiguration: BetterPlayerCacheConfiguration(
        useCache: true,
        maxCacheSize: 100 * 1024 * 1024, // 100 MB cache
        maxCacheFileSize: 10 * 1024 * 1024, // 10 MB per file
      ),
      drmConfiguration: null,
    );

    _controller = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: true,
        aspectRatio: 9 / 18,
        // fullScreenByDefault: true,
        handleLifecycle: true,
        fit: BoxFit.contain,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          showControls: false,
        ),
      ),
    )..setupDataSource(dataSource);

    // Add listener to handle video completion
    _controller.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
        widget.onVideoCompleteEvent();
      }
    });
  }

  // Validate URL before initializing
  bool _isValidUrl(String url) {
    Uri? uri = Uri.tryParse(url);
    return uri != null && (uri.scheme == "http" || uri.scheme == "https");
  }

  Future<void> _initializeVideoPlayer() async {
    final reelsWatch = ref.read(reelsController);

    log("video URL => ${widget.reelModel?.videoUrl}");
    final videoUrl = widget.reelModel?.videoUrl ?? '';

    if (!_isValidUrl(videoUrl)) {
      setState(() => isError = true);
      return;
    }

    try {
      widget.reelModel?.videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(videoUrl))
            ..addListener(() {
              if (widget.reelModel?.videoPlayerController?.value.position ==
                  widget.reelModel?.videoPlayerController?.value.duration) {
                // widget.onVideoCompleteEvent();
                widget.reelModel?.videoPlayerController?.play();
              }
            })
            ..initialize().then((_) {
              setState(() {
                isLoading = false;
              });
              if (reelsWatch.isMute) {
                widget.reelModel?.videoPlayerController?.setVolume(0);
              } else {
                widget.reelModel?.videoPlayerController?.setVolume(1);
              }
              widget.reelModel?.videoPlayerController?.play();
            }).catchError((error) {
              log("❌ Video Initialization Error: $error");
              setState(() => isError = true);
            });
    } catch (e) {
      log("❌ Exception: $e");
      setState(() => isError = true);
    }
  }

  // Lock screen orientation to portrait when entering full screen

  @override
  void dispose() {
    // _controller.dispose();
    widget.reelModel?.videoPlayerController?.dispose();
    super.dispose();
  }

  void _toggleMute() {
    final reelsWatch = ref.read(reelsController);
    if (widget.reelModel?.videoPlayerController != null &&
        widget.reelModel?.videoPlayerController?.value.isInitialized == true) {
      widget.reelModel?.videoPlayerController!.play();
      setState(() {
        reelsWatch.isMute = !reelsWatch.isMute;
        widget.reelModel?.videoPlayerController!
            .setVolume(reelsWatch.isMute ? 0 : 1);
        showMuteIcon = true;
      });

      // Hide the icon after 500 milliseconds
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          showMuteIcon = false;
        });
      });
    }
  }

  void _handleLongPressDown() {
    isLongPressActive = true;
    Future.delayed(const Duration(milliseconds: 300), () {
      if (isLongPressActive &&
          widget.reelModel?.videoPlayerController != null &&
          widget.reelModel?.videoPlayerController!.value.isPlaying == true) {
        widget.reelModel?.videoPlayerController!.pause();
      }
    });
  }

  void _handleLongPressUp() {
    isLongPressActive = false;
    if (widget.reelModel?.videoPlayerController != null &&
        !widget.reelModel!.videoPlayerController!.value.isPlaying) {
      widget.reelModel?.videoPlayerController!.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final reelsWatch = ref.read(reelsController);
    log("widget.reelModel?.videoPlayerController => ${widget.reelModel?.videoUrl}");
    return AspectRatio(
      aspectRatio: 9 / 17.5,
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: _toggleMute,
            behavior: HitTestBehavior.translucent,
            child:
                widget.reelModel?.videoPlayerController?.value.isInitialized ==
                        true
                    ? VideoPlayer(widget.reelModel!.videoPlayerController!)
                    : Shimmer.fromColors(
                        baseColor: AppColors.black.withOpacity(0.2),
                        highlightColor: AppColors.black,
                        child: Container(
                          height: MediaQuery.sizeOf(context).height,
                          width: MediaQuery.sizeOf(context).width,
                          color: AppColors.primary,
                        ),
                      ),
          ),
          if (showMuteIcon)
            Positioned(
              child: AnimatedOpacity(
                opacity: showMuteIcon ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    reelsWatch.isMute ? Icons.volume_off : Icons.volume_up,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
