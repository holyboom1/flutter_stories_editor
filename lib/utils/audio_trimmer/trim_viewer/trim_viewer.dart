import 'package:flutter/material.dart';

import '../trim_viewer/fixed_viewer/fixed_trim_viewer.dart';
import '../trimmer.dart';

class TrimViewer extends StatefulWidget {
  /// The Trimmer instance controlling the data.
  final AudioTrimmer trimmer;

  /// For specifying the type of the trim viewer.
  /// You can choose among: `auto`, `fixed`, and `scrollable`.
  ///
  /// **NOTE:** While using `scrollable` if the total audio
  /// duration is less than maxAudioLength + padding, it
  /// will throw an error.
  ///

  /// For defining the maximum length of the output audio.
  ///
  /// **NOTE:** When explicitly setting the `type` to `scrollable`,
  /// specifying this property is mandatory.
  final Duration maxAudioLength;

  /// Callback to the audio start position
  ///
  /// Returns the selected audio start position in `milliseconds`.
  final Function(double startValue)? onChangeStart;

  /// Callback to the audio end position.
  ///
  /// Returns the selected audio end position in `milliseconds`.
  final Function(double endValue)? onChangeEnd;

  /// Callback to the audio playback
  /// state to know whether it is currently playing or paused.
  ///
  /// Returns a `boolean` value. If `true`, audio is currently
  /// playing, otherwise paused.
  final Function(bool isPlaying)? onChangePlaybackState;

  final bool allowAudioSelection;

  const TrimViewer({
    Key? key,
    required this.trimmer,
    this.maxAudioLength = const Duration(),
    this.onChangeStart,
    this.onChangeEnd,
    this.onChangePlaybackState,
    this.allowAudioSelection = true,
  }) : super(key: key);

  @override
  State<TrimViewer> createState() => _TrimViewerState();
}

class _TrimViewerState extends State<TrimViewer> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.trimmer.eventStream.listen((TrimmerEvent event) async {
      if (event == TrimmerEvent.initialized) {
        final Duration? totalDuration = await widget.trimmer.audioPlayer!.getDuration();
        if (totalDuration == null) {
          return;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AudioTrimViewer(
      trimmer: widget.trimmer,
      maxAudioLength: widget.maxAudioLength,
      onChangeStart: widget.onChangeStart,
      onChangeEnd: widget.onChangeEnd,
      onChangePlaybackState: widget.onChangePlaybackState,
      allowAudioSelection: widget.allowAudioSelection,
    );
  }
}
