part of '../../../flutter_stories_editor.dart';

class _TextAsset extends StatefulWidget {
  final StoryElement storyElement;
  final Size screen;
  final bool isEditing;
  const _TextAsset({
    super.key,
    required this.storyElement,
    required this.screen,
    required this.isEditing,
  });

  @override
  State<_TextAsset> createState() => _TextAssetState();
}

class _TextAssetState extends State<_TextAsset> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.storyElement.value;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEditing) {
      return _BaseStoryElement(
        storyElement: widget.storyElement,
        isEditing: widget.isEditing,
        screen: widget.screen,
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
              child: Text(
                widget.storyElement.value,
                style: widget.storyElement.textStyle,
                textAlign: widget.storyElement.textAlign,
              ),
            ),
          ),
        ),
      );
    }
    return _BaseStoryElement(
      storyElement: widget.storyElement,
      isEditing: widget.isEditing,
      screen: widget.screen,
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
