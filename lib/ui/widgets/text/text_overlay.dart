import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../models/editor_controller.dart';
import '../../../models/item_type_enum.dart';
import '../../../models/story_element.dart';
import '../../../utils/box_size_util.dart';
import '../../../utils/extensions.dart';
import '../../../utils/overlay_util.dart';
import '../../editor_view.dart';
import '../base_icon_button.dart';
import '../image_widget.dart';
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
    _textAlign = storyElement.textAlign;
    textLetterSpace = storyElement.textStyle.letterSpacing != 0.0;
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
                        cursorColor: storyElement.containerColor.computeLuminance() > 0.5
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
                          },
                        ),
                        const Spacer(
                          flex: 2,
                        ),
                        GestureDetector(
                          onTap: showChangeContainerColor,
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: !isColorSelection ? Colors.white : const Color(0x99131313),
                                width: 2,
                              ),
                            ),
                            child: const AppImage(image: Constants.iconPalet),
                          ),
                        ),
                        const Spacer(),
                        BaseIconButton(
                          icon: isColorSelection
                              ? const AppImage(image: Constants.textAaBlackIcon)
                              : const AppImage(image: Constants.textAaWhiteIcon),
                          onPressed: showChangeContainerColor,
                          backgroundColor:
                              isColorSelection ? Colors.white : const Color(0x99131313),
                        ),
                        const Spacer(),
                        BaseIconButton(
                          icon: _textAlign == TextAlign.center
                              ? const AppImage(
                                  image: Constants.alignCenterIcon,
                                  colorFilter: ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                )
                              : _textAlign == TextAlign.left
                                  ? const AppImage(
                                      image: Constants.alignLeftIcon,
                                      colorFilter: ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    )
                                  : const AppImage(
                                      image: Constants.alignRightIcon,
                                      colorFilter: ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                          onPressed: changeTextAlign,
                        ),
                        const Spacer(
                          flex: 2,
                        ),
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
                            complete(force: true);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                if (isCreate)
                  Offstage(
                    child: MeasureSize(
                      onChange: (Size size) {
                        storyElement.position = Offset(
                          (widget.screen.width - size.width) / 2 / widget.screen.width,
                          (widget.screen.height - size.height) / 2 / widget.screen.height,
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
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      top: 12,
                    ),
                    child: CustomPaint(
                      size: const Size(25, 160),
                      painter: TrianglePainter(),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  top: 80,
                  child: RotatedBox(
                    quarterTurns: -1,
                    child: SizedBox(
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
                            storyElement.textStyle = storyElement.textStyle.copyWith(
                              fontSize: newValue,
                            );
                          });
                        },
                      ),
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
      ..color = Colors.black.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    const double cornerRadius = 15.0;
    final Path path = Path();

    path.moveTo(size.width / 2, size.height);
    path.lineTo(size.width, cornerRadius);
    path.quadraticBezierTo(size.width, 0, size.width - cornerRadius, 0);
    path.lineTo(cornerRadius, 0);
    path.quadraticBezierTo(0, 0, 0, cornerRadius);
    path.lineTo(size.width / 2, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
