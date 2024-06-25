part of '../../flutter_stories_editor.dart';

class _ImageAsset extends StatelessWidget {
  final StoryElement storyElement;
  final bool isEditing;
  final Size screen;

  const _ImageAsset({
    super.key,
    required this.storyElement,
    required this.screen,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseStoryElement(
      isEditing: isEditing,
      storyElement: storyElement,
      screen: screen,
      child: Container(
        width: screen.width / 2,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: AppImage(
          image: storyElement.value,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}
