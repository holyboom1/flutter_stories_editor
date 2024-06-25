part of '../../flutter_stories_editor.dart';

class _WidgetAsset extends StatelessWidget {
  final StoryElement storyElement;
  final bool isEditing;
  final Size screen;

  const _WidgetAsset({
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
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(8),
        child: storyElement.child,
      ),
    );
  }
}
