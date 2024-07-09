import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../models/editor_controller.dart';
import '../../../models/story_element.dart';
import '../base_story_element.dart';

class TextAsset extends StatefulWidget {
  final StoryElement storyElement;
  final Size screen;
  final bool isEditing;
  final EditorController editorController;
  final Function(String tappedText)? onTextTap;

  const TextAsset({
    super.key,
    required this.storyElement,
    required this.screen,
    required this.isEditing,
    required this.editorController,
    this.onTextTap,
  });

  @override
  State<TextAsset> createState() => _TextAssetState();
}

class _TextAssetState extends State<TextAsset> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.storyElement.value;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEditing) {
      final List<String> rows = widget.storyElement.value.split('\n');
      final List<List<String>> wordsInRows = rows.map((String row) => row.split(' ')).toList();
      return BaseStoryElement(
        editorController: widget.editorController,
        storyElement: widget.storyElement,
        isEditing: widget.isEditing,
        screen: widget.screen,
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: widget.storyElement.containerColor,
          ),
          child: IntrinsicWidth(
            child: RichText(
              textAlign: widget.storyElement.textAlign,
              strutStyle: StrutStyle(
                fontSize: widget.storyElement.textStyle.fontSize,
                height: 1.5,
                fontFamily: widget.storyElement.textStyle.fontFamily,
                fontStyle: widget.storyElement.textStyle.fontStyle,
                fontWeight: widget.storyElement.textStyle.fontWeight,
              ),
              text: TextSpan(
                style: widget.storyElement.textStyle,
                children: List<TextSpan>.generate(
                  rows.length,
                  (int rowIndex) => TextSpan(
                    text: '',
                    children: <TextSpan>[
                      ...List<TextSpan>.generate(
                        wordsInRows[rowIndex].length,
                        (int wordsIndex) => TextSpan(
                          text: (wordsIndex == 0 ? '' : ' ') + wordsInRows[rowIndex][wordsIndex],
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              widget.onTextTap?.call(wordsInRows[rowIndex][wordsIndex]);
                              print('#Print# : asdasd ${wordsInRows[rowIndex][wordsIndex]}');
                            },
                        ),
                      ),
                      if (rowIndex < rows.length - 1) const TextSpan(text: '\n'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return BaseStoryElement(
      storyElement: widget.storyElement,
      isEditing: widget.isEditing,
      screen: widget.screen,
      editorController: widget.editorController,
      child: AbsorbPointer(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: widget.storyElement.containerColor,
          ),
          child: IntrinsicWidth(
            child: TextField(
              controller: _controller,
              textAlign: widget.storyElement.textAlign,
              style: widget.storyElement.textStyle,
              minLines: 1,
              maxLines: 1000,
              cursorWidth: 0,
              cursorHeight: 0,
              showCursor: false,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
