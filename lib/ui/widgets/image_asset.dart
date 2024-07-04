import 'package:flutter/material.dart';

import '../../flutter_stories_editor.dart';
import '../../models/story_element.dart';
import 'base_story_element.dart';
import 'image_widget.dart';

class ImageAsset extends StatelessWidget {
  final StoryElement storyElement;
  final bool isEditing;
  final Size screen;
  final EditorController editorController;

  const ImageAsset({
    super.key,
    required this.storyElement,
    required this.screen,
    required this.isEditing,
    required this.editorController,
  });

  @override
  Widget build(BuildContext context) {
    return BaseStoryElement(
      editorController: editorController,
      isEditing: isEditing,
      storyElement: storyElement,
      screen: screen,
      child: Container(
        width: screen.width / 2,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: AppImage(
          image: storyElement.value,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}
