library flutter_stories_editor;

import 'package:flutter/material.dart';

import 'models/editor_controller.dart';
import 'models/story_model.dart';
import 'ui/editor_view.dart';

export 'flutter_stories_view.dart';
export 'models/editor_controller.dart';
export 'models/story_model.dart';
export 'utils/video_editor/lib/domain/entities/trim_style.dart';

/// FlutterStoriesEditor
class FlutterStoriesEditor extends StatefulWidget {
  /// Top bar config
  final Widget? topBar;

  /// Background color
  final Color backgroundColor;

  /// Editor controller
  final EditorController? controller;

  /// Function onDone to return the story model when the user is finished editing
  final Function(StoryModel story)? onDone;

  /// Function onClose to return the story model when the user closes the editor
  final Function(StoryModel story)? onClose;

  /// FlutterStoriesEditor
  const FlutterStoriesEditor({
    Key? key,
    this.backgroundColor = Colors.black,
    this.topBar,
    this.onDone,
    this.onClose,
    this.controller,
  }) : super(key: key);

  @override
  State<FlutterStoriesEditor> createState() => _FlutterStoriesEditorState();
}

class _FlutterStoriesEditorState extends State<FlutterStoriesEditor> {
  late EditorController _editorController;

  @override
  void initState() {
    super.initState();
    _editorController = widget.controller ?? EditorController();
  }

  @override
  Widget build(BuildContext context) {
    return EditorView(
      controller: _editorController,
      backgroundColor: widget.backgroundColor,
      topBar: widget.topBar,
      onDone: widget.onDone,
      onClose: widget.onClose,
    );
  }
}
