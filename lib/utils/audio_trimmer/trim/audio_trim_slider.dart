import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../trimmer.dart';

enum _TrimBoundaries { left, right, inside, progress }

class AudioTrimSlider extends StatefulWidget {
  final double height;
  final double width;
  final AudioTrimmer trimmer;
  final Duration maxAudioLength;
  final Duration minAudioLength;
  final Function(Duration start, Duration end) onTrim;

  const AudioTrimSlider({
    super.key,
    this.height = 100.0,
    required this.width,
    required this.trimmer,
    required this.maxAudioLength,
    required this.minAudioLength,
    required this.onTrim,
  });

  @override
  State<AudioTrimSlider> createState() => _AudioTrimSliderState();
}

class _AudioTrimSliderState extends State<AudioTrimSlider> {
  final ValueNotifier<double> _audioStartPos = ValueNotifier<double>(0.0);
  final ValueNotifier<double> _audioEndPos = ValueNotifier<double>(0.0);
  final ValueNotifier<int> _currentPosition = ValueNotifier<int>(0);
  final ValueNotifier<int> _audioDuration = ValueNotifier<int>(0);

  AudioPlayer get audioPlayerController => widget.trimmer.audioPlayer!;

  File? get _audioFile => widget.trimmer.currentAudioFile;

  double audioScaleFactor = 1.0;

  double minTrimLength = 0.0;
  double maxTrimLength = double.infinity;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _initializeAudioController();
      // await audioPlayerController.seek(Duration.zero);
      final Duration? totalDuration = await audioPlayerController.getDuration();

      setState(() {
        if (totalDuration == null) {
          return;
        }

        audioScaleFactor = widget.width / totalDuration.inMilliseconds;
        maxTrimLength = audioScaleFactor * widget.maxAudioLength.inMilliseconds;
        minTrimLength = audioScaleFactor * widget.minAudioLength.inMilliseconds;
        if (widget.maxAudioLength > Duration.zero &&
            widget.maxAudioLength < totalDuration) {
          if (widget.maxAudioLength < totalDuration) {
            _audioEndPos.value =
                widget.maxAudioLength.inMilliseconds * audioScaleFactor;
          } else {
            _audioEndPos.value = widget.width;
          }
        }
      });
    });
  }

  Future<void> _initializeAudioController() async {
    if (_audioFile != null) {
      audioPlayerController.onPlayerStateChanged.listen((PlayerState event) {
        final bool isPlaying = event == PlayerState.playing;

        if (!isPlaying) {
        } else {}
      });

      audioPlayerController.onPositionChanged.listen((Duration event) async {
        final bool isPlaying =
            audioPlayerController.state == PlayerState.playing;
        if (isPlaying) {
          _currentPosition.value = event.inMilliseconds;
          if (_currentPosition.value >
              (_audioEndPos.value - 24) / audioScaleFactor) {
            await audioPlayerController.seek(Duration(
                microseconds:
                    (_audioStartPos.value / audioScaleFactor).toInt()));
          } else {}
        }
      });

      unawaited(audioPlayerController.setVolume(1.0));
      _audioDuration.value =
          (await audioPlayerController.getDuration())!.inMilliseconds;
      await audioPlayerController.seek(const Duration());

      await audioPlayerController.resume();
    }
  }

  Stream<List<int?>> generateBars(double width) async* {}

  Widget bars({
    required double width,
    double horizontalPadding = 4.0,
    double verticalPadding = 8.0,
    double barWidth = 3.0,
    double barPadding = 1.0,
  }) {
    final List<int> bars = <int>[];
    final Random r = Random();
    double availableWidth = width - (horizontalPadding * 3);
    for (int i = 0; availableWidth > 0; i++) {
      final int number = 1 + r.nextInt(widget.height.toInt());
      bars.add(r.nextInt(number));
      availableWidth -= barWidth + (barPadding * 2);
    }

    return Container(
      height: widget.height,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      color: Colors.white,
      width: width,
      child: Row(
        children: bars.mapIndexed(
          (int index, int height) {
            final double position = index * (barWidth + barPadding * 2);
            return ValueListenableBuilder<int>(
              valueListenable: _currentPosition,
              builder: (BuildContext context, int value, Widget? child) {
                final double valuePosition = value * audioScaleFactor;
                double width = 0;

                if (valuePosition > position) {
                  width = 3;
                }

                return Container(
                  width: barWidth,
                  margin: EdgeInsets.symmetric(horizontal: barPadding),
                  height: height.toDouble(),
                  decoration: ShapeDecoration(
                    color: const Color(0x7F7E7F83),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2)),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Container(
                    width: width,
                    height: height.toDouble(),
                    decoration: BoxDecoration(
                      color: position < valuePosition
                          ? const Color(0xFFEB671B)
                          : Colors.transparent,
                    ),
                  ),
                );
              },
            );
          },
        ).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.hardEdge,
          child: bars(
            width: widget.width - 24,
          ),
        ),
        TrimSlider(
          height: widget.height,
          width: widget.width,
          audioStartPos: _audioStartPos,
          audioEndPos: _audioEndPos,
          minTrimLength: minTrimLength,
          maxTrimLength: maxTrimLength,
        ),
      ],
    );
  }
}

class TrimSlider extends StatefulWidget {
  final ValueNotifier<double> audioStartPos;
  final ValueNotifier<double> audioEndPos;
  final double width;
  final double height;
  final double minTrimLength;
  final double maxTrimLength;

  const TrimSlider({
    super.key,
    required this.audioStartPos,
    required this.audioEndPos,
    required this.width,
    required this.height,
    this.minTrimLength = 0.0,
    this.maxTrimLength = double.infinity,
  });

  @override
  State<TrimSlider> createState() => _TrimSliderState();
}

class _TrimSliderState extends State<TrimSlider> {
  double startPostion = 0;
  double endPostion = 0;

  @override
  void initState() {
    super.initState();
    endPostion = widget.audioEndPos.value;
    startPostion = widget.audioStartPos.value;
    widget.audioStartPos.addListener(() {
      startPostion = widget.audioStartPos.value;
      setState(() {});
    });
    widget.audioEndPos.addListener(() {
      endPostion = widget.audioEndPos.value;
      setState(() {});
    });
  }

  Offset lastPosition = Offset.zero;

  void _startDrag(DragStartDetails details) {
    lastPosition = details.globalPosition;
  }

  void _updatePosition(DragUpdateDetails details, _TrimBoundaries boundary) {
    final double position = details.globalPosition.dx - lastPosition.dx;
    lastPosition = details.globalPosition;
    if (boundary == _TrimBoundaries.left) {
      final double newPostion = widget.audioStartPos.value + position;
      if (newPostion < 0) {
        widget.audioStartPos.value = 0;
      } else if (newPostion > endPostion) {
        widget.audioStartPos.value = endPostion;
      } else {
        if (widget.audioEndPos.value - newPostion < widget.minTrimLength) {
          return;
        }

        if (widget.audioEndPos.value - newPostion > widget.maxTrimLength) {
          return;
        }

        widget.audioStartPos.value = newPostion;
      }
    } else if (boundary == _TrimBoundaries.right) {
      final double newPostion = widget.audioEndPos.value + position;

      if (newPostion > widget.width) {
        widget.audioEndPos.value = widget.width;
      } else if (newPostion < startPostion) {
        widget.audioEndPos.value = startPostion;
      } else {
        if (newPostion - widget.audioStartPos.value < widget.minTrimLength) {
          return;
        }

        if (newPostion - widget.audioStartPos.value > widget.maxTrimLength) {
          return;
        }

        widget.audioEndPos.value = newPostion;
      }
    }
    if (boundary == _TrimBoundaries.inside) {
      final double diff = widget.audioEndPos.value - widget.audioStartPos.value;
      final double newStartPostion = widget.audioStartPos.value + position;
      final double newEndPostion = widget.audioEndPos.value + position;
      if (newStartPostion + diff > widget.width) {
        widget.audioEndPos.value = widget.width;
        widget.audioStartPos.value = widget.width - diff;
      } else if (newStartPostion < 0) {
        widget.audioStartPos.value = 0;
        widget.audioEndPos.value = diff;
      } else {
        widget.audioStartPos.value = newStartPostion;
        widget.audioEndPos.value = newEndPostion;
      }
    }
  }

  void _endDrag(DragEndDetails details) {
    lastPosition = Offset.zero;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 12,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              width: startPostion,
              height: widget.height,
            ),
          ),
          Positioned(
            left: endPostion - 12,
            right: 12,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: const BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
            ),
          ),
          Positioned(
            left: startPostion + 12,
            child: GestureDetector(
              onHorizontalDragStart: _startDrag,
              onHorizontalDragUpdate: (DragUpdateDetails details) {
                _updatePosition(details, _TrimBoundaries.inside);
              },
              onHorizontalDragEnd: _endDrag,
              child: Container(
                width: widget.width - (endPostion - startPostion - 24),
                height: widget.height,
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            left: startPostion,
            child: ClipPath(
              clipper: TransparentCenterClipper(
                paddingLeft: 12,
                paddingRight: 12,
                paddingVertical: 2,
                borderRadius: 12,
              ),
              child: Container(
                width: endPostion - startPostion,
                height: widget.height,
                color: const Color(0xFFEB671B),
                child: Stack(
                  children: <Widget>[
                    GestureDetector(
                      onHorizontalDragStart: _startDrag,
                      onHorizontalDragUpdate: (DragUpdateDetails details) {
                        _updatePosition(details, _TrimBoundaries.left);
                      },
                      onHorizontalDragEnd: _endDrag,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: 12,
                        height: widget.height,
                        child: Center(
                          child: Container(
                            width: 4,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: (endPostion - startPostion) - 12,
                      child: GestureDetector(
                        onHorizontalDragStart: _startDrag,
                        onHorizontalDragUpdate: (DragUpdateDetails details) {
                          _updatePosition(details, _TrimBoundaries.right);
                        },
                        onHorizontalDragEnd: _endDrag,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: 12,
                          height: widget.height,
                          child: Center(
                            child: Container(
                              width: 4,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TransparentCenterClipper extends CustomClipper<Path> {
  final double paddingLeft;
  final double paddingRight;
  final double paddingVertical;

  final double borderRadius;

  TransparentCenterClipper({
    super.reclip,
    required this.paddingLeft,
    required this.paddingRight,
    required this.paddingVertical,
    required this.borderRadius,
  });

  @override
  Path getClip(Size size) {
    final Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius),
      ));

    final double left = paddingLeft;
    final double top = paddingVertical;
    final double right = size.width - paddingRight;
    final double bottom = size.height - paddingVertical;

    // Cut out the transparent center
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTRB(left, top, right, bottom),
      Radius.circular(borderRadius),
    ));

    return path..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(TransparentCenterClipper oldClipper) {
    return true;
  }
}
