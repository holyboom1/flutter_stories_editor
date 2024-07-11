import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';

import '../models/story_element.dart';

extension FileTypeExtension on String {
  bool isPicture() =>
      toLowerCase().endsWith('.svg') ||
      toLowerCase().endsWith('.png') ||
      toLowerCase().endsWith('.jpg') ||
      toLowerCase().endsWith('.jpeg') ||
      toLowerCase().endsWith('.gif') ||
      toLowerCase().endsWith('.webp');

  bool isVideo() =>
      toLowerCase().endsWith('.mp4') ||
      toLowerCase().endsWith('.mov') ||
      toLowerCase().endsWith('.avi') ||
      toLowerCase().endsWith('.flv') ||
      toLowerCase().endsWith('.wmv');

  bool isSvg() => endsWith('.svg');

  bool isNetworkImage() => startsWith('http');
}

extension AssetContains on List<Widget> {
  bool containsAsset(Widget asset) =>
      firstWhereOrNull(
          (Widget element) => element.hashCode == asset.hashCode) !=
      null;
}

extension ValueAssetsList on ValueNotifier<List<StoryElement>> {
  bool containsAsset(StoryElement asset) =>
      value
          .firstWhereOrNull((StoryElement element) => element.id == asset.id) !=
      null;

  void addAsset(StoryElement asset) {
    value = <StoryElement>[...value, asset];
  }

  void removeAsset(StoryElement asset) {
    value = <StoryElement>[...value]
      ..removeWhere((StoryElement element) => element.id == asset.id);
  }

  void changeZIndex({required StoryElement asset, int? newIndex}) {
    final int index =
        value.indexWhere((StoryElement element) => element.id == asset.id);
    final List<StoryElement> temp = value;
    temp.removeAt(index);
    temp.insert(newIndex ?? value.length, asset);
    value = <StoryElement>[...temp];
  }
}

extension ColorExtension on Color {
  Color get getTextColor {
    int d = 0;

    // Counting the perceptive luminance - human eye favors green ..
    final double luminance = (0.299 * red + 0.587 * green + 0.114 * blue) / 255;

    if (luminance > 0.5) {
      d = 0; // bright  - black font
    } else {
      d = 255; // dark  - white font
    }

    return Color.fromARGB(alpha, d, d, d);
  }

  Map<String, int> get getRGB {
    return <String, int>{
      'r': red,
      'g': green,
      'b': blue,
      'a': alpha,
    };
  }

  Color fromRGB(Map<String, int> rgb) {
    return Color.fromARGB(
      rgb['a'] ?? 0,
      rgb['r'] ?? 0,
      rgb['g'] ?? 0,
      rgb['b'] ?? 0,
    );
  }
}

extension TextStyleExtension on TextStyle {
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'color': color?.value,
      'fontSize': fontSize,
      'letterSpacing': letterSpacing,
      'fontWeight': fontWeight.toString(),
      'fontStyle': fontStyle.toString(),
    };
  }

  TextStyle fromJson(Map<String, dynamic> style) {
    return TextStyle(
      color: style['color'] != null
          ? const Color(0xFFFFFFFF).fromRGB(style['color'])
          : null,
      fontSize: style['fontSize'] ?? 16.0,
      letterSpacing: style['letterSpacing'] ?? 1.0,
      fontWeight: FontWeight.values[style['fontWeight']],
      fontStyle: FontStyle.values[style['fontStyle']],
    );
  }
}

extension TextAlignExtension on TextAlign {
  String toJson() {
    switch (this) {
      case TextAlign.left:
        return 'left';
      case TextAlign.right:
        return 'right';
      case TextAlign.center:
        return 'center';
      case TextAlign.justify:
        return 'justify';
      case TextAlign.start:
        return 'start';
      case TextAlign.end:
        return 'end';
    }
  }
}

extension OffsetExtension on Offset {
  Map<String, double> toJson() {
    return <String, double>{
      'dx': dx,
      'dy': dy,
    };
  }

  Offset fromJson(Map<String, double> offset) {
    return Offset(offset['dx'] ?? 0.0, offset['dy'] ?? 0.0);
  }
}
