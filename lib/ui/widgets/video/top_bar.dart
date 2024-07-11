import 'package:flutter/material.dart';

import '../../../models/editor_controller.dart';
import '../../../models/story_element.dart';
import '../../../utils/extensions.dart';
import '../../../utils/overlay_util.dart';
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
              icon: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w500,
                  ),
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
              icon: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w500,
                  ),
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
