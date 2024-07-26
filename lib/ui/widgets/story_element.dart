import 'package:flutter/material.dart';

import '../../flutter_stories_editor.dart';
import '../../models/item_type_enum.dart';
import '../../models/story_element.dart';
import 'audio_asset.dart';
import 'image_asset.dart';
import 'text/text_asset.dart';
import 'video_asset.dart';
import 'video_image_asset.dart';
import 'widget_asset.dart';

class StoryElementWidget extends StatelessWidget {
  final StoryElement storyElement;
  final Size screen;
  final bool isEditing;
  final EditorController editorController;
  final Function(bool isInited, Duration currnetPosition)? onVideoEvent;

  const StoryElementWidget({
    required this.storyElement,
    required this.screen,
    required this.isEditing,
    required this.editorController,
    this.onVideoEvent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    switch (storyElement.type) {
      case ItemType.text:
        return TextAsset(
          key: super.key,
          storyElement: storyElement,
          screen: screen,
          isEditing: isEditing,
          editorController: editorController,
        );
      case ItemType.image:
        return ImageAsset(
          key: super.key,
          storyElement: storyElement,
          screen: screen,
          editorController: editorController,
          isEditing: isEditing,
        );
      case ItemType.video:
        return VideoAsset(
          onVideoEvent: onVideoEvent,
          key: super.key,
          storyElement: storyElement,
          screen: screen,
          isEditing: isEditing,
          editorController: editorController,
        );
      case ItemType.imageVideo:
        return VideoImageAsset(
          storyElement: storyElement,
          screen: screen,
          isEditing: isEditing,
          editorController: editorController,
          onVideoEvent: onVideoEvent,
        );
      case ItemType.audio:
        return AudioAsset(
          key: super.key,
          storyElement: storyElement,
          isEditing: isEditing,
          editorController: editorController,
        );
      case ItemType.widget:
        return WidgetAsset(
          key: super.key,
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
