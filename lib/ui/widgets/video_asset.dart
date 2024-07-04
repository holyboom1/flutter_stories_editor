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
    final double w = (widget.screen.width - (widget.screen.width * 0.7)) / 2 / widget.screen.width;
    final double h = (widget.screen.height -
            ((widget.screen.width * 0.7) *
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

    final double videoWidth = widget.storyElement.videoController!.videoWidth;
    final double videoHeight = widget.storyElement.videoController!.videoHeight;

    final double topCrop = widget.storyElement.videoController!.minCrop.dy * videoHeight;
    final double bottomCrop = (1 - widget.storyElement.videoController!.maxCrop.dy) * videoHeight;
    final double leftCrop = widget.storyElement.videoController!.minCrop.dx * videoWidth;
    final double rightCrop = (1 - widget.storyElement.videoController!.maxCrop.dx) * videoWidth;

    final double effectiveWidth = videoWidth - leftCrop - rightCrop;
    final double effectiveHeight = videoHeight - topCrop - bottomCrop;
    double containerWidth = widget.screen.width * 0.7;

    final double containerHeightFull = containerWidth * (videoHeight / videoWidth);

    final double topCropContainer =
        widget.storyElement.videoController!.minCrop.dy * containerHeightFull;
    final double bottomCropContainer =
        (1 - widget.storyElement.videoController!.maxCrop.dy) * containerHeightFull;
    final double leftCropContainer =
        widget.storyElement.videoController!.minCrop.dx * containerWidth;
    final double rightCropContainer =
        (1 - widget.storyElement.videoController!.maxCrop.dx) * containerWidth;

    final double containerHeight;
    if (effectiveWidth > effectiveHeight) {
      containerHeight = containerWidth * (effectiveHeight / effectiveWidth);
    } else {
      containerHeight = containerWidth * (effectiveWidth / effectiveHeight);
    }
    containerWidth -= leftCropContainer;

    return BaseStoryElement(
      editorController: widget.editorController,
      isEditing: widget.isEditing,
      storyElement: widget.storyElement,
      screen: widget.screen,
      child: Container(
        width: containerWidth,
        height: containerHeight,
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
                width: containerWidth + leftCropContainer + rightCropContainer,
                height: containerHeightFull,
                child: VideoPlayer(widget.storyElement.videoController!.video),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
