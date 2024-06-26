import 'package:flutter/material.dart';

import '../models/editor_controller.dart';
import '../models/story_element.dart';
import '../ui/widgets/text/text_overlay.dart';

class OverlayBuilder extends StatefulWidget {
  final Widget child;

  const OverlayBuilder({
    required this.child,
  });

  @override
  _OverlayBuilderState createState() => _OverlayBuilderState();
}

class _OverlayBuilderState extends State<OverlayBuilder>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    _overlayAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void didUpdateWidget(OverlayBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    // WidgetsBinding.instance.addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void reassemble() {
    super.reassemble();
    // WidgetsBinding.instance.addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void dispose() {
    if (isShowingOverlay.value) {
      hideOverlay();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return widget.child;
  }
}

AnimationController? _overlayAnimationController;

OverlayEntry? _overlayEntry;

ValueNotifier<bool> isShowingOverlay = ValueNotifier<bool>(false);
BuildContext? _context;

Future<void> showTextOverlay({
  StoryElement? storyElement,
  required EditorController editorController,
}) async {
  if (_overlayAnimationController == null) {
    return;
  }
  const Curve curve = Curves.easeOut;
  isShowingOverlay.value = true;
  _overlayEntry = OverlayEntry(
    builder: (BuildContext context) {
      return AnimatedBuilder(
        animation: _overlayAnimationController!,
        builder: (BuildContext context, Widget? child) {
          final double animationValue =
              curve.transform(_overlayAnimationController!.value);

          return Opacity(
            opacity: animationValue,
            child: TextOverlay(
              editorController: editorController,
              storyElement: storyElement,
              screen: MediaQuery.of(context).size,
            ),
          );
        },
      );
    },
  );
  if (_overlayEntry != null) {
    await addToOverlay(_overlayEntry!);
    await _overlayAnimationController!.forward();
  }
}

Future<void> addToOverlay(OverlayEntry entry) async {
  if (_context == null) {
    return;
  }
  Overlay.of(_context!).insert(entry);
}

Future<void> hideOverlay() async {
  await _overlayAnimationController?.reverse(from: 1);
  isShowingOverlay.value = false;
  _overlayEntry?.remove();
  _overlayEntry = null;
}
