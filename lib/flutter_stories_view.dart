part of 'flutter_stories_editor.dart';

/// FlutterStoriesViewer
class FlutterStoriesViewer extends StatefulWidget {
  /// Top bar config
  final StoryModel storyModel;

  /// Background color
  final Color backgroundColor;

  /// FlutterStoriesViewer
  const FlutterStoriesViewer({
    Key? key,
    required this.storyModel,
    this.backgroundColor = Colors.pink,
  }) : super(key: key);

  @override
  State<FlutterStoriesViewer> createState() => _FlutterStoriesViewerState();
}

class _FlutterStoriesViewerState extends State<FlutterStoriesViewer> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 9 / 16.5,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
        ),
        child: ColorFiltered(
          colorFilter: ColorFilter.matrix(widget.storyModel.colorFiler.matrix),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
                children: <Widget>[
                  ...widget.storyModel.elements.map(
                    (StoryElement e) {
                      return _StoryElementWidget(
                        storyElement: e,
                        screen: constraints.biggest,
                        isEditing: false,
                      );
                    },
                  ).toList()
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
