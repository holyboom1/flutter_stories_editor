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
import '../base_icon_button.dart';

class AudioOverlay extends StatefulWidget {
  final XFile file;
  final Size screen;
  final EditorController editorController;

  const AudioOverlay({
    super.key,
    required this.file,
    required this.screen,
    required this.editorController,
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
      type: ItemType.video,
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

  void completeEditing() {
    widget.editorController.assets.addAsset(storyElement);
    hideOverlay();
  }

  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isPlaying = false;
  bool _progressVisibility = false;
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: widget.screen.width * 0.8,
                      child: AudioTrimSlider(
                        trimmer: _trimmer, maxAudioLength: Duration(seconds: 10),

                        // maxAudioLength: Duration(seconds: 10),
                        // onChangeStart: (value) => _startValue = value,
                        // onChangeEnd: (value) => _endValue = value,
                        // onChangePlaybackState: (value) {
                        //   if (mounted) {
                        //     setState(() => _isPlaying = value);
                        //   }
                        // },
                      ),
                    ),
                    TextButton(
                      child: _isPlaying
                          ? Icon(
                              Icons.pause,
                              size: 80.0,
                              color: Theme.of(context).primaryColor,
                            )
                          : Icon(
                              Icons.play_arrow,
                              size: 80.0,
                              color: Theme.of(context).primaryColor,
                            ),
                      onPressed: () async {
                        bool playbackState = await _trimmer.audioPlaybackControl(
                          startValue: _startValue,
                          endValue: _endValue,
                        );
                        setState(() => _isPlaying = playbackState);
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Spacer(),
                      BaseIconButton(
                        icon: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: completeEditing,
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
