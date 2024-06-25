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
}
