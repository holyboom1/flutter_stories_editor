library flutter_stories_editor;

import 'package:advanced_media_picker/advanced_media_picker.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'flutter_stories_editor.dart';
import 'models/item_type_enum.dart';
import 'models/story_element.dart';
import 'models/story_model.dart';
import 'ui/widgets/base_icon_button.dart';
import 'ui/widgets/image_widget.dart';
import 'ui/widgets/text/text_color_selector.dart';
import 'ui/widgets/text/text_font_selector.dart';
import 'utils/box_size_util.dart';
import 'utils/color_filters/colorfilter_generator.dart';
import 'utils/color_filters/presets.dart';
import 'utils/extensions.dart';

export 'models/story_element.dart';

part 'flutter_stories_view.dart';
part 'models/editor_controller.dart';
part 'ui/remove_bin_widget.dart';
part 'ui/top_bar_widget.dart';
part 'ui/widgets/base_story_element.dart';
part 'ui/widgets/filters_selector.dart';
part 'ui/widgets/image_asset.dart';
part 'ui/widgets/story_element.dart';
part 'ui/widgets/text/text_asset.dart';
part 'ui/widgets/text/text_overlay.dart';
part 'ui/widgets/widget_asset.dart';
part 'utils/overlay_util.dart';

/// FlutterStoriesEditor
class FlutterStoriesEditor extends StatefulWidget {
  /// Top bar config
  final Widget? topBar;

  /// Background color
  final Color? backgroundColor;

  /// Editor controller
  final EditorController? controller;

  /// Function onDone to return the story model when the user is finished editing
  final Function(StoryModel story)? onDone;

  /// Function onClose to return the story model when the user closes the editor
  final Function(StoryModel story)? onClose;

  /// FlutterStoriesEditor
  const FlutterStoriesEditor({
    Key? key,
    this.controller,
    this.backgroundColor = Colors.pink,
    this.topBar,
    this.onDone,
    this.onClose,
  }) : super(key: key);

  @override
  State<FlutterStoriesEditor> createState() => _FlutterStoriesEditorState();
}

late EditorController _editorController;

class _FlutterStoriesEditorState extends State<FlutterStoriesEditor> {
  @override
  void initState() {
    super.initState();
    _editorController = widget.controller ?? EditorController();
    _editorController._assets.addListener(onUpdateAssets);
  }

  void onUpdateAssets() {
    setState(() {});
  }

  @override
  void dispose() {
    _editorController._assets.removeListener(onUpdateAssets);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OverlayBuilder(
      child: SizedBox(
        width: double.infinity,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: AspectRatio(
            aspectRatio: 9 / 16.5,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                  ),
                  child: Stack(
                    children: <Widget>[
                      RemoveBinWidget(
                        screen: constraints.biggest,
                      ),
                      ValueListenableBuilder<ColorFilterGenerator>(
                          valueListenable: _editorController._selectedFilter,
                          builder: (BuildContext context,
                              ColorFilterGenerator value, Widget? child) {
                            return ColorFiltered(
                              colorFilter: ColorFilter.matrix(value.matrix),
                              child: child,
                            );
                          },
                          child: Stack(
                            children: <Widget>[
                              ..._editorController._assets.value.map(
                                (StoryElement e) {
                                  return _StoryElementWidget(
                                    storyElement: e,
                                    screen: constraints.biggest,
                                    isEditing: true,
                                  );
                                },
                              ).toList()
                            ],
                          )),
                      ValueListenableBuilder<bool>(
                        valueListenable: isShowingOverlay,
                        builder:
                            (BuildContext context, bool value, Widget? child) {
                          return Positioned(
                            top: 0,
                            width: MediaQuery.of(context).size.width,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: value
                                  ? const SizedBox()
                                  : widget.topBar ??
                                      TopBarWidget(
                                        onClose: widget.onClose,
                                        onDone: widget.onDone,
                                      ),
                            ),
                          );
                        },
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: isShowingOverlay,
                        builder: (BuildContext context, bool isShowingOverlay,
                            Widget? child) {
                          return Positioned(
                            bottom: 0,
                            width: MediaQuery.of(context).size.width,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: isShowingOverlay
                                  ? const SizedBox()
                                  : ValueListenableBuilder<bool>(
                                      valueListenable:
                                          _editorController._isShowFilters,
                                      builder: (BuildContext context,
                                          bool value, Widget? child) {
                                        return AnimatedSwitcher(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          child: !value
                                              ? const SizedBox()
                                              : FiltersSelector(
                                                  onFilterSelected:
                                                      (ColorFilterGenerator
                                                          filter) {
                                                    _editorController
                                                        ._selectedFilter
                                                        .value = filter;
                                                  },
                                                ),
                                        );
                                      },
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
