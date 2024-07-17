import 'package:flutter/material.dart';

import '../../../models/editor_controller.dart';
import '../../../models/story_element.dart';
import '../../../utils/extensions.dart';
import '../../../utils/overlay_util.dart';
import '../../editor_view.dart';
import '../base_icon_button.dart';

class VideoTopBar extends StatelessWidget {
  final StoryElement storyElement;
  final EditorController editorController;

  const VideoTopBar({
    super.key,
    required this.storyElement,
    required this.editorController,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            BaseIconButton(
              icon: Padding(
                padding: uiSettings.buttonsPadding,
                child: Text(
                  uiSettings.cancelText,
                  style: uiSettings.cancelButtonsStyle,
                ),
              ),
              withText: true,
              onPressed: () {
                hideOverlay();
                storyElement.videoController?.dispose();
              },
            ),
            const Spacer(),
            BaseIconButton(
              icon: Padding(
                padding: uiSettings.buttonsPadding,
                child: Text(
                  uiSettings.doneText,
                  style: uiSettings.doneButtonsStyle,
                ),
              ),
              withText: true,
              onPressed: () {
                editorController.assets.addAsset(storyElement);
                hideOverlay();
              },
            ),
          ],
        ),
      ),
    );
  }
}
