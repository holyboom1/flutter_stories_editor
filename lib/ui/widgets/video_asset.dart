// import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../flutter_stories_editor.dart';
import '../../models/story_element.dart';
import 'base_story_element.dart';

class VideoAsset extends StatefulWidget {
  final StoryElement storyElement;
  final bool isEditing;
  final Size screen;
  final EditorController editorController;

  const VideoAsset({
    super.key,
    required this.storyElement,
    required this.screen,
    required this.isEditing,
    required this.editorController,
  });

  @override
  State<VideoAsset> createState() => _VideoAssetState();
}

class _VideoAssetState extends State<VideoAsset> {
  bool isControllerInitialized = false;

  late double videoWidth;
  late double videoHeight;
  late double topVideoCropPercent;
  late double bottomVideoCropPercent;
  late double leftVideoCropPercent;
  late double rightVideoCropPercent;

  late double leftCropContainer;
  late double topCropContainer;
  late double rightCropContainer;
  late double bottomCropContainer;

  late double containerWidth;
  late double containerHeight;

  @override
  void initState() {
    super.initState();

    if (widget.storyElement.videoController != null &&
        !widget.storyElement.videoController!.initialized) {
      widget.storyElement.videoController?.initialize();
      isControllerInitialized = true;
      setState(() {});
    } else if (widget.storyElement.videoController != null &&
        widget.storyElement.videoController!.initialized) {
      isControllerInitialized = true;
    }
    videoWidth = widget.storyElement.videoController!.videoWidth;
    videoHeight = widget.storyElement.videoController!.videoHeight;
    topVideoCropPercent = widget.storyElement.videoController!.minCrop.dy;
    bottomVideoCropPercent =
        1 - widget.storyElement.videoController!.maxCrop.dy;
    leftVideoCropPercent = widget.storyElement.videoController!.minCrop.dx;
    rightVideoCropPercent = 1 - widget.storyElement.videoController!.maxCrop.dx;
    containerWidth = widget.screen.width;
    containerHeight = containerWidth * (videoHeight / videoWidth);
    leftCropContainer = leftVideoCropPercent * containerWidth;
    topCropContainer = topVideoCropPercent * containerHeight;
    rightCropContainer = rightVideoCropPercent * containerWidth;
    bottomCropContainer = bottomVideoCropPercent * containerHeight;

    final double w = (widget.screen.width -
            (containerWidth - leftCropContainer - rightCropContainer)) /
        2 /
        widget.screen.width;
    final double h = (widget.screen.height -
            ((containerHeight - topCropContainer - bottomCropContainer) *
                (widget.storyElement.videoController!.videoHeight /
                    widget.storyElement.videoController!.videoWidth))) /
        2 /
        widget.screen.height;
    widget.storyElement.position = Offset(w, h);
  }

  @override
  Widget build(BuildContext context) {
    if (!isControllerInitialized) {
      return Container();
    }
    return BaseStoryElement(
      editorController: widget.editorController,
      isEditing: widget.isEditing,
      storyElement: widget.storyElement,
      screen: widget.screen,
      child: Container(
        width: containerWidth - leftCropContainer - rightCropContainer,
        height: containerHeight - topCropContainer - bottomCropContainer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: -leftCropContainer,
              top: -topCropContainer,
              child: SizedBox(
                height: containerHeight,
                width: containerWidth,
                child: VideoPlayer(widget.storyElement.videoController!.video),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
