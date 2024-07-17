import 'dart:async';
import 'dart:io';

import 'package:advanced_media_picker/advanced_media_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../../models/editor_controller.dart';
import '../../../models/item_type_enum.dart';
import '../../../models/story_element.dart';
import '../../../utils/audio_trimmer/trim/audio_trim_slider.dart';
import '../../../utils/audio_trimmer/trimmer.dart';
import '../../../utils/extensions.dart';
import '../../../utils/overlay_util.dart';
import '../../editor_view.dart';
import '../base_icon_button.dart';

class AudioOverlay extends StatefulWidget {
  final XFile file;
  final Size screen;
  final EditorController editorController;
  final String? uniqueId;

  const AudioOverlay({
    super.key,
    required this.file,
    required this.screen,
    required this.editorController,
    this.uniqueId,
  });

  @override
  State<AudioOverlay> createState() => _AudioOverlayState();
}

class _AudioOverlayState extends State<AudioOverlay> {
  late StoryElement storyElement;
  final AudioTrimmer _trimmer = AudioTrimmer();

  @override
  void initState() {
    super.initState();
    storyElement = StoryElement(
      type: ItemType.audio,
      customWidgetId: widget.uniqueId ?? '',
    );
    initController();
  }

  bool isControllerInitialized = false;

  Future<void> initController() async {
    final Directory tempDir = await getTemporaryDirectory();
    final File audioFile = File('${tempDir.path}/audio_${storyElement.id}.mp3');
    await widget.file.saveTo(audioFile.path);
    await _trimmer.loadAudio(audioFile: audioFile);
    storyElement.value = audioFile.path;

    isControllerInitialized = true;

    setState(() {});
  }

  Future<void> completeEditing() async {
    unawaited(_trimmer.audioPlayer?.pause());
    final Completer<void> completer = Completer<void>();
    String filePath = '';
    await _trimmer.saveTrimmedAudio(
      startValue: _startValue.inMilliseconds.toDouble(),
      endValue: _endValue.inMilliseconds.toDouble(),
      onSave: (String? path) {
        filePath = path ?? '';
        completer.complete();
      },
    );
    await completer.future;
    storyElement.value = filePath;
    storyElement.elementFile = XFile(filePath);
    widget.editorController.assets.addAsset(storyElement);
    unawaited(hideOverlay());
  }

  Duration _startValue = Duration.zero;
  Duration _endValue = const Duration(seconds: 30);

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (!isControllerInitialized) {
      return const SizedBox();
    }
    return Material(
      color: Colors.black45,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      width: widget.screen.width * 0.8,
                      child: AudioTrimSlider(
                        trimmer: _trimmer,
                        height: 56.0,
                        width: widget.screen.width * 0.8,
                        maxAudioLength: const Duration(seconds: 30),
                        minAudioLength: const Duration(seconds: 10),
                        onTrim: (Duration start, Duration end) {
                          _startValue = start;
                          _endValue = end;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      BaseIconButton(
                        icon: Padding(
                          padding: uiSettings.buttonsPadding,
                          child: Text(
                            uiSettings.cancelText,
                            style: uiSettings.cancelButtonsStyle,
                          ),
                        ),
                        onPressed: () {
                          hideOverlay();
                        },
                        withText: true,
                      ),
                      const Spacer(),
                      BaseIconButton(
                        icon: Padding(
                          padding: uiSettings.buttonsPadding,
                          child: Text(
                            uiSettings.doneText,
                            style: uiSettings.doneButtonsStyle,
                          ),
                        ),
                        onPressed: () {
                          completeEditing();
                        },
                        withText: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
