import 'package:flutter/foundation.dart';

import '../utils/color_filters/colorfilter_generator.dart';
import '../utils/color_filters/presets.dart';
import 'story_element.dart';

class StoryModel extends ChangeNotifier {
  final String id;
  List<StoryElement> _elements = <StoryElement>[];
  ColorFilterGenerator _colorFiler = PresetFilters.none;

  StoryModel({
    this.id = '',
  });

  set elements(List<StoryElement> elements) {
    _elements = <StoryElement>[...elements];
    notifyListeners();
  }

  List<StoryElement> get elements => _elements;

  set colorFiler(ColorFilterGenerator colorFiler) {
    _colorFiler = colorFiler;
    notifyListeners();
  }

  ColorFilterGenerator get colorFiler => _colorFiler;

  StoryModel copyWith({
    String? id,
    List<StoryElement>? elements,
    ColorFilterGenerator? colorFiler,
  }) {
    return StoryModel(
      id: id ?? this.id,
    )
      ..elements = elements ?? _elements
      ..colorFiler = colorFiler ?? _colorFiler;
  }
}
