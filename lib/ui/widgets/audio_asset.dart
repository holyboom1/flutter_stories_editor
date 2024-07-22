import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../models/editor_controller.dart';
import '../../models/item_type_enum.dart';
import '../../models/story_element.dart';
import '../../utils/video_editor/lib/domain/bloc/controller.dart';

class AudioAsset extends StatefulWidget {
  final StoryElement storyElement;
  final bool isEditing;
  final EditorController editorController;

  const AudioAsset({
    required this.storyElement,
    required this.isEditing,
    required this.editorController,
    super.key,
  });

  @override
  State<AudioAsset> createState() => _AudioAssetState();
}

class _AudioAssetState extends State<AudioAsset> {
  @override
  void initState() {
    super.initState();
    initController();
  }

  Future<void> initController() async {
    widget.storyElement.audioController = AudioPlayer();
    final File audioFile = File(widget.storyElement.value);

    if (Platform.isIOS) {
      await widget.storyElement.audioController
          ?.setSourceDeviceFile(audioFile.path);
    } else if (Platform.isAndroid) {
      await widget.storyElement.audioController
          ?.setSourceBytes(audioFile.readAsBytesSync());
    }

    final StoryElement? video =
        widget.editorController.assets.value.firstWhereOrNull(
      (StoryElement element) {
        return element.type == ItemType.video;
      },
    );
    videoEditorController = video?.videoController;
    if (videoEditorController != null) {
      await widget.storyElement.audioController?.seek(Duration.zero);
      unawaited(videoEditorController?.video
          .seekTo(videoEditorController!.startTrim));
      unawaited(widget.storyElement.audioController?.resume());
      videoEditorController?.isLooped.addListener(videoListener);
    } else {
      unawaited(widget.storyElement.audioController
          ?.setReleaseMode(ReleaseMode.loop));
      unawaited(widget.storyElement.audioController?.resume());
    }
  }

  Future<void> videoListener() async {
    await widget.storyElement.audioController?.seek(Duration.zero);
  }

  VideoEditorController? videoEditorController;

  @override
  void dispose() {
    videoEditorController?.isLooped.removeListener(videoListener);
    widget.storyElement.audioController?.stop();
    widget.storyElement.audioController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
