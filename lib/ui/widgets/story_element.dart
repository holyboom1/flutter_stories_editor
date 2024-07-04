import 'package:flutter/material.dart';

import '../../flutter_stories_editor.dart';
import '../../models/item_type_enum.dart';
import '../../models/story_element.dart';
import 'image_asset.dart';
import 'text/text_asset.dart';
import 'video_asset.dart';
import 'widget_asset.dart';

class StoryElementWidget extends StatelessWidget {
  final StoryElement storyElement;
  final Size screen;
  final bool isEditing;
  final EditorController editorController;

  const StoryElementWidget({
    required this.storyElement,
    required this.screen,
    required this.isEditing,
    required this.editorController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    switch (storyElement.type) {
      case ItemType.text:
        return TextAsset(
          storyElement: storyElement,
          screen: screen,
          isEditing: isEditing,
          editorController: editorController,
        );
      case ItemType.image:
        return ImageAsset(
          storyElement: storyElement,
          screen: screen,
          editorController: editorController,
          isEditing: isEditing,
        );
      case ItemType.video:
        return VideoAsset(
          storyElement: storyElement,
          screen: screen,
          isEditing: isEditing,
          editorController: editorController,
        );
      case ItemType.audio:
      // TODO: Handle this case.
      case ItemType.widget:
        return WidgetAsset(
          storyElement: storyElement,
          screen: screen,
          editorController: editorController,
          isEditing: isEditing,
        );
      case ItemType.none:
        return const SizedBox();
    }
  }
}
