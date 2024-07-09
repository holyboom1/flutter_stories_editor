import 'package:flutter/material.dart';

import '../utils/color_filters/presets.dart';
import 'story_element.dart';

final class StoryModel {
  /// Unique identifier for the story
  final String id;

  List<StoryElement> _elements = <StoryElement>[];
  String _colorFiler = PresetFilters.none.name;

  /// Is video included in the story
  bool _isVideoIncluded;

  /// Video progress position
  ValueNotifier<double> videoProgressPosition = ValueNotifier<double>(0);

  /// Video duration
  double _videoDuration;

  /// Constructor
  StoryModel({
    this.id = '',
    bool isVideoIncluded = false,
    double videoDuration = 0,
  })  : _videoDuration = videoDuration,
        _isVideoIncluded = isVideoIncluded;

  /// Set video duration
  set videoDuration(double value) {
    _videoDuration = value;
  }

  /// Get video duration
  double get videoDuration => _videoDuration;

  /// Set video included
  set isVideoIncluded(bool value) {
    _isVideoIncluded = value;
  }

  /// Get video included
  bool get isVideoIncluded => _isVideoIncluded;

  /// Set story elements
  set elements(List<StoryElement> elements) {
    _elements = <StoryElement>[...elements];
  }

  /// Get story elements
  List<StoryElement> get elements => _elements;

  /// Set color filter
  set colorFilter(String colorFiler) {
    _colorFiler = colorFiler;
  }

  /// Get color filter name
  String get colorFilter => _colorFiler;

  /// Palette color
  List<Color> _paletteColors = <Color>[
    Colors.black,
    Colors.black,
  ];

  /// Get palette color
  List<Color> get paletteColors => _paletteColors;

  /// Set palette color
  set paletteColors(List<Color> value) {
    _paletteColors = <Color>[...value];
  }

  StoryModel copyWith({
    String? id,
    List<StoryElement>? elements,
    String? colorFiler,
    List<Color>? paletteColors,
  }) {
    return StoryModel(
      id: id ?? this.id,
    )
      ..elements = elements ?? _elements
      ..colorFilter = colorFiler ?? _colorFiler
      ..paletteColors = paletteColors ?? _paletteColors;
  }

  /// Convert to json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'elements': _elements.map((StoryElement e) => e.toJson()).toList(),
      'colorFiler': _colorFiler,
      'isVideoIncluded': isVideoIncluded,
      'videoDuration': _videoDuration,
      'paletteColors': _paletteColors.map((Color e) => e.value).toList(),
    };
  }

  /// Create story model from json
  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] as String,
      isVideoIncluded: json['isVideoIncluded'] as bool,
      videoDuration: json['videoDuration'] as double,
    )
      ..elements = (json['elements'] as List<dynamic>)
          .map((dynamic e) => StoryElement.fromJson(e as Map<String, dynamic>))
          .toList()
      ..colorFilter = json['colorFiler'] as String
      ..paletteColors =
          (json['paletteColors'] as List<dynamic>).map((dynamic e) => Color(e as int)).toList();
  }
}
