import 'package:flutter/foundation.dart';

import '../utils/color_filters/presets.dart';
import 'story_element.dart';

final class StoryModel {
  /// Unique identifier for the story
  final String id;

  List<StoryElement> _elements = <StoryElement>[];
  List<double> _colorFiler = PresetFilters.none.matrix;

  /// Is video included in the story
  bool _isVideoIncluded;

  /// Video progress position
  ValueNotifier<double> videoProgressPosition = ValueNotifier<double>(0);

  /// Video duration
  double _videoDuration;

  StoryModel({
    this.id = '',
    bool isVideoIncluded = false,
    double videoDuration = 0,
  })  : _videoDuration = videoDuration,
        _isVideoIncluded = isVideoIncluded;

  set videoDuration(double value) {
    _videoDuration = value;
  }

  double get videoDuration => _videoDuration;

  set isVideoIncluded(bool value) {
    _isVideoIncluded = value;
  }

  bool get isVideoIncluded => _isVideoIncluded;

  set elements(List<StoryElement> elements) {
    _elements = <StoryElement>[...elements];
  }

  List<StoryElement> get elements => _elements;

  set colorFiler(List<double> colorFiler) {
    _colorFiler = colorFiler;
  }

  List<double> get colorFiler => _colorFiler;

  StoryModel copyWith({
    String? id,
    List<StoryElement>? elements,
    List<double>? colorFiler,
  }) {
    return StoryModel(
      id: id ?? this.id,
    )
      ..elements = elements ?? _elements
      ..colorFiler = colorFiler ?? _colorFiler;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'elements': _elements.map((StoryElement e) => e.toJson()).toList(),
      'colorFiler': _colorFiler,
      'isVideoIncluded': isVideoIncluded,
      'videoDuration': _videoDuration,
    };
  }

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] as String,
      isVideoIncluded: json['isVideoIncluded'] as bool,
      videoDuration: json['videoDuration'] as double,
    )
      ..elements = (json['elements'] as List<dynamic>)
          .map((e) => StoryElement.fromJson(e as Map<String, dynamic>))
          .toList()
      ..colorFiler = (json['colorFiler'] as List<dynamic>).cast<double>();
  }
}
