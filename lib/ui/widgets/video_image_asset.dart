// import 'package:cached_video_player/cached_video_player.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';

import '../../flutter_stories_editor.dart';
import '../../models/story_element.dart';
import 'base_story_element.dart';

class VideoImageAsset extends StatefulWidget {
  final StoryElement storyElement;
  final bool isEditing;
  final Size screen;
  final EditorController editorController;
  final Function(bool isInited, Duration currnetPosition)? onVideoEvent;

  const VideoImageAsset({
    required this.storyElement,
    required this.screen,
    required this.isEditing,
    required this.editorController,
    this.onVideoEvent,
    super.key,
  });

  @override
  State<VideoImageAsset> createState() => _VideoImageAssetState();
}

class _VideoImageAssetState extends State<VideoImageAsset> {
  bool isControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    initController();
  }

  double containerWidth = 0;
  double containerHeight = 0;

  void videoListener() {
    widget.onVideoEvent?.call(
      widget.storyElement.videoControllerView?.value.isInitialized ?? false,
      widget.storyElement.videoControllerView?.value.position ?? Duration.zero,
    );
  }

  Future<void> initController() async {
    final double videoWidth;
    final double videoHeight;
    widget.storyElement.videoControllerView =
        CachedVideoPlayerPlusController.networkUrl(
      Uri.parse(
        widget.storyElement.value,
      ),
      invalidateCacheIfOlderThan: const Duration(days: 1),
    );
    await widget.storyElement.videoControllerView?.initialize();
    widget.storyElement.videoControllerView?.addListener(videoListener);
    isControllerInitialized = true;
    videoWidth = widget.storyElement.videoControllerView?.value.size.width ?? 0;
    videoHeight =
        widget.storyElement.videoControllerView?.value.size.height ?? 0;
    containerWidth = widget.screen.width / 2;
    containerHeight = containerWidth * (videoHeight / videoWidth);
    await widget.storyElement.videoControllerView?.setLooping(true);
    await widget.storyElement.videoControllerView?.play();

    setState(() {});
  }

  @override
  void dispose() {
    widget.storyElement.videoController?.video.removeListener(videoListener);
    widget.storyElement.videoController?.dispose();
    widget.storyElement.videoControllerView?.removeListener(videoListener);
    widget.storyElement.videoControllerView?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isControllerInitialized) {
      return Container(
        key: widget.key,
      );
    }

    return BaseStoryElement(
      key: widget.key,
      editorController: widget.editorController,
      isEditing: widget.isEditing,
      storyElement: widget.storyElement,
      screen: widget.screen,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        width: containerWidth,
        height: containerHeight,
        child: CachedVideoPlayerPlus(
          widget.storyElement.videoControllerView!,
          key: widget.key,
        ),
      ),
    );
  }
}
