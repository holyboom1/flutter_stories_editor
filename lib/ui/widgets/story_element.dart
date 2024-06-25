part of '../../flutter_stories_editor.dart';

class _StoryElementWidget extends StatelessWidget {
  final StoryElement storyElement;
  final Size screen;
  final bool isEditing;

  const _StoryElementWidget({
    required this.storyElement,
    required this.screen,
    required this.isEditing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    switch (storyElement.type) {
      case ItemType.text:
        return _TextAsset(
          storyElement: storyElement,
          screen: screen,
          isEditing: isEditing,
        );
      case ItemType.image:
        return _ImageAsset(
          storyElement: storyElement,
          screen: screen,
          isEditing: isEditing,
        );
      case ItemType.video:
      // TODO: Handle this case.
      case ItemType.audio:
      // TODO: Handle this case.
      case ItemType.widget:
        return _WidgetAsset(
          storyElement: storyElement,
          screen: screen,
          isEditing: isEditing,
        );
      case ItemType.none:
        return const SizedBox();
    }
  }
}
