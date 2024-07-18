import 'package:flutter/material.dart';

import '../../models/editor_controller.dart';
import '../../models/item_type_enum.dart';
import '../../models/story_element.dart';
import '../../utils/extensions.dart';

class BaseStoryElement extends StatefulWidget {
  final StoryElement storyElement;
  final EditorController editorController;
  final Widget child;
  final Size screen;
  final bool isEditing;

  const BaseStoryElement({
    Key? key,
    required this.storyElement,
    required this.editorController,
    required this.child,
    required this.screen,
    required this.isEditing,
  }) : super(key: key);

  @override
  State<BaseStoryElement> createState() => _BaseStoryElementState();
}

class _BaseStoryElementState extends State<BaseStoryElement> {
  Offset initPos = Offset.zero;
  Offset currentPos = Offset.zero;
  double currentScale = 1.0;
  double currentRotation = 0.0;

  @override
  void initState() {
    super.initState();

    currentPos = widget.storyElement.position;
    currentScale = widget.storyElement.scale;
    currentRotation = widget.storyElement.rotation;
  }

  bool isAdded = false;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.storyElement.key.currentContext != null) {
        widget.storyElement.itemSize.value =
            (widget.storyElement.key.currentContext!.findRenderObject()!
                    as RenderBox)
                .size;
      }
    });

    if (widget.isEditing) {
      return Positioned(
        top: widget.storyElement.position.dy * widget.screen.height,
        left: widget.storyElement.position.dx * widget.screen.width,
        child: Transform.scale(
          scale: widget.storyElement.scale,
          child: Transform.rotate(
            angle: widget.storyElement.rotation,
            child: GestureDetector(
              onTap: () {
                widget.editorController.assets
                    .changeZIndex(asset: widget.storyElement);
              },
              onDoubleTap: () {
                switch (widget.storyElement.type) {
                  case ItemType.text:
                    widget.editorController.editText(widget.storyElement);
                    break;
                  case ItemType.image:
                    break;
                  case ItemType.video:
                    break;
                  case ItemType.audio:
                    break;
                  case ItemType.widget:
                    break;
                  case ItemType.none:
                    break;
                }
              },
              onScaleStart: (ScaleStartDetails details) {
                initPos = details.focalPoint;
                currentPos = widget.storyElement.position;
                currentScale = widget.storyElement.scale;
                currentRotation = widget.storyElement.rotation;
                widget.editorController.selectedItem.value =
                    widget.storyElement;
              },
              onScaleUpdate: (ScaleUpdateDetails details) {
                final Offset delta = details.focalPoint - initPos;
                final double left =
                    (delta.dx / widget.screen.width) + currentPos.dx;
                final double top =
                    (delta.dy / widget.screen.height) + currentPos.dy;

                setState(() {
                  widget.storyElement.position = Offset(left, top);
                  widget.storyElement.rotation =
                      details.rotation + currentRotation;
                  widget.storyElement.scale = details.scale * currentScale;
                  widget.storyElement.itemSize.value = Size(
                      widget.storyElement.itemSize.value.width +
                          (isAdded ? 0.00001 : -0.00001),
                      widget.storyElement.itemSize.value.height +
                          (isAdded ? 0.00001 : -0.00001));
                  isAdded = !isAdded;
                });
                widget.editorController.selectedItem.value =
                    widget.storyElement;

                if (widget.storyElement.position.dy * widget.screen.height >
                    widget.screen.height - 90) {
                  widget.storyElement.hoverDelete.value = true;
                } else if (widget.storyElement.hoverDelete.value) {
                  widget.storyElement.hoverDelete.value = false;
                }
              },
              onScaleEnd: (ScaleEndDetails details) {
                widget.editorController.checkDeleteElement(
                  widget.storyElement,
                  widget.screen,
                );
                widget.editorController.selectedItem.value = null;
              },
              child: SizedBox(
                key: widget.storyElement.key,
                child: widget.child,
              ),
            ),
          ),
        ),
      );
    }
    return Positioned(
      top: widget.storyElement.position.dy * widget.screen.height,
      left: widget.storyElement.position.dx * widget.screen.width,
      child: Transform.scale(
        scale: widget.storyElement.scale,
        child: Transform.rotate(
          angle: widget.storyElement.rotation,
          child: widget.child,
        ),
      ),
    );
  }
}
