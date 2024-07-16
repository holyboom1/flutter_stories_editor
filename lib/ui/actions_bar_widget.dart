import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/editor_controller.dart';
import 'widgets/base_icon_button.dart';
import 'widgets/image_widget.dart';

class ActionsBarWidget extends StatefulWidget {
  final EditorController editorController;
  final List<Widget> additionalActions;

  const ActionsBarWidget({
    super.key,
    required this.editorController,
    this.additionalActions = const <Widget>[],
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
          for (final Widget action in widget.additionalActions) ...<Widget>[
            action,
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}
