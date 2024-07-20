// import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../flutter_stories_editor.dart';
import '../../models/story_element.dart';
import '../../utils/video_editor/lib/domain/bloc/controller.dart';
import 'base_story_element.dart';

class VideoAsset extends StatefulWidget {
  final StoryElement storyElement;
  final bool isEditing;
  final Size screen;
  final EditorController editorController;

  const VideoAsset({
    required this.storyElement,
    required this.screen,
    required this.isEditing,
    required this.editorController,
    super.key,
  });

  @override
  State<VideoAsset> createState() => _VideoAssetState();
}

class _VideoAssetState extends State<VideoAsset> {
  bool isControllerInitialized = false;

  double topVideoCropPercent = 0;
  double bottomVideoCropPercent = 0;
  double leftVideoCropPercent = 0;
  double rightVideoCropPercent = 0;

  double leftCropContainer = 0;
  double topCropContainer = 0;
  double rightCropContainer = 0;
  double bottomCropContainer = 0;

  double containerWidth = 0;
  double containerHeight = 0;

  @override
  void initState() {
    super.initState();
    initController();
  }

  Future<void> initController() async {
    final double videoWidth;
    final double videoHeight;
    if (!widget.isEditing) {
      widget.storyElement.videoController =
          VideoEditorController.network(XFile(widget.storyElement.value));
      await widget.storyElement.videoController!.initialize();
      isControllerInitialized = true;
      videoWidth = widget.storyElement.videoController?.videoWidth ?? 0;
      videoHeight = widget.storyElement.videoController?.videoHeight ?? 0;
      containerWidth = widget.screen.width;
      containerHeight = containerWidth * (videoHeight / videoWidth);
      await widget.storyElement.videoController?.video.setLooping(true);
      await widget.storyElement.videoController?.video.play();
    } else {
      if (widget.storyElement.videoController != null &&
          !widget.storyElement.videoController!.initialized) {
        await widget.storyElement.videoController?.initialize();
        isControllerInitialized = true;
      } else if (widget.storyElement.videoController != null &&
          widget.storyElement.videoController!.initialized) {
        isControllerInitialized = true;
      }
      videoWidth = widget.storyElement.videoController!.videoWidth;
      videoHeight = widget.storyElement.videoController!.videoHeight;
      topVideoCropPercent = widget.storyElement.videoController!.minCrop.dy;
      bottomVideoCropPercent = 1 - widget.storyElement.videoController!.maxCrop.dy;
      leftVideoCropPercent = widget.storyElement.videoController!.minCrop.dx;
      rightVideoCropPercent = 1 - widget.storyElement.videoController!.maxCrop.dx;
      containerWidth = widget.screen.width;
      containerHeight = containerWidth * (videoHeight / videoWidth);
      leftCropContainer = leftVideoCropPercent * containerWidth;
      topCropContainer = topVideoCropPercent * containerHeight;
      rightCropContainer = rightVideoCropPercent * containerWidth;
      bottomCropContainer = bottomVideoCropPercent * containerHeight;

      final double w =
          (widget.screen.width - (containerWidth - leftCropContainer - rightCropContainer)) /
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!isControllerInitialized) {
      return Container(
        key: widget.key,
      );
    }
    print('#Print# : BaseStoryElement');

    return BaseStoryElement(
      key: widget.key,
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
                child: VideoPlayer(
                  widget.storyElement.videoController!.video,
                  key: widget.key,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    print('#Print# : dispose}');
    widget.storyElement.videoController?.dispose();
    super.dispose();
  }
}
