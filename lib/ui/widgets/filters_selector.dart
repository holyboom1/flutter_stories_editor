import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../models/editor_controller.dart';
import '../../utils/color_filters/colorfilter_generator.dart';
import '../../utils/color_filters/presets.dart';
import 'image_widget.dart';

class FiltersSelector extends StatelessWidget {
  final EditorController editorController;
  final Function(ColorFilterGenerator) onFilterSelected;

  const FiltersSelector({
    super.key,
    required this.onFilterSelected,
    required this.editorController,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ColorFilterGenerator>(
      valueListenable: editorController.selectedFilter,
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
                      valueListenable: editorController.selectedFilter,
                      builder: (BuildContext context, ColorFilterGenerator value, Widget? child) {
                        return GestureDetector(
                          onTap: () {
                            onFilterSelected(filter);
                          },
                          child: Stack(
                            children: <Widget>[
                              ColorFiltered(
                                colorFilter: ColorFilter.matrix(filter.matrix),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
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
    );
  }
}
