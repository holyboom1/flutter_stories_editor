part of '../flutter_stories_editor.dart';

class TopBarWidget extends StatelessWidget {
  final Function(StoryModel story)? onDone;
  final Function(StoryModel story)? onClose;

  const TopBarWidget({
    super.key,
    this.onDone,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: <Widget>[
          BaseIconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
              print('Back button pressed');
              onClose?.call(_editorController.complete());
            },
          ),
          const Spacer(),
          BaseIconButton(
            onPressed: () {
              _editorController.addText();
            },
            icon: const Icon(
              Icons.text_fields,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          BaseIconButton(
            onPressed: () {
              _editorController.addImage(context);
            },
            icon: const Icon(
              Icons.image,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          BaseIconButton(
            onPressed: () {
              _editorController.toggleFilter();
            },
            icon: const Icon(
              Icons.local_fire_department,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 32),
          BaseIconButton(
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
              print('Done button pressed');
              onDone?.call(_editorController.complete());
            },
            icon: const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
