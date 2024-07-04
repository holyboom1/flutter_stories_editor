import 'dart:async';

import 'package:cross_file/cross_file.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/return_code.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/statistics.dart';
import 'package:ffmpeg_wasm/ffmpeg_wasm.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'video_editor/lib/domain/bloc/controller.dart';
import 'video_editor/lib/domain/entities/ffmpeg_config.dart';
import 'video_editor/lib/domain/entities/file_format.dart';

class VideoUtils {
  static Future<String> ioOutputPath(String filePath, FileFormat format) async {
    final String tempPath = (await getTemporaryDirectory()).path;
    final String name = path.basenameWithoutExtension(filePath);
    final int epoch = DateTime.now().millisecondsSinceEpoch;
    return '$tempPath/${name}_$epoch.${format.extension}';
  }

  static String _webPath(String prePath, FileFormat format) {
    final int epoch = DateTime.now().millisecondsSinceEpoch;
    return '${prePath}_$epoch.${format.extension}';
  }

  static String webInputPath(FileFormat format) => _webPath('input', format);

  static String webOutputPath(FileFormat format) => _webPath('output', format);

  static Future<XFile> exportVideo({
    void Function(FFmpegStatistics)? onStatistics,
    VideoExportFormat outputFormat = VideoExportFormat.mp4,
    double scale = 1.0,
    String customInstruction = '',
    VideoExportPreset preset = VideoExportPreset.none,
    bool isFiltersEnabled = true,
    required VideoEditorController controller,
  }) async {
    final String inputPath = kIsWeb
        ? webInputPath(FileFormat.fromMimeType(controller.file.mimeType))
        : controller.file.path;
    final String outputPath = kIsWeb
        ? webOutputPath(outputFormat)
        : await ioOutputPath(inputPath, outputFormat);

    final VideoFFmpegConfig config = controller.createVideoFFmpegConfig();
    final String execute = config.createExportCommand(
      inputPath: inputPath,
      outputPath: outputPath,
      outputFormat: outputFormat,
      scale: scale,
      customInstruction:
          customInstruction + (controller.isVideoMuted ? ' -an' : ''),
      preset: preset,
      isFiltersEnabled: isFiltersEnabled,
    );

    debugPrint('run export video command : [$execute]');

    if (kIsWeb) {
      return const FFmpegExport().executeFFmpegWeb(
        execute: execute,
        inputData: await controller.file.readAsBytes(),
        inputPath: inputPath,
        outputPath: outputPath,
        outputMimeType: outputFormat.mimeType,
        onStatistics: onStatistics,
      );
    } else {
      return const FFmpegExport().executeFFmpegIO(
        execute: execute,
        outputPath: outputPath,
        outputMimeType: outputFormat.mimeType,
        onStatistics: onStatistics,
      );
    }
  }
}

class FFmpegExport {
  const FFmpegExport();

  Future<XFile> executeFFmpegIO({
    required String execute,
    required String outputPath,
    String? outputMimeType,
    void Function(FFmpegStatistics)? onStatistics,
  }) {
    final Completer<XFile> completer = Completer<XFile>();

    FFmpegKit.executeAsync(
      execute,
      (FFmpegSession session) async {
        final ReturnCode? code = await session.getReturnCode();

        if (ReturnCode.isSuccess(code)) {
          completer.complete(XFile(outputPath, mimeType: outputMimeType));
        } else {
          final String state = FFmpegKitConfig.sessionStateToString(
            await session.getState(),
          );
          completer.completeError(
            Exception(
              'FFmpeg process exited with state $state and return code $code.'
              '${await session.getOutput()}',
            ),
          );
        }
      },
      null,
      onStatistics != null
          ? (Statistics s) => onStatistics(FFmpegStatistics.fromIOStatistics(s))
          : null,
    );

    return completer.future;
  }

  Future<XFile> executeFFmpegWeb({
    required String execute,
    required Uint8List inputData,
    required String inputPath,
    required String outputPath,
    String? outputMimeType,
    void Function(FFmpegStatistics)? onStatistics,
  }) async {
    FFmpeg? ffmpeg;
    final List<String> logs = <String>[];
    try {
      ffmpeg = createFFmpeg(CreateFFmpegParam(log: false));
      ffmpeg.setLogger((LoggerParam logger) {
        logs.add('[${logger.type}] ${logger.message}');

        if (onStatistics != null && logger.type == 'fferr') {
          final FFmpegStatistics? statistics =
              FFmpegStatistics.fromMessage(logger.message);
          if (statistics != null) {
            onStatistics(statistics);
          }
        }
      });

      await ffmpeg.load();

      ffmpeg.writeFile(inputPath, inputData);
      await ffmpeg.runCommand(execute);

      final Uint8List data = ffmpeg.readFile(outputPath);
      return XFile.fromData(data, mimeType: outputMimeType);
    } catch (e, s) {
      Error.throwWithStackTrace(
        Exception('Exception:\n$e\n\nLogs:${logs.join('\n')}}'),
        s,
      );
    } finally {
      ffmpeg?.exit();
    }
  }
}

/// Common class for ffmpeg_kit and ffmpeg_wasm statistics.
class FFmpegStatistics {
  final int videoFrameNumber;
  final double videoFps;
  final double videoQuality;
  final int size;
  final int time;
  final double bitrate;
  final double speed;

  static final RegExp statisticsRegex = RegExp(
    r'frame\s*=\s*(\d+)\s+fps\s*=\s*(\d+(?:\.\d+)?)\s+q\s*=\s*([\d.-]+)\s+L?size\s*=\s*(\d+)\w*\s+time\s*=\s*([\d:.]+)\s+bitrate\s*=\s*([\d.]+)\s*(\w+)/s\s+speed\s*=\s*([\d.]+)x',
  );

  const FFmpegStatistics({
    required this.videoFrameNumber,
    required this.videoFps,
    required this.videoQuality,
    required this.size,
    required this.time,
    required this.bitrate,
    required this.speed,
  });

  FFmpegStatistics.fromIOStatistics(Statistics s)
      : this(
          videoFrameNumber: s.getVideoFrameNumber(),
          videoFps: s.getVideoFps(),
          videoQuality: s.getVideoQuality(),
          size: s.getSize(),
          time: s.getTime().toInt(),
          bitrate: s.getBitrate(),
          speed: s.getSpeed(),
        );

  static FFmpegStatistics? fromMessage(String message) {
    final RegExpMatch? match = statisticsRegex.firstMatch(message);
    if (match != null) {
      return FFmpegStatistics(
        videoFrameNumber: int.parse(match.group(1)!),
        videoFps: double.parse(match.group(2)!),
        videoQuality: double.parse(match.group(3)!),
        size: int.parse(match.group(4)!),
        time: _timeToMs(match.group(5)!),
        bitrate: double.parse(match.group(6)!),
        // final bitrateUnit = match.group(7);
        speed: double.parse(match.group(8)!),
      );
    }

    return null;
  }

  double getProgress(int videoDurationMs) {
    return videoDurationMs <= 0.0
        ? 0.0
        : (time / videoDurationMs).clamp(0.0, 1.0);
  }

  static int _timeToMs(String timeString) {
    final List<String> parts = timeString.split(':');
    final int hours = int.parse(parts[0]);
    final int minutes = int.parse(parts[1]);
    final List<String> secondsParts = parts[2].split('.');
    final int seconds = int.parse(secondsParts[0]);
    final int milliseconds = int.parse(secondsParts[1]);
    return (hours * 60 * 60 + minutes * 60 + seconds) * 1000 + milliseconds;
  }
}
