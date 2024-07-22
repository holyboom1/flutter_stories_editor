library flutter_stories_editor;

import 'package:flutter/material.dart';

import 'models/editor_controller.dart';
import 'models/story_model.dart';
import 'models/ui_settings.dart';
import 'ui/editor_view.dart';

export 'package:cross_file/cross_file.dart';

export 'flutter_stories_view.dart';
export 'models/editor_controller.dart';
export 'models/story_model.dart';
export 'utils/compress_service.dart';
export 'utils/video_editor/lib/domain/entities/trim_style.dart';

/// FlutterStoriesEditor
class FlutterStoriesEditor extends StatefulWidget {
  /// Top bar config
  final Widget? topBar;

  /// Actions bar config
  final Widget? actionsBar;

  /// Background color
  final Color backgroundColor;

  /// Editor controller
  final EditorController? controller;

  /// Function onDone to return the story model when the user is finished editing
  final Function(Future<StoryModel> story)? onDone;

  /// Function onClose to return the story model when the user closes the editor
  final Function(Future<StoryModel> story)? onClose;

  /// Additional actions to be added to the actions bar
  final List<Widget> additionalActions;

  /// UI settings
  final StoryEditorUiSettings uiSettings;

  /// FlutterStoriesEditor
  const FlutterStoriesEditor({
    Key? key,
    this.backgroundColor = Colors.black,
    this.topBar,
    this.actionsBar,
    this.additionalActions = const <Widget>[],
    this.onDone,
    this.onClose,
    this.controller,
    this.uiSettings = const StoryEditorUiSettings(),
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EditorView(
      controller: _editorController,
      backgroundColor: widget.backgroundColor,
      topBar: widget.topBar,
      actionsBar: widget.actionsBar,
      additionalActions: widget.additionalActions,
      onDone: widget.onDone,
      onClose: widget.onClose,
      uiSettings: widget.uiSettings,
    );
  }
}
