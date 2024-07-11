import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../models/editor_controller.dart';
import '../../../utils/color_filters/colorfilter_generator.dart';
import '../../../utils/color_filters/presets.dart';
import '../../../utils/overlay_util.dart';
import '../base_icon_button.dart';
import '../image_widget.dart';

class FiltersSelectorOverlay extends StatefulWidget {
  final EditorController editorController;
  final Size screen;

  const FiltersSelectorOverlay({
    super.key,
    required this.editorController,
    required this.screen,
  });

  @override
  State<FiltersSelectorOverlay> createState() => _FiltersSelectorOverlayState();
}

class _FiltersSelectorOverlayState extends State<FiltersSelectorOverlay> {
  late ColorFilterGenerator selectedFilter;

  @override
  void initState() {
    super.initState();
    selectedFilter = widget.editorController.selectedFilter.value;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: <Widget>[
              Positioned(
                top: 16,
                left: 16,
                child: BaseIconButton(
                  icon: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  withText: true,
                  onPressed: () {
                    hideOverlay();
                    widget.editorController.selectedFilter.value = selectedFilter;
                  },
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: BaseIconButton(
                  icon: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  withText: true,
                  onPressed: () {
                    hideOverlay();
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                width: widget.screen.width,
                child: ValueListenableBuilder<ColorFilterGenerator>(
                  valueListenable: widget.editorController.selectedFilter,
                  builder: (BuildContext context, ColorFilterGenerator value, Widget? child) {
                    return SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: presetFiltersList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final ColorFilterGenerator filter = presetFiltersList[index];
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: <Widget>[
                                ValueListenableBuilder<ColorFilterGenerator>(
                                  valueListenable: widget.editorController.selectedFilter,
                                  builder: (BuildContext context, ColorFilterGenerator value,
                                      Widget? child) {
                                    return GestureDetector(
                                      onTap: () {
                                        widget.editorController.selectedFilter.value = filter;
                                      },
                                      child: Stack(
                                        children: <Widget>[
                                          ColorFiltered(
                                            colorFilter: ColorFilter.matrix(filter.matrix),
                                            child: Container(
                                              width: 60,
                                              height: 60,
                                              clipBehavior: Clip.hardEdge,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: const AppImage(
                                                image: Constants.imageFilter,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          if (value == filter)
                                            Positioned(
                                              right: 0,
                                              bottom: 0,
                                              child: Container(
                                                padding: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: const Icon(
                                                  Icons.check,
                                                  color: Colors.black,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  filter.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
