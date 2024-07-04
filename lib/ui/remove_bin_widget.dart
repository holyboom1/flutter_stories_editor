import 'package:flutter/material.dart';

import '../flutter_stories_editor.dart';
import '../models/story_element.dart';

class RemoveBinWidget extends StatelessWidget {
  final EditorController editorController;
  final Size screen;
  const RemoveBinWidget({
    super.key,
    required this.screen,
    required this.editorController,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<StoryElement?>(
      valueListenable: editorController.selectedItem,
      builder:
          (BuildContext context, StoryElement? selectedItem, Widget? child) {
        return Positioned(
          bottom: 0,
          width: screen.width,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: selectedItem != null
                ? Container(
                    width: screen.width,
                    height: 50,
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
        );
      },
    );
  }
}
