import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'flutter_stories_editor.dart';
import 'models/story_element.dart';
import 'ui/widgets/story_element.dart';
import 'utils/color_filters/colorfilter_generator.dart';
import 'utils/color_filters/presets.dart';

/// FlutterStoriesViewer
class FlutterStoriesViewer extends StatefulWidget {
  /// Top bar config
  final StoryModel storyModel;

  /// FlutterStoriesViewer
  const FlutterStoriesViewer({
    Key? key,
    required this.storyModel,
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
          gradient: LinearGradient(
            colors: <Color>[...widget.storyModel.paletteColors],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ColorFiltered(
          colorFilter: ColorFilter.matrix(presetFiltersList
                  .firstWhereOrNull(
                    (ColorFilterGenerator e) =>
                        e.name == widget.storyModel.colorFilter,
                  )
                  ?.matrix ??
              PresetFilters.none.matrix),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
                children: <Widget>[
                  // if (widget.storyModel.storyItemFile != null)
                  //   if (widget.storyModel.isVideoIncluded)
                  //     Container(
                  //       width: constraints.maxWidth,
                  //       height: constraints.maxHeight,
                  //       color: Colors.red,
                  //     )
                  //   else if (widget.storyModel.storyItemFile != null)
                  //     Image.file(File(widget.storyModel.storyItemFile!.path))
                  //   else
                  //     AppImage(
                  //       image: widget.storyModel.storyItemUrl,
                  //       fit: BoxFit.cover,
                  //     ),
                  ...widget.storyModel.elements.map(
                    (StoryElement e) {
                      return StoryElementWidget(
                        storyElement: e,
                        screen: constraints.biggest,
                        isEditing: false,
                        editorController: EditorController(),
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
