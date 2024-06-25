part of '../flutter_stories_editor.dart';

void checkDeleteElement(StoryElement storyElement, Size screen) {
  if (storyElement.position.dy * screen.height > screen.height - 90) {
    _editorController._assets.removeAsset(storyElement);
  }
}

class RemoveBinWidget extends StatelessWidget {
  final Size screen;
  RemoveBinWidget({
    super.key,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<StoryElement?>(
      valueListenable: _editorController._selectedItem,
      builder: (BuildContext context, StoryElement? selectedItem, Widget? child) {
        return Positioned(
          bottom: 0,
          width: screen.width,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: selectedItem != null
                ? Container(
                    width: screen.width,
                    height: 50,
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
        );
      },
    );
  }
}
