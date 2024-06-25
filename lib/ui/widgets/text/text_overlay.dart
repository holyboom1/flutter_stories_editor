import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../models/editor_controller.dart';
import '../../../models/item_type_enum.dart';
import '../../../models/story_element.dart';
import '../../../utils/box_size_util.dart';
import '../../../utils/extensions.dart';
import '../../../utils/overlay_util.dart';
import '../base_icon_button.dart';
import 'text_color_selector.dart';
import 'text_font_selector.dart';

class TextOverlay extends StatefulWidget {
  final StoryElement? storyElement;
  final Size screen;
  final EditorController editorController;

  const TextOverlay({
    super.key,
    this.storyElement,
    required this.screen,
    required this.editorController,
  });

  @override
  State<TextOverlay> createState() => _TextOverlayState();
}

class _TextOverlayState extends State<TextOverlay> {
  late StoryElement storyElement;
  final TextEditingController _controller = TextEditingController();

  bool isCreate = false;

  @override
  void initState() {
    super.initState();
    storyElement = widget.storyElement ??
        StoryElement(
          type: ItemType.text,
        );
    if (widget.storyElement == null) {
      isCreate = true;
    }
    storyElement.focusNode.requestFocus();
    _controller.text = storyElement.value;
  }

  TextAlign _textAlign = TextAlign.center;
  bool textBackground = false;
  bool textLetterSpace = false;

  void changeTextAlign() {
    switch (_textAlign) {
      case TextAlign.center:
        _textAlign = TextAlign.left;
        storyElement.textAlign = TextAlign.left;
        break;
      case TextAlign.left:
        _textAlign = TextAlign.right;
        storyElement.textAlign = TextAlign.right;
        break;
      case TextAlign.right:
        _textAlign = TextAlign.center;
        storyElement.textAlign = TextAlign.center;
        break;
      default:
        _textAlign = TextAlign.center;
        storyElement.textAlign = TextAlign.center;
        break;
    }
    setState(() {});
  }

  void changeContainerColor({required Color background, required Color text}) {
    storyElement.containerColor = background;
    storyElement.textStyle = storyElement.textStyle.copyWith(
      color: text,
    );
    setState(() {});
  }

  void changeTextLetterSpace() {
    textLetterSpace = !textLetterSpace;
    storyElement.textStyle = storyElement.textStyle.copyWith(
      letterSpacing: textLetterSpace ? 1.5 : 0.0,
    );
    setState(() {});
  }

  void changeTextBackground() {
    textBackground = !textBackground;
    if (storyElement.containerColor == Colors.white) {
      storyElement.containerColor = Colors.black;
      storyElement.textStyle = storyElement.textStyle.copyWith(
        color: Colors.white,
      );
    } else if (storyElement.containerColor == Colors.black) {
      storyElement.containerColor = Colors.transparent;
      storyElement.textStyle = storyElement.textStyle.copyWith(
        color: Colors.white,
      );
    } else {
      storyElement.containerColor = Colors.white;
      storyElement.textStyle = storyElement.textStyle.copyWith(
        color: Colors.black,
      );
    }
    setState(() {});
  }

  void showChangeContainerColor() {
    isColorSelection = !isColorSelection;
    setState(() {});
  }

  void complete({
    bool force = false,
  }) {
    storyElement.value = storyElement.value.trim();
    if (force) {
      if (storyElement.value.isEmpty) {
        hideOverlay();
      } else {
        widget.editorController.assets.addAsset(storyElement);
        hideOverlay();
      }
      return;
    }
    if (storyElement.focusNode.hasFocus) {
      FocusScope.of(context).unfocus();
    } else {
      if (storyElement.value.isEmpty) {
        hideOverlay();
      } else {
        widget.editorController.assets.addAsset(storyElement);
        hideOverlay();
      }
    }
  }

  void changeContainerFont({
    required TextStyle textStyle,
  }) {
    storyElement.textStyle = textStyle.copyWith(
      color: storyElement.textStyle.color,
    );
    setState(() {});
  }

  bool isColorSelection = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black45,
      child: GestureDetector(
        onTap: complete,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: storyElement.containerColor,
                    ),
                    child: IntrinsicWidth(
                      child: TextField(
                        controller: _controller,
                        focusNode: storyElement.focusNode,
                        textAlign: _textAlign,
                        style: storyElement.textStyle,
                        cursorColor:
                            storyElement.containerColor.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white,
                        minLines: 1,
                        maxLines: 1000,
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
                        onChanged: (String input) {
                          setState(() {
                            storyElement.value = input;
                          });
                        },
                        textInputAction: TextInputAction.newline,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        BaseIconButton(
                          icon: _textAlign == TextAlign.center
                              ? const Icon(
                                  Icons.format_align_center,
                                  color: Colors.white,
                                  size: 24,
                                )
                              : _textAlign == TextAlign.left
                                  ? const Icon(
                                      Icons.format_align_left,
                                      color: Colors.white,
                                      size: 24,
                                    )
                                  : const Icon(
                                      Icons.format_align_right,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                          onPressed: changeTextAlign,
                        ),
                        const SizedBox(width: 8),
                        BaseIconButton(
                          icon: isColorSelection
                              ? const Icon(
                                  Icons.text_fields,
                                  color: Colors.white,
                                  size: 24,
                                )
                              : Image.asset(
                                  Constants.iconPalet,
                                  width: 24,
                                  height: 24,
                                ),
                          onPressed: showChangeContainerColor,
                        ),
                        const SizedBox(width: 8),
                        BaseIconButton(
                          icon: textBackground
                              ? const Icon(
                                  Icons.text_snippet_outlined,
                                  color: Colors.white,
                                  size: 24,
                                )
                              : const Icon(
                                  Icons.text_snippet,
                                  color: Colors.white,
                                  size: 24,
                                ),
                          onPressed: changeTextBackground,
                        ),
                        const SizedBox(width: 8),
                        BaseIconButton(
                          icon: textLetterSpace
                              ? const Icon(
                                  Icons.text_fields,
                                  color: Colors.white,
                                  size: 24,
                                )
                              : const Icon(
                                  Icons.text_rotation_none_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                          onPressed: changeTextLetterSpace,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: GestureDetector(
                      onTap: () => complete(force: true),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                if (isCreate)
                  Offstage(
                    child: MeasureSize(
                      onChange: (Size size) {
                        storyElement.position = Offset(
                          (widget.screen.width - size.width) /
                              2 /
                              widget.screen.width,
                          (widget.screen.height - size.height) /
                              2 /
                              widget.screen.height,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: storyElement.containerColor,
                        ),
                        child: IntrinsicWidth(
                          child: TextField(
                            controller: _controller,
                            textAlign: storyElement.textAlign,
                            style: storyElement.textStyle,
                            minLines: 1,
                            maxLines: 1000,
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
                  ),
                Positioned(
                  left: 0,
                  top: 80,
                  child: RotatedBox(
                    quarterTurns: -1,
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            top: 12,
                          ),
                          child: CustomPaint(
                            size: const Size(160, 25),
                            painter: TrianglePainter(),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          height: 25,
                          child: Slider(
                            value: storyElement.textStyle.fontSize ?? 12,
                            min: 12,
                            max: 72,
                            activeColor: Colors.transparent,
                            inactiveColor: Colors.transparent,
                            thumbColor: Colors.white,
                            onChanged: (double newValue) {
                              setState(() {
                                storyElement.textStyle =
                                    storyElement.textStyle.copyWith(
                                  fontSize: newValue,
                                );
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                isColorSelection
                    ? TextFontSelector(
                        screen: widget.screen,
                        changeContainerFont: changeContainerFont,
                      )
                    : TextColorSelector(
                        screen: widget.screen,
                        changeContainerColor: changeContainerColor,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
