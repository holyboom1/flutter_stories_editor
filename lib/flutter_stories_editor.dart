library flutter_stories_editor;

import 'package:flutter/material.dart';

import 'models/editor_controller.dart';
import 'models/story_model.dart';
import 'ui/editor_view.dart';

export 'flutter_stories_view.dart';
export 'models/editor_controller.dart';
export 'models/story_element.dart';
export 'models/story_model.dart';

/// FlutterStoriesEditor
class FlutterStoriesEditor extends StatelessWidget {
  /// Top bar config
  final Widget? topBar;

  /// Background color
  final Color? backgroundColor;

  /// Editor controller
  final EditorController? controller;

  /// Function onDone to return the story model when the user is finished editing
  final Function(StoryModel story)? onDone;

  /// Function onClose to return the story model when the user closes the editor
  final Function(StoryModel story)? onClose;

  /// FlutterStoriesEditor
  const FlutterStoriesEditor({
    Key? key,
    this.controller,
    this.backgroundColor = Colors.pink,
    this.topBar,
    this.onDone,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EditorView(
      controller: controller,
      backgroundColor: backgroundColor,
      topBar: topBar,
      onDone: onDone,
      onClose: onClose,
    );
  }
}
