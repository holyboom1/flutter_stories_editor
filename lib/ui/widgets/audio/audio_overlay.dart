import 'dart:async';
import 'dart:io';

import 'package:advanced_media_picker/advanced_media_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
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
  final XFile? file;
  final String? url;
  final Size screen;
  final EditorController editorController;
  final String? uniqueId;
  final Widget Function(
          BuildContext context, Function() onPlay, Function() onPause, ValueNotifier<bool> isPlay)?
      customWidgetBuilder;
  final Completer<bool> completer;

  const AudioOverlay({
    super.key,
    this.file,
    this.url,
    required this.screen,
    required this.editorController,
    this.uniqueId,
    required this.customWidgetBuilder,
    required this.completer,
  }) : assert(file != null || url != null);

  @override
  State<AudioOverlay> createState() => _AudioOverlayState();
}

class _AudioOverlayState extends State<AudioOverlay> {
  late StoryElement storyElement;
  final AudioTrimmer _trimmer = AudioTrimmer();

  @override
  void dispose() {
    _trimmer.audioPlayer?.stop();
    _trimmer.audioPlayer?.release();
    _trimmer.audioPlayer?.dispose();
    _trimmer.dispose();
    super.dispose();
  }

  late Duration _startValue;
  late Duration _endValue;

  @override
  void initState() {
    super.initState();
    _startValue = Duration.zero;
    _endValue = widget.editorController.maxAudioDuration;
    widget.editorController.audioIsPlaying.addListener(() {
      if (widget.editorController.audioIsPlaying.value) {
        _trimmer.audioPlayer?.resume();
      } else {
        _trimmer.audioPlayer?.pause();
      }
    });
    storyElement = StoryElement(
      type: ItemType.audio,
      customWidgetUniqueID: widget.uniqueId ?? '',
    );
    initController();
  }

  bool isControllerInitialized = false;

  void muteVideo({bool unMute = false}) {
    final StoryElement? video = widget.editorController.assets.value.firstWhereOrNull(
      (StoryElement element) {
        return element.type == ItemType.video;
      },
    );
    if (video != null) {
      if (unMute) {
        video.videoController?.unmuteVideo();
        video.isVideoMuted = false;
      } else {
        video.videoController?.muteVideo();
        video.isVideoMuted = true;
      }
    }
  }

  Future<void> initController() async {
    final Directory tempDir = await getTemporaryDirectory();
    final File audioFile = File('${tempDir.path}/audio_${storyElement.id}.mp3');
    if (widget.file == null) {
      final HttpClient httpClient = HttpClient();
      try {
        final HttpClientRequest request = await httpClient.getUrl(Uri.parse(widget.url!));
        final HttpClientResponse response = await request.close();
        if (response.statusCode == 200) {
          final Uint8List bytes = await consolidateHttpClientResponseBytes(response);
          await audioFile.writeAsBytes(bytes);
        } else {}
      } catch (ex) {
        print(ex);
      } finally {
        httpClient.close();
      }
    } else {
      await widget.file!.saveTo(audioFile.path);
    }
    muteVideo();
    await _trimmer.loadAudio(audioFile: audioFile);
    storyElement.value = audioFile.path;

    isControllerInitialized = true;

    _trimmer.audioPlayer?.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.playing) {
        isPlay.value = true;
      } else {
        isPlay.value = false;
      }
    });

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

    final StoryElement? prewAudio = widget.editorController.assets.value.firstWhereOrNull(
      (StoryElement element) {
        return element.type == ItemType.audio;
      },
    );

    if (prewAudio != null) {
      await prewAudio.audioController?.stop();
      await prewAudio.audioController?.dispose();
      widget.editorController.assets.removeAsset(prewAudio);
    }

    storyElement.value = filePath;
    storyElement.elementFile = XFile(filePath);
    storyElement.elementDuration = (_endValue - _startValue).inMilliseconds;
    widget.editorController.assets.addAsset(storyElement);
    muteVideo();
    widget.completer.complete(true);
    unawaited(hideOverlay());
  }

  bool isLoading = false;

  void onTrim(Duration start, Duration end) {
    _startValue = start;
    _endValue = end;
    _trimmer.audioPlayer?.seek(start);

    final StoryElement? video = widget.editorController.assets.value.firstWhereOrNull(
      (StoryElement element) {
        return element.type == ItemType.video;
      },
    );
    if (video != null) {
      video.videoController?.video.seekTo(video.videoController!.startTrim);
    }
  }

  final ValueNotifier<bool> isPlay = ValueNotifier<bool>(true);

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
                        maxAudioLength: widget.editorController.maxAudioDuration,
                        minAudioLength: widget.editorController.minAudioDuration,
                        onTrim: onTrim,
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
                          muteVideo(unMute: true);
                          widget.completer.complete(false);
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
              widget.customWidgetBuilder?.call(
                    context,
                    () {
                      _trimmer.audioPlayer?.resume();
                    },
                    () {
                      _trimmer.audioPlayer?.pause();
                    },
                    isPlay,
                  ) ??
                  const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
