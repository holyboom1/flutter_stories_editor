import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

import '../models/editor_controller.dart';
import '../models/item_type_enum.dart';
import '../models/story_element.dart';
import '../models/story_model.dart';
import '../utils/color_filters/colorfilter_generator.dart';
import '../utils/overlay_util.dart';
import '../utils/palette_generator_util.dart';
import '../utils/video_editor/lib/domain/entities/cover_data.dart';
import '../utils/video_editor/lib/domain/thumbnails.dart';
import 'remove_bin_widget.dart';
import 'top_bar_widget.dart';
import 'widgets/filters_selector.dart';
import 'widgets/story_element.dart';

class EditorView extends StatefulWidget {
  final Widget? topBar;

  final Color backgroundColor;

  final EditorController controller;

  final Function(StoryModel story)? onDone;

  final Function(StoryModel story)? onClose;

  const EditorView(
      {Key? key,
      required this.backgroundColor,
      required this.controller,
      this.topBar,
      this.onDone,
      this.onClose})
      : super(key: key);

  @override
  _EditorViewState createState() => _EditorViewState();
}

class _EditorViewState extends State<EditorView> {
  @override
  void initState() {
    super.initState();
    widget.controller.assets.addListener(onUpdateAssets);
    widget.controller.assets.addListener(setColor);
  }

  void onUpdateAssets() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller.assets.removeListener(onUpdateAssets);
    widget.controller.assets.removeListener(setColor);
    super.dispose();
  }

  bool isColorSet = false;

  Future<void> setColor() async {
    if (!isColorSet) {
      final bool containsImage =
          widget.controller.assets.value.any((StoryElement element) {
        return element.type == ItemType.image || element.type == ItemType.video;
      });
      if (containsImage) {
        final StoryElement element =
            widget.controller.assets.value.firstWhere((StoryElement element) {
          return element.type == ItemType.image ||
              element.type == ItemType.video;
        });
        if (element.type == ItemType.video) {
          final CoverData videoCover =
              await generateSingleCoverThumbnail(element.value);
          paletteColor = await PaletteGeneratorUtil.getGeneratorFromData(
              videoCover.thumbData ?? Uint8List(0));
        } else {
          paletteColor =
              await PaletteGeneratorUtil.getGeneratorFromPath(element.value);
        }
        isColorSet = true;
        setState(() {});
      }
    }
  }

  PaletteGenerator? paletteColor;

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
                return AnimatedContainer(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        if (paletteColor != null) ...<Color>[
                          paletteColor!.colors.first,
                          paletteColor!.colors.last
                        ] else ...<Color>[
                          widget.backgroundColor,
                          widget.backgroundColor
                        ],
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  duration: const Duration(milliseconds: 300),
                  child: Stack(
                    children: <Widget>[
                      RemoveBinWidget(
                        screen: constraints.biggest,
                        editorController: widget.controller,
                      ),
                      ValueListenableBuilder<ColorFilterGenerator>(
                          valueListenable: widget.controller.selectedFilter,
                          builder: (BuildContext context,
                              ColorFilterGenerator value, Widget? child) {
                            return ColorFiltered(
                              colorFilter: ColorFilter.matrix(value.matrix),
                              child: child,
                            );
                          },
                          child: Stack(
                            children: <Widget>[
                              ...widget.controller.assets.value.map(
                                (StoryElement e) {
                                  return StoryElementWidget(
                                    storyElement: e,
                                    screen: constraints.biggest,
                                    isEditing: true,
                                    editorController: widget.controller,
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
                                        editorController: widget.controller,
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
                                          widget.controller.isShowFilters,
                                      builder: (BuildContext context,
                                          bool value, Widget? child) {
                                        return AnimatedSwitcher(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          child: !value
                                              ? const SizedBox()
                                              : FiltersSelector(
                                                  editorController:
                                                      widget.controller,
                                                  onFilterSelected:
                                                      (ColorFilterGenerator
                                                          filter) {
                                                    widget
                                                        .controller
                                                        .selectedFilter
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