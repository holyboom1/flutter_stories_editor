import 'package:flutter/material.dart';

import '../../domain/entities/trim_style.dart';

class TrimSliderPainter extends CustomPainter {
  const TrimSliderPainter(
    this.rect,
    this.position,
    this.style, {
    this.isTrimming = false,
    this.isTrimmed = false,
  });

  final Rect rect;
  final bool isTrimming;
  final bool isTrimmed;
  final double position;
  final TrimSliderStyle style;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint background = Paint()..color = style.background;

    final RRect rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(style.borderRadius),
    );

    canvas.drawPath(
      Path()
        ..fillType = PathFillType.evenOdd
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(25, 0, size.width - 50, size.height),
            Radius.circular(style.borderRadius),
          ),
        )
        ..addRRect(rrect),
      background,
    );

    final Color trimColor = isTrimming
        ? style.onTrimmingColor
        : isTrimmed
            ? style.onTrimmedColor
            : style.lineColor;
    final Paint line = Paint()
      ..color = trimColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = style.lineWidth;
    final Paint edges = Paint()..color = trimColor;

    final double halfLineWidth = style.edgeWidth / 2;
    final double halfHeight = rect.height / 2;

    final Offset centerLeft = Offset(rect.left - halfLineWidth, halfHeight);
    final Offset centerRight = Offset(rect.right + halfLineWidth, halfHeight);

    switch (style.edgesType) {
      case TrimSliderEdgesType.bar:
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
        break;
      case TrimSliderEdgesType.circle:
        paintCircle(
          canvas,
          size,
          rrect: rrect,
          line: line,
          edges: edges,
          centerLeft: centerLeft,
          centerRight: centerRight,
        );
        break;
    }
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
            rect.topRight - Offset(0.0, style.lineWidth),
          ),
        )
        ..addRect(
          Rect.fromPoints(
            rect.bottomRight + Offset(0.0, style.lineWidth),
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

    paintIndicator(canvas, size);
  }

  void paintEdgesBarPath(
    Canvas canvas,
    Size size, {
    required Paint edges,
    required Offset centerLeft,
    required Offset centerRight,
    required double halfLineWidth,
  }) {
    if (style.borderRadius == 0) {
      canvas.drawPath(
        Path()
          // LEFT EDGE
          ..addRect(
            Rect.fromCenter(
              center: centerLeft,
              width: style.edgesSize,
              height: size.height + style.lineWidth * 2,
            ),
          )
          // RIGTH EDGE
          ..addRect(
            Rect.fromCenter(
              center: centerRight,
              width: style.edgesSize,
              height: size.height + style.lineWidth * 2,
            ),
          ),
        edges,
      );
    }

    final Radius borderRadius = Radius.circular(style.borderRadius);

    /// Left and right edges, with a reversed border radius on the inside of the rect
    canvas.drawPath(
      // LEFT EDGE
      Path()
        ..fillType = PathFillType.evenOdd
        ..addRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTWH(
              centerLeft.dx - halfLineWidth,
              -style.lineWidth,
              style.edgeWidth + style.borderRadius,
              size.height + style.lineWidth * 2,
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
              style.borderRadius,
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
              centerRight.dx - halfLineWidth - style.borderRadius,
              -style.lineWidth,
              style.edgeWidth + style.borderRadius,
              size.height + style.lineWidth * 2,
            ),
            topRight: borderRadius,
            bottomRight: borderRadius,
          ),
        )
        ..addRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTWH(
              centerRight.dx - halfLineWidth - style.borderRadius,
              0.0,
              style.borderRadius,
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
            width: rect.width + style.edgeWidth,
            height: rect.height + style.edgeWidth,
          ),
          Radius.circular(style.borderRadius),
        ),
        line);

    paintIndicator(canvas, size);

    // LEFT CIRCLE
    canvas.drawCircle(centerLeft, style.edgesSize, edges);
    // RIGHT CIRCLE
    canvas.drawCircle(centerRight, style.edgesSize, edges);

    paintIcons(canvas, centerLeft: centerLeft, centerRight: centerRight);
  }

  void paintIndicator(Canvas canvas, Size size) {
    final Paint progress = Paint()
      ..color = style.positionLineColor
      ..strokeWidth = style.positionLineWidth;

    // DRAW VIDEO INDICATOR
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset(position - style.positionLineWidth / 2, -style.lineWidth * 2),
          Offset(
            position + style.positionLineWidth / 2,
            size.height + style.lineWidth * 2,
          ),
        ),
        Radius.circular(style.positionLineWidth),
      ),
      progress,
    );
  }

  void paintIcons(
    Canvas canvas, {
    required Offset centerLeft,
    required Offset centerRight,
  }) {
    // LEFT ICON
    if (style.leftIcon != null) {
      final Paint paint = Paint()
        ..color = Colors.white // The color you need
        ..style = PaintingStyle.fill;

      final Rect rect =
          Rect.fromLTWH(centerLeft.dx - 2, centerLeft.dy - 10, 4, 20);
      final RRect rrect =
          RRect.fromRectAndRadius(rect, const Radius.circular(10));
      canvas.drawRRect(rrect, paint);
    }

    // RIGHT ICON
    if (style.rightIcon != null) {
      final Paint paint = Paint()
        ..color = Colors.white // The color you need
        ..style = PaintingStyle.fill;

      final Rect rect =
          Rect.fromLTWH(centerRight.dx - 2, centerRight.dy - 10, 4, 20);
      final RRect rrect =
          RRect.fromRectAndRadius(rect, const Radius.circular(10));
      canvas.drawRRect(rrect, paint);
    }
  }

  @override
  bool shouldRepaint(TrimSliderPainter oldDelegate) =>
      oldDelegate.rect != rect ||
      oldDelegate.position != position ||
      oldDelegate.style != style ||
      oldDelegate.isTrimming != isTrimming ||
      oldDelegate.isTrimmed != isTrimmed;

  @override
  bool shouldRebuildSemantics(TrimSliderPainter oldDelegate) => false;
}
