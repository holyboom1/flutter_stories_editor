import 'package:flutter/material.dart';

/// UI settings for the story editor.
class StoryEditorUiSettings {
  /// Text for the done button.
  final String doneText;

  /// Text for the cancel button.
  final String cancelText;

  /// Style for the done button.
  final TextStyle doneButtonsStyle;

  /// Padding for the buttons.
  final EdgeInsets buttonsPadding;

  /// Style for the cancel button.
  final TextStyle cancelButtonsStyle;

  /// Constructor.
  const StoryEditorUiSettings({
    this.doneText = 'Done',
    this.cancelText = 'Cancel',
    this.doneButtonsStyle = const TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
    this.buttonsPadding = const EdgeInsets.symmetric(
      horizontal: 8,
    ),
    this.cancelButtonsStyle = const TextStyle(
      color: Colors.white,
    ),
  });
}
