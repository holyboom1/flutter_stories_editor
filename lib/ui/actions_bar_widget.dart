import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/editor_controller.dart';
import 'widgets/base_icon_button.dart';
import 'widgets/image_widget.dart';

class ActionsBarWidget extends StatefulWidget {
  final EditorController editorController;

  const ActionsBarWidget({
    super.key,
    required this.editorController,
  });

  @override
  State<ActionsBarWidget> createState() => _ActionsBarWidgetState();
}

class _ActionsBarWidgetState extends State<ActionsBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (!widget.editorController.isAvailableToAddVideo)
            BaseIconButton(
              isCircle: false,
              onPressed: () {
                widget.editorController.muteVideo();
                setState(() {});
              },
              icon: const AppImage(image: Constants.muteIcon),
            ),
          const SizedBox(height: 16),
          BaseIconButton(
            isCircle: false,
            onPressed: () {
              widget.editorController.addText();
            },
            icon: const AppImage(image: Constants.textIcon),
          ),
          const SizedBox(height: 16),
          BaseIconButton(
            isCircle: false,
            onPressed: () {
              widget.editorController.addImage(context);
            },
            icon: const AppImage(image: Constants.imageIcon),
          ),
          const SizedBox(height: 16),

          BaseIconButton(
            isCircle: false,
            onPressed: () {
              widget.editorController.openFilter();
            },
            icon: const AppImage(image: Constants.filtersIcon),
          ),
          const SizedBox(height: 16),
          BaseIconButton(
            isCircle: false,
            onPressed: () {
              // widget.editorController.toggleFilter();
            },
            icon: const AppImage(image: Constants.musicIcon),
          ),
          const SizedBox(height: 16),

          // BaseIconButton(
          //   onPressed: () {
          //     if (Navigator.of(context).canPop()) {
          //       Navigator.of(context).pop();
          //     }
          //     print('Done button pressed');
          //     onDone?.call(editorController.complete());
          //   },
          //   icon: const Icon(
          //     Icons.check_circle_outline,
          //     color: Colors.white,
          //   ),
          // ),
        ],
      ),
    );
  }
}
