import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import 'extensions.dart';
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
  static Future<XFile?> compressImage(
    XFile file, {
    int minWidth = 1080,
    int quality = 70,
  }) async {
    XFile fileLocal = file;
    if (file.path.isNetworkImage()) {
      final HttpClient httpClient = HttpClient();
      try {
        final File imageFile = File(
            '${await getCacheDirectory()}/${DateTime.now().millisecondsSinceEpoch}.png');
        final HttpClientRequest request =
            await httpClient.getUrl(Uri.parse(file.path));
        final HttpClientResponse response = await request.close();
        if (response.statusCode == 200) {
          final Uint8List bytes =
              await consolidateHttpClientResponseBytes(response);
          await imageFile.writeAsBytes(bytes);
          fileLocal = XFile(imageFile.path);
        } else {}
      } catch (ex) {
        print(ex);
      } finally {
        httpClient.close();
      }
    }
    final Uint8List? result = await FlutterImageCompress.compressWithFile(
      fileLocal.path,
      quality: quality,
      format: CompressFormat.png,
      minWidth: minWidth,
    );
    if (result == null) {
      return null;
    }
    final String cacheDir = await getCacheDirectory();
    final XFile compressedFile = XFile.fromData(result,
        path: '$cacheDir/${DateTime.now().millisecondsSinceEpoch}.png');
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
          exportingProgress.value =
              stats.getProgress(controller.trimmedDuration.inMilliseconds);
        },
        preset: VideoExportPreset.ultrafast,
        customInstruction:
            '-c:v h264_videotoolbox -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" -crf 32 -r 30 -hls_list_size 5 -hls_time 5 -threads 10 ',
        controller: controller,
      );
    } catch (e) {
      log(e.toString());
    }
    await video?.saveTo(
        '${await getCacheDirectory()}/${DateTime.now().millisecondsSinceEpoch}.mp4');
    return video;
  }

  /// Trim video and compress video
  static Future<XFile?> trimVideoAndCompress(
      VideoEditorController controller) async {
    final ValueNotifier<double> exportingProgress = ValueNotifier<double>(0.0);
    XFile? video;
    try {
      video = await VideoUtils.exportVideo(
        onStatistics: (FFmpegStatistics stats) {
          print(
              '#FFmpegStatistics# : ${stats.getProgress(controller.trimmedDuration.inMilliseconds)}');
          exportingProgress.value =
              stats.getProgress(controller.trimmedDuration.inMilliseconds);
        },
        // 'vf': f'scale={scale}',
        // 'c:v': 'libx264',
        // 'preset': 'veryfast',
        // 'loglevel': 'error',
        // "crf": 32,
        // "r": 30,
        // 'c:a': 'aac',
        // "threads": 1,
        // "hls_list_size": 5, "hls_time": 5,
        /// -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2"
        /// -vf scale=1280:-2
        preset: VideoExportPreset.ultrafast,
        controller: controller,
        customInstruction:
            '-c:v h264_videotoolbox -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" -crf 32 -r 30 -hls_list_size 5 -hls_time 5 -threads 10 ',
      );
    } catch (e) {
      log(e.toString());
    }
    final String date = DateTime.now().millisecondsSinceEpoch.toString();

    await video?.saveTo('${await getCacheDirectory()}/$date.mp4');
    print('#savedTo# : ${await getCacheDirectory()}/$date.mp4');
    final XFile file = XFile('${await getCacheDirectory()}/$date.mp4');
    print('#Print# : ${await file.length()}');
    return video;
  }

  /// Add audio to video
  static Future<Duration> getAudioDuration(String path) async {
    XFile fileLocal = XFile(path);
    if (path.isNetworkImage()) {
      final HttpClient httpClient = HttpClient();
      try {
        final File audioPath = File(
            '${await getCacheDirectory()}/${DateTime.now().millisecondsSinceEpoch}.mp3');
        final HttpClientRequest request =
            await httpClient.getUrl(Uri.parse(path));
        final HttpClientResponse response = await request.close();
        if (response.statusCode == 200) {
          final Uint8List bytes =
              await consolidateHttpClientResponseBytes(response);
          await audioPath.writeAsBytes(bytes);
          fileLocal = XFile(audioPath.path);
        } else {}
      } catch (ex) {
        print(ex);
      } finally {
        httpClient.close();
      }
    }

    final Completer<Duration> completer = Completer<Duration>();
    unawaited(
      FFmpegKit.executeAsync(
        '-i ${fileLocal.path} -hide_banner',
        (FFmpegSession session) async {
          final String? output = await session.getOutput();
          if (output != null) {
            final RegExp durationRegExp =
                RegExp(r'Duration: (\d{2}):(\d{2}):(\d{2})\.(\d{2})');
            final RegExpMatch? match = durationRegExp.firstMatch(output);
            if (match != null) {
              final int hours = int.parse(match.group(1)!);
              final int minutes = int.parse(match.group(2)!);
              final int seconds = int.parse(match.group(3)!);
              final int milliseconds = int.parse(match.group(4)!) * 10;
              completer.complete(Duration(
                hours: hours,
                minutes: minutes,
                seconds: seconds,
                milliseconds: milliseconds,
              ));
            } else {
              completer.complete(Duration.zero);
            }
          }
        },
      ),
    );
    return completer.future;
  }
}
