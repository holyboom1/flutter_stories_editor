import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'flutter_stories_editor.dart';
import 'models/item_type_enum.dart';
import 'models/story_element.dart';
import 'ui/widgets/story_element.dart';
import 'utils/color_filters/colorfilter_generator.dart';
import 'utils/color_filters/presets.dart';

/// FlutterStoriesViewer
class FlutterStoriesViewer extends StatefulWidget {
  /// Top bar config
  final StoryModel storyModel;

  /// Loading widget
  final Widget? loadingWidget;

  /// Callback when the viewer is ready and video duration is changed
  final Function(bool isInited, Duration currnetPosition)? onVideoEvent;

  /// FlutterStoriesViewer
  const FlutterStoriesViewer({
    Key? key,
    required this.storyModel,
    this.onVideoEvent,
    this.loadingWidget,
  }) : super(key: key);

  @override
  State<FlutterStoriesViewer> createState() => _FlutterStoriesViewerState();
}

class _FlutterStoriesViewerState extends State<FlutterStoriesViewer> {
  @override
  void dispose() {
    isLoaded = false;
    widget.storyModel.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    bool containsVideo = widget.storyModel.elements.any(
      (StoryElement e) =>
          e.type == ItemType.video || e.type == ItemType.imageVideo,
    );
    if (!containsVideo) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  bool isLoaded = false;

  void onVideoEvent(bool isInited, Duration currentPosition) {
    widget.onVideoEvent?.call(isInited, currentPosition);
    if (!isLoaded && currentPosition > Duration.zero) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      key: ValueKey<String>(widget.storyModel.id),
      aspectRatio: 9 / 16.5,
      child: Container(
        key: ValueKey<String>(widget.storyModel.id),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[...widget.storyModel.paletteColors],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ColorFiltered(
          key: ValueKey<String>(widget.storyModel.id),
          colorFilter: ColorFilter.matrix(presetFiltersList
                  .firstWhereOrNull(
                    (ColorFilterGenerator e) =>
                        e.name == widget.storyModel.colorFilter,
                  )
                  ?.matrix ??
              PresetFilters.none.matrix),
          child: LayoutBuilder(
            key: ValueKey<String>(widget.storyModel.id),
            builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
                key: ValueKey<String>(widget.storyModel.id),
                children: <Widget>[
                  ...widget.storyModel.elements.map(
                    (StoryElement e) {
                      return StoryElementWidget(
                        storyElement: e,
                        key: ValueKey<String>(e.id),
                        screen: constraints.biggest,
                        isEditing: false,
                        editorController: EditorController(),
                        onVideoEvent: onVideoEvent,
                      );
                    },
                  ).toList(),
                  if (!isLoaded)
                    widget.loadingWidget ??
                        const Center(child: CircularProgressIndicator())
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
