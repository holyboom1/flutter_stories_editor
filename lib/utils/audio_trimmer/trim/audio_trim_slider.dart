import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../trimmer.dart';

class AudioTrimSlider extends StatefulWidget {
  final double height;
  final double? width;
  final AudioTrimmer trimmer;
  final Duration maxAudioLength;

  AudioTrimSlider({
    super.key,
    this.height = 100.0,
    this.width,
    required this.trimmer,
    required this.maxAudioLength,
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

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _initializeAudioController();
      await audioPlayerController.seek(Duration.zero);
      final Duration? totalDuration = await audioPlayerController.getDuration();

      setState(() {
        if (totalDuration == null) {
          return;
        }

        if (widget.maxAudioLength > Duration.zero && widget.maxAudioLength < totalDuration) {
          if (widget.maxAudioLength < totalDuration) {}
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
        final bool isPlaying = audioPlayerController.state == PlayerState.playing;

        if (isPlaying) {
          setState(() {
            _currentPosition.value = event.inMilliseconds;

            if (_currentPosition.value > _audioEndPos.value.toInt()) {
              audioPlayerController.pause();
            } else {}
          });
        }
      });

      unawaited(audioPlayerController.setVolume(1.0));
      _audioDuration.value = (await audioPlayerController.getDuration())!.inMilliseconds;
    }
  }

  // /// Called when the user starts dragging the frame, on either side on the whole frame.
  // /// Determine which [EditorDragType] is used.
  // void _onDragStart(DragStartDetails details) {
  //   debugPrint('_onDragStart');
  //   debugPrint(details.localPosition.toString());
  //   debugPrint((_startPos.dx - details.localPosition.dx).abs().toString());
  //   debugPrint((_endPos.dx - details.localPosition.dx).abs().toString());
  //
  //   final double startDifference = _startPos.dx - details.localPosition.dx;
  //   final double endDifference = _endPos.dx - details.localPosition.dx;
  //
  //   // First we determine whether the dragging motion should be allowed. The allowed
  //   // zone is widget.sideTapSize (left) + frame (center) + widget.sideTapSize (right)
  //   if (startDifference <= widget.editorProperties.sideTapSize &&
  //       endDifference >= -widget.editorProperties.sideTapSize) {
  //     _allowDrag = true;
  //   } else {
  //     debugPrint('Dragging is outside of frame, ignoring gesture...');
  //     _allowDrag = false;
  //     return;
  //   }
  //
  //   // Now we determine which part is dragged
  //   if (details.localPosition.dx <= _startPos.dx + widget.editorProperties.sideTapSize) {
  //     _dragType = EditorDragType.left;
  //   } else if (details.localPosition.dx <= _endPos.dx - widget.editorProperties.sideTapSize) {
  //     _dragType = EditorDragType.center;
  //   } else {
  //     _dragType = EditorDragType.right;
  //   }
  // }
  //
  // /// Called during dragging, only executed if [_allowDrag] was set to true in
  // /// [_onDragStart].
  // /// Makes sure the limits are respected.
  // void _onDragUpdate(DragUpdateDetails details) {
  //   if (!_allowDrag) return;
  //
  //   if (_dragType == EditorDragType.left) {
  //     if (!widget.allowAudioSelection) return;
  //     _startCircleSize = widget.editorProperties.circleSizeOnDrag;
  //     if ((_startPos.dx + details.delta.dx >= 0) &&
  //         (_startPos.dx + details.delta.dx <= _endPos.dx) &&
  //         !(_endPos.dx - _startPos.dx - details.delta.dx > maxLengthPixels!)) {
  //       _startPos += details.delta;
  //       _onStartDragged();
  //     }
  //   } else if (_dragType == EditorDragType.center) {
  //     _startCircleSize = widget.editorProperties.circleSizeOnDrag;
  //     _endCircleSize = widget.editorProperties.circleSizeOnDrag;
  //     if ((_startPos.dx + details.delta.dx >= 0) &&
  //         (_endPos.dx + details.delta.dx <= _barViewerW)) {
  //       _startPos += details.delta;
  //       _endPos += details.delta;
  //       _onStartDragged();
  //       _onEndDragged();
  //     }
  //   } else {
  //     if (!widget.allowAudioSelection) return;
  //     _endCircleSize = widget.editorProperties.circleSizeOnDrag;
  //     if ((_endPos.dx + details.delta.dx <= _barViewerW) &&
  //         (_endPos.dx + details.delta.dx >= _startPos.dx) &&
  //         !(_endPos.dx - _startPos.dx + details.delta.dx > maxLengthPixels!)) {
  //       _endPos += details.delta;
  //       _onEndDragged();
  //     }
  //   }
  //   setState(() {});
  // }
  //
  // void _onStartDragged() {
  //   _startFraction = _startPos.dx / _barViewerW;
  //   _audioStartPos = _audioDuration * _startFraction;
  //   widget.onChangeStart!(_audioStartPos);
  //   _linearTween.begin = _startPos.dx;
  //   _animationController!.duration =
  //       Duration(milliseconds: (_audioEndPos - _audioStartPos).toInt());
  //   _animationController!.reset();
  // }
  //
  // void _onEndDragged() {
  //   _endFraction = _endPos.dx / _barViewerW;
  //   _audioEndPos = _audioDuration * _endFraction;
  //   widget.onChangeEnd!(_audioEndPos);
  //   _linearTween.end = _endPos.dx;
  //   _animationController!.duration =
  //       Duration(milliseconds: (_audioEndPos - _audioStartPos).toInt());
  //   _animationController!.reset();
  // }
  //
  // /// Drag gesture ended, update UI accordingly.
  // void _onDragEnd(DragEndDetails details) {
  //   setState(() {
  //     _startCircleSize = widget.editorProperties.circleSize;
  //     _endCircleSize = widget.editorProperties.circleSize;
  //     if (_dragType == EditorDragType.right) {
  //       audioPlayerController.seek(Duration(milliseconds: _audioEndPos.toInt()));
  //     } else {
  //       audioPlayerController.seek(Duration(milliseconds: _audioStartPos.toInt()));
  //     }
  //   });
  // }

  Stream<List<int?>> generateBars(double width) async* {
    final List<int> bars = <int>[];
    final Random r = Random();
    for (int i = 1; i <= width / 5.0; i++) {
      final int number = 1 + r.nextInt(widget.height.toInt() - 2);
      bars.add(r.nextInt(number));
      yield bars;
    }
  }

  Widget bars({
    required double width,
    double horizontalPadding = 4.0,
    double verticalPadding = 8.0,
  }) {
    int i = 0;

    return StreamBuilder<List<int?>>(
      stream: generateBars(width - horizontalPadding * 2.0),
      builder: (BuildContext context, AsyncSnapshot<List<int?>> snapshot) {
        if (snapshot.hasData) {
          final List<int?> bars = snapshot.data!;
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            color: Colors.white,
            width: double.infinity,
            child: Row(
              children: bars.map((int? height) {
                i++;
                return Container(
                  width: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 1.0),
                  height: height?.toDouble(),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFEB671B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                  ),
                );
              }).toList(),
            ),
          );
        } else {
          return Container(
            color: Colors.grey[900],
            height: widget.height,
            width: double.maxFinite,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return RepaintBoundary(
          child: CustomPaint(
            size: Size.fromHeight(widget.height),
            foregroundPainter: TrimSliderPainter(
              Rect.fromLTRB(
                _audioStartPos.value,
                0,
                _audioEndPos.value,
                0,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.0),
              ),
              clipBehavior: Clip.hardEdge,
              child: bars(
                width: constraints.maxWidth,
              ),
            ),
          ),
        );
      },
    );
  }
}

class TrimSliderPainter extends CustomPainter {
  TrimSliderPainter(
    this.rect, {
    this.borderRadius = 12,
    this.backgroundColor = Colors.black12,
    this.trimColor = const Color(0xFFEB671B),
  });

  final Rect rect;
  final double borderRadius;
  final Color backgroundColor;
  final Color trimColor;
  final double lineWidth = 2;
  final double edgeSize = 10;
  final double edgeWidth = 10;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint background = Paint()..color = backgroundColor;

    final RRect rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(borderRadius),
    );

    canvas.drawPath(
      Path()
        ..fillType = PathFillType.evenOdd
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(25, 0, size.width - 50, size.height),
            Radius.circular(borderRadius),
          ),
        )
        ..addRRect(rrect),
      background,
    );

    final Paint line = Paint()
      ..color = trimColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final Paint edges = Paint()..color = trimColor;

    final double halfLineWidth = edgeSize / 2;
    final double halfHeight = rect.height / 2;

    final Offset centerLeft = Offset(rect.left - halfLineWidth, halfHeight);
    final Offset centerRight = Offset(rect.right + halfLineWidth, halfHeight);

    paintBar(
      canvas,
      size,
      rrect: rrect,
      line: line,
      edges: edges,
      centerLeft: centerLeft,
      centerRight: centerRight,
      halfLineWidth: halfLineWidth,
    );
  }

  void paintBar(
    Canvas canvas,
    Size size, {
    required RRect rrect,
    required Paint line,
    required Paint edges,
    required Offset centerLeft,
    required Offset centerRight,
    required double halfLineWidth,
  }) {
    // DRAW TOP AND BOTTOM LINES
    canvas.drawPath(
      Path()
        ..addRect(
          Rect.fromPoints(
            rect.topLeft,
            rect.topRight - Offset(0.0, lineWidth),
          ),
        )
        ..addRect(
          Rect.fromPoints(
            rect.bottomRight + Offset(0.0, lineWidth),
            rect.bottomLeft,
          ),
        ),
      edges,
    );

    // DRAW EDGES
    paintEdgesBarPath(
      canvas,
      size,
      edges: edges,
      centerLeft: centerLeft,
      centerRight: centerRight,
      halfLineWidth: halfLineWidth,
    );

    paintIcons(canvas, centerLeft: centerLeft, centerRight: centerRight);
  }

  void paintEdgesBarPath(
    Canvas canvas,
    Size size, {
    required Paint edges,
    required Offset centerLeft,
    required Offset centerRight,
    required double halfLineWidth,
  }) {
    if (this.borderRadius == 0) {
      canvas.drawPath(
        Path()
          // LEFT EDGE
          ..addRect(
            Rect.fromCenter(
              center: centerLeft,
              width: edgeSize,
              height: size.height + lineWidth * 2,
            ),
          )
          // RIGTH EDGE
          ..addRect(
            Rect.fromCenter(
              center: centerRight,
              width: edgeSize,
              height: size.height + lineWidth * 2,
            ),
          ),
        edges,
      );
    }

    final Radius borderRadius = Radius.circular(this.borderRadius);

    /// Left and right edges, with a reversed border radius on the inside of the rect
    canvas.drawPath(
      // LEFT EDGE
      Path()
        ..fillType = PathFillType.evenOdd
        ..addRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTWH(
              centerLeft.dx - halfLineWidth,
              -lineWidth,
              edgeWidth + this.borderRadius,
              size.height + lineWidth * 2,
            ),
            topLeft: borderRadius,
            bottomLeft: borderRadius,
          ),
        )
        ..addRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTWH(
              centerLeft.dx + halfLineWidth,
              0.0,
              this.borderRadius,
              size.height,
            ),
            topLeft: borderRadius,
            bottomLeft: borderRadius,
          ),
        ),
      edges,
    );

    canvas.drawPath(
      // RIGHT EDGE
      Path()
        ..fillType = PathFillType.evenOdd
        ..addRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTWH(
              centerRight.dx - halfLineWidth - this.borderRadius,
              -lineWidth,
              edgeWidth + this.borderRadius,
              size.height + lineWidth * 2,
            ),
            topRight: borderRadius,
            bottomRight: borderRadius,
          ),
        )
        ..addRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTWH(
              centerRight.dx - halfLineWidth - this.borderRadius,
              0.0,
              this.borderRadius,
              size.height,
            ),
            topRight: borderRadius,
            bottomRight: borderRadius,
          ),
        ),
      edges,
    );
  }

  void paintCircle(
    Canvas canvas,
    Size size, {
    required RRect rrect,
    required Paint line,
    required Paint edges,
    required Offset centerLeft,
    required Offset centerRight,
  }) {
    // DRAW RECT BORDERS
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: rect.center,
            width: rect.width + edgeWidth,
            height: rect.height + edgeWidth,
          ),
          Radius.circular(borderRadius),
        ),
        line);

    // LEFT CIRCLE
    canvas.drawCircle(centerLeft, edgeSize, edges);
    // RIGHT CIRCLE
    canvas.drawCircle(centerRight, edgeSize, edges);

    paintIcons(canvas, centerLeft: centerLeft, centerRight: centerRight);
  }

  void paintIcons(
    Canvas canvas, {
    required Offset centerLeft,
    required Offset centerRight,
  }) {
    // LEFT ICON

    final Paint paint = Paint()
      ..color = Colors.white // The color you need
      ..style = PaintingStyle.fill;

    final Rect rect = Rect.fromLTWH(centerLeft.dx - 2, centerLeft.dy - 10, 4, 20);
    final RRect rrect = RRect.fromRectAndRadius(rect, const Radius.circular(10));
    canvas.drawRRect(rrect, paint);

    // RIGHT ICON
    final Paint paint2 = Paint()
      ..color = Colors.white // The color you need
      ..style = PaintingStyle.fill;

    final Rect rect2 = Rect.fromLTWH(centerRight.dx - 2, centerRight.dy - 10, 4, 20);
    final RRect rrect2 = RRect.fromRectAndRadius(rect2, const Radius.circular(10));
    canvas.drawRRect(rrect2, paint2);
  }

  @override
  bool shouldRepaint(TrimSliderPainter oldDelegate) => oldDelegate.rect != rect;

  @override
  bool shouldRebuildSemantics(TrimSliderPainter oldDelegate) => false;
}
