import 'package:flutter/material.dart';

import '../../models/editor_controller.dart';
import '../../models/story_element.dart';
import 'base_story_element.dart';

class WidgetAsset extends StatelessWidget {
  final StoryElement storyElement;
  final bool isEditing;
  final Size screen;
  final EditorController editorController;

  const WidgetAsset({
    super.key,
    required this.storyElement,
    required this.screen,
    required this.editorController,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return BaseStoryElement(
      editorController: editorController,
      isEditing: isEditing,
      storyElement: storyElement,
      screen: screen,
      child: storyElement.child,
    );
  }
}
