import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'flutter_stories_editor.dart';
import 'models/story_element.dart';
import 'ui/widgets/story_element.dart';
import 'utils/color_filters/colorfilter_generator.dart';
import 'utils/color_filters/presets.dart';

/// FlutterStoriesViewer
class FlutterStoriesViewer extends StatelessWidget {
  /// Top bar config
  final StoryModel storyModel;

  /// Callback when the viewer is ready
  final Function(bool isReady)? onReady;

  /// FlutterStoriesViewer
  const FlutterStoriesViewer({
    Key? key,
    required this.storyModel,
    this.onReady,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      key: ValueKey<String>(storyModel.id),
      aspectRatio: 9 / 16.5,
      child: Container(
        key: ValueKey<String>(storyModel.id),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[...storyModel.paletteColors],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ColorFiltered(
          key: ValueKey<String>(storyModel.id),
          colorFilter: ColorFilter.matrix(presetFiltersList
                  .firstWhereOrNull(
                    (ColorFilterGenerator e) => e.name == storyModel.colorFilter,
                  )
                  ?.matrix ??
              PresetFilters.none.matrix),
          child: LayoutBuilder(
            key: ValueKey<String>(storyModel.id),
            builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
                key: ValueKey<String>(storyModel.id),
                children: <Widget>[
                  ...storyModel.elements.map(
                    (StoryElement e) {
                      return StoryElementWidget(
                        storyElement: e,
                        key: ValueKey<int>(e.id),
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
