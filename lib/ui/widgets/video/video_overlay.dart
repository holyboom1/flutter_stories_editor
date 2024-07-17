import 'dart:async';

import 'package:advanced_media_picker/advanced_media_picker.dart';
import 'package:flutter/material.dart';

import '../../../models/editor_controller.dart';
import '../../../models/item_type_enum.dart';
import '../../../models/story_element.dart';
import '../../../utils/video_editor/lib/domain/bloc/controller.dart';
import '../../../utils/video_editor/lib/ui/crop/crop_grid.dart';
import '../base_icon_button.dart';
import 'actions_bar.dart';
import 'top_bar.dart';
import 'trim_slider.dart';

class VideoOverlay extends StatefulWidget {
  final XFile file;
  final Size screen;
  final EditorController editorController;
  final String? uniqueId;

  const VideoOverlay({
    super.key,
    required this.file,
    required this.screen,
    required this.editorController,
    this.uniqueId,
  });

  @override
  State<VideoOverlay> createState() => _VideoOverlayState();
}

class _VideoOverlayState extends State<VideoOverlay> {
  late StoryElement storyElement;

  @override
  void initState() {
    super.initState();
    storyElement = StoryElement(
      type: ItemType.video,
      value: widget.file.path,
      customWidgetUniqueID: widget.uniqueId ?? '',
    );
    storyElement.videoController = VideoEditorController.file(
      widget.file,
      minDuration: widget.editorController.minVideoDuration,
      maxDuration: widget.editorController.maxVideoDuration,
      cropStyle: widget.editorController.cropGridStyle,
      trimStyle: widget.editorController.trimSliderStyle,
    );

    initController();
  }

  bool isControllerInitialized = false;

  Future<void> initController() async {
    await storyElement.videoController?.initialize();
    isControllerInitialized = true;

    setState(() {});
  }

  void muteVideo() {
    if (storyElement.videoController!.isVideoMuted) {
      storyElement.videoController!.unmuteVideo();
      storyElement.isVideoMuted = false;
    } else {
      storyElement.videoController!.muteVideo();
      storyElement.isVideoMuted = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (storyElement.videoController == null) {
      return const SizedBox();
    }
    return Material(
      color: Colors.black45,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: <Widget>[
              if (isControllerInitialized &&
                  !storyElement.videoController!.isCropping)
                CropGridViewer.preview(
                    controller: storyElement.videoController!),
              if (isControllerInitialized &&
                  storyElement.videoController!.isCropping)
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: CropGridViewer.edit(
                    controller: storyElement.videoController!,
                  ),
                ),
              if (!storyElement.videoController!.isCropping)
                VideoTopBar(
                  editorController: widget.editorController,
                  storyElement: storyElement,
                ),
              if (!storyElement.videoController!.isCropping)
                VideoActionsBar(
                  onCropClick: () {
                    storyElement.videoController!.isCropping = true;
                    setState(() {});
                  },
                ),
              if (storyElement.videoController!.isCropping)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        BaseIconButton(
                          icon: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () {
                            storyElement.videoController!.updateCrop(
                              storyElement.videoController!.cacheMinCrop,
                              storyElement.videoController!.cacheMaxCrop,
                            );
                            storyElement.videoController!.isCropping = false;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              if (isControllerInitialized &&
                  !storyElement.videoController!.isCropping)
                Positioned(
                  bottom: 0,
                  width: MediaQuery.of(context).size.width,
                  child: TrimSliderWidget(
                    controller: storyElement.videoController!,
                    height: 60,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
