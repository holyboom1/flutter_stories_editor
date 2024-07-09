import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import 'video_editor/lib/domain/bloc/controller.dart';
import 'video_utils.dart';

/// Compress service
class CompressService {
  /// Get cache directory path
  static Future<String> getCacheDirectory() async {
    final Directory cacheDir = await getTemporaryDirectory();
    return cacheDir.path;
  }

  /// Compress image
  static Future<XFile?> compressImage(XFile file) async {
    final Uint8List? result = await FlutterImageCompress.compressWithFile(
      file.path,
      quality: 70,
      format: CompressFormat.png,
      minHeight: 1080,
      minWidth: 1080,
    );
    if (result == null) {
      return null;
    }
    final String cacheDir = await getCacheDirectory();
    final XFile compressedFile =
        XFile.fromData(result, path: '$cacheDir/${DateTime.now().millisecondsSinceEpoch}.png');
    await compressedFile.saveTo(compressedFile.path);
    return compressedFile;
  }

  /// Compress video
  static Future<XFile?> compressVideo(XFile file) async {
    final VideoEditorController controller = VideoEditorController.file(file);
    await controller.initialize();
    final ValueNotifier<double> exportingProgress = ValueNotifier<double>(0.0);
    XFile? video;
    try {
      video = await VideoUtils.exportVideo(
        onStatistics: (FFmpegStatistics stats) {
          exportingProgress.value = stats.getProgress(controller.trimmedDuration.inMilliseconds);
        },
        controller: controller,
      );
    } catch (e) {
      log(e.toString());
    }
    await video
        ?.saveTo('${await getCacheDirectory()}/${DateTime.now().millisecondsSinceEpoch}.mp4');
    return video;
  }

  /// Trim video and compress video
  static Future<XFile?> trimVideoAndCompress(VideoEditorController controller) async {
    final ValueNotifier<double> exportingProgress = ValueNotifier<double>(0.0);
    XFile? video;
    try {
      video = await VideoUtils.exportVideo(
        onStatistics: (FFmpegStatistics stats) {
          exportingProgress.value = stats.getProgress(controller.trimmedDuration.inMilliseconds);
        },
        controller: controller,
      );
    } catch (e) {
      log(e.toString());
    }
    await video
        ?.saveTo('${await getCacheDirectory()}/${DateTime.now().millisecondsSinceEpoch}.mp4');
    return video;
  }
}
