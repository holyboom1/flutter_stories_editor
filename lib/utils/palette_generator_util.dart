import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class PaletteGeneratorUtil {
  static Future<PaletteGenerator> getGeneratorFromData(Uint8List data) async {
    final ImageStream stream = Image.memory(data).image.resolve(
          const ImageConfiguration(devicePixelRatio: 1.0),
        );
    final Completer<ui.Image> imageCompleter = Completer<ui.Image>();
    late ImageStreamListener listener;
    listener = ImageStreamListener((ImageInfo info, bool synchronousCall) {
      stream.removeListener(listener);
      imageCompleter.complete(info.image);
    });

    stream.addListener(listener);
    final ui.Image image = await imageCompleter.future;

    final ByteData? imageData = await image.toByteData();
    if (imageData == null) {
      throw StateError('Failed to encode the image.');
    }

    return compute<GeneratorData, PaletteGenerator>(
      getGeneratorIsolate,
      GeneratorData(
        encodedImage: EncodedImage(
          imageData,
          width: image.width,
          height: image.height,
        ),
        colorsCount: 2,
      ),
    );
  }

  static Future<PaletteGenerator> getGeneratorFromPath(String path) async {
    late final ImageStream stream;
    if (path.contains('http')) {
      stream = NetworkImage(path).resolve(
        const ImageConfiguration(devicePixelRatio: 1.0),
      );
    } else {
      stream = Image.file(File(path)).image.resolve(
            const ImageConfiguration(devicePixelRatio: 1.0),
          );
    }
    final Completer<ui.Image> imageCompleter = Completer<ui.Image>();
    late ImageStreamListener listener;
    listener = ImageStreamListener((ImageInfo info, bool synchronousCall) {
      stream.removeListener(listener);
      imageCompleter.complete(info.image);
    });

    stream.addListener(listener);
    final ui.Image image = await imageCompleter.future;

    final ByteData? imageData = await image.toByteData();
    if (imageData == null) {
      throw StateError('Failed to encode the image.');
    }

    return compute<GeneratorData, PaletteGenerator>(
      getGeneratorIsolate,
      GeneratorData(
        encodedImage: EncodedImage(
          imageData,
          width: image.width,
          height: image.height,
        ),
        colorsCount: 2,
      ),
    );
  }
}

class GeneratorData {
  final EncodedImage encodedImage;
  final int colorsCount;

  GeneratorData({
    required this.encodedImage,
    required this.colorsCount,
  });
}

Future<PaletteGenerator> getGeneratorIsolate(GeneratorData data) async {
  return PaletteGenerator.fromByteData(
    data.encodedImage,
    maximumColorCount: data.colorsCount,
  );
}
