import 'package:flutter/material.dart';

import 'item_type_enum.dart';

/// A class that represents a story element.
class StoryElement {
  /// The unique identifier of the element.
  final int id = DateTime.now().millisecondsSinceEpoch;

  /// Element type.
  final ItemType type;

  /// Element value.
  String value = '';

  /// Element container color.
  Color containerColor;

  /// Element text style.
  TextStyle textStyle;

  /// Element text align.
  TextAlign textAlign;

  /// Element position.
  Offset position;

  /// Element size.
  double scale = 1.0;

  /// Element rotation.
  double rotation = 0.0;

  final FocusNode focusNode = FocusNode();

  final Widget child;

  /// Creates a new story element.
  StoryElement({
    required this.type,
    this.value = '',
    this.containerColor = Colors.black,
    this.textStyle = const TextStyle(
        color: Colors.white,
        fontSize: 16,
        letterSpacing: 1.0,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal),
    this.position = const Offset(0.4, 0.4),
    this.scale = 1.0,
    this.rotation = 0.0,
    this.textAlign = TextAlign.center,
    this.child = const SizedBox(),
  });
}
