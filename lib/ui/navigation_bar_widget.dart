import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/editor_controller.dart';
import '../models/story_model.dart';
import 'widgets/base_icon_button.dart';
import 'widgets/image_widget.dart';

class NavigationBarWidget extends StatelessWidget {
  final EditorController editorController;
  final Function(Future<StoryModel> story)? onDone;
  final Function(Future<StoryModel> story)? onClose;

  const NavigationBarWidget({
    super.key,
    required this.editorController,
    this.onDone,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: <Widget>[
          BaseIconButton(
            icon: const AppImage(image: Constants.backArrowIcon),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
              onClose?.call(editorController.complete());
            },
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
