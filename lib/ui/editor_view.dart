import 'package:flutter/material.dart';

import '../models/editor_controller.dart';
import '../models/story_element.dart';
import '../models/story_model.dart';
import '../utils/color_filters/colorfilter_generator.dart';
import '../utils/overlay_util.dart';
import 'remove_bin_widget.dart';
import 'top_bar_widget.dart';
import 'widgets/filters_selector.dart';
import 'widgets/story_element.dart';

class EditorView extends StatefulWidget {
  final Widget? topBar;

  final Color? backgroundColor;

  final EditorController? controller;

  final Function(StoryModel story)? onDone;

  final Function(StoryModel story)? onClose;

  const EditorView(
      {Key? key,
      this.topBar,
      this.backgroundColor,
      this.controller,
      this.onDone,
      this.onClose})
      : super(key: key);

  @override
  _EditorViewState createState() => _EditorViewState();
}

class _EditorViewState extends State<EditorView> {
  late EditorController _editorController;

  @override
  void initState() {
    super.initState();
    _editorController = widget.controller ?? EditorController();
    _editorController.assets.addListener(onUpdateAssets);
  }

  void onUpdateAssets() {
    setState(() {});
  }

  @override
  void dispose() {
    _editorController.assets.removeListener(onUpdateAssets);
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
                        editorController: _editorController,
                      ),
                      ValueListenableBuilder<ColorFilterGenerator>(
                          valueListenable: _editorController.selectedFilter,
                          builder: (BuildContext context,
                              ColorFilterGenerator value, Widget? child) {
                            return ColorFiltered(
                              colorFilter: ColorFilter.matrix(value.matrix),
                              child: child,
                            );
                          },
                          child: Stack(
                            children: <Widget>[
                              ..._editorController.assets.value.map(
                                (StoryElement e) {
                                  return StoryElementWidget(
                                    storyElement: e,
                                    screen: constraints.biggest,
                                    isEditing: true,
                                    editorController: _editorController,
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
                                        editorController: _editorController,
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
                                          _editorController.isShowFilters,
                                      builder: (BuildContext context,
                                          bool value, Widget? child) {
                                        return AnimatedSwitcher(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          child: !value
                                              ? const SizedBox()
                                              : FiltersSelector(
                                                  editorController:
                                                      _editorController,
                                                  onFilterSelected:
                                                      (ColorFilterGenerator
                                                          filter) {
                                                    _editorController
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
