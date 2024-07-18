import 'dart:math';

import 'package:flutter/material.dart';

import '../flutter_stories_editor.dart';
import '../models/story_element.dart';

class LinesWidget extends StatelessWidget {
  final EditorController editorController;
  final Size screen;

  const LinesWidget({
    super.key,
    required this.screen,
    required this.editorController,
  });

  final Color lineColor = const Color(0xFFE64036);
  final double lineDistance = 16;
  final double lineWidth = 2;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<StoryElement?>(
      valueListenable: editorController.selectedItem,
      builder:
          (BuildContext context, StoryElement? selectedItem, Widget? child) {
        if (selectedItem == null) {
          return const SizedBox();
        }

        return ValueListenableBuilder<Size>(
          valueListenable: selectedItem.itemSize,
          builder: (BuildContext context, Size widgetSize, Widget? child) {
            final Size childSize = widgetSize * selectedItem.scale;
            final double childOffsetDx =
                (widgetSize.width - childSize.width) / 2;
            final double childOffsetDy =
                (widgetSize.height - childSize.height) / 2;
            final double positionDx = selectedItem.position.dx * screen.width;
            final double positionDy = selectedItem.position.dy * screen.height;

            final List<Point<double>> redVerticesRotated =
                rotateVertices(childSize, selectedItem.rotation);

            double offsetX = 0;
            double offsetY = 0;

            for (final Point<double> vertex in redVerticesRotated) {
              if (vertex.x < -childSize.width / 2) {
                offsetX = min(offsetX, vertex.x + childSize.width / 2);
              } else if (vertex.x > childSize.width / 2) {
                offsetX = max(offsetX, vertex.x - childSize.width / 2);
              }

              if (vertex.y < -childSize.height / 2) {
                offsetY = min(offsetY, vertex.y + childSize.height / 2);
              } else if (vertex.y > childSize.height / 2) {
                offsetY = max(offsetY, vertex.y - childSize.height / 2);
              }
            }

            final Size positionWithOffSet = Size(
              positionDx + childOffsetDx,
              positionDy + childOffsetDy,
            );

            final Offset childCenter = Offset(
              positionDx + widgetSize.width / 2,
              positionDy + widgetSize.height / 2,
            );

            return Stack(
              children: <Widget>[
                if (positionWithOffSet.width - offsetX > lineDistance - 1 &&
                    positionWithOffSet.width - offsetX < lineDistance + 1)
                  Positioned(
                    left: lineDistance,
                    height: screen.height,
                    child: Container(
                      width: lineWidth,
                      height: screen.height,
                      color: lineColor,
                    ),
                  ),
                if (positionWithOffSet.height + offsetY > lineDistance - 1 &&
                    positionWithOffSet.height + offsetY < lineDistance + 1)
                  Positioned(
                    top: lineDistance,
                    width: screen.width,
                    child: Container(
                      width: screen.width,
                      height: lineWidth,
                      color: lineColor,
                    ),
                  ),
                if (positionWithOffSet.width + childSize.width + offsetX >
                        screen.width - lineDistance - 1 &&
                    positionWithOffSet.width + childSize.width + offsetX <
                        screen.width - lineDistance + 1)
                  Positioned(
                    right: lineDistance,
                    height: screen.height,
                    child: Container(
                      width: lineWidth,
                      height: screen.height,
                      color: lineColor,
                    ),
                  ),
                if (positionWithOffSet.height + childSize.height - offsetY >
                        screen.height - lineDistance - 1 &&
                    positionWithOffSet.height + childSize.height - offsetY <
                        screen.height - lineDistance + 1)
                  Positioned(
                    bottom: lineDistance,
                    width: screen.width,
                    child: Container(
                      width: screen.width,
                      height: lineWidth,
                      color: lineColor,
                    ),
                  ),
                if (childCenter.dx > screen.width / 2 - 1 &&
                    childCenter.dx < screen.width / 2 + 1)
                  Positioned(
                    left: screen.width / 2,
                    height: screen.height,
                    child: Container(
                      width: lineWidth,
                      height: screen.height,
                      color: lineColor,
                    ),
                  ),
                if (childCenter.dy > screen.height / 2 - 1 &&
                    childCenter.dy < screen.height / 2 + 1)
                  Positioned(
                    top: screen.height / 2,
                    width: screen.width,
                    child: Container(
                      height: lineWidth,
                      width: screen.width,
                      color: lineColor,
                    ),
                  )
              ],
            );
          },
        );
      },
    );
  }
}

List<Point<double>> rotateVertices(Size size, double theta) {
  final double cosTheta = cos(theta);
  final double sinTheta = sin(theta);

  final List<Point<double>> vertices = <Point<double>>[
    Point<double>(size.width / 2, size.height / 2),
    Point<double>(-size.width / 2, size.height / 2),
    Point<double>(-size.width / 2, -size.height / 2),
    Point<double>(size.width / 2, -size.height / 2)
  ];

  return vertices.map((Point<double> vertex) {
    final double xNew = vertex.x * cosTheta - vertex.y * sinTheta;
    final double yNew = vertex.x * sinTheta + vertex.y * cosTheta;
    return Point<double>(xNew, yNew);
  }).toList();
}

bool isOutside(Point<double> point, Size objSize) {
  return !(point.x >= -objSize.width / 2 &&
      point.x <= objSize.width / 2 &&
      point.y >= -objSize.height / 2 &&
      point.y <= objSize.height / 2);
}
