import 'dart:async';
import 'dart:io';

import 'package:advanced_media_picker/advanced_media_picker.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/color_filters/colorfilter_generator.dart';
import '../utils/color_filters/presets.dart';
import '../utils/compress_service.dart';
import '../utils/extensions.dart';
import '../utils/overlay_util.dart';
import '../utils/video_editor/lib/domain/entities/crop_style.dart';
import '../utils/video_editor/lib/domain/entities/trim_style.dart';
import '../utils/video_utils.dart';
import 'item_type_enum.dart';
import 'story_element.dart';
import 'story_model.dart';

enum CustomAssetType {
  image,
  video,
  audio,
}

/// Top bar widget controller if not provided by the user it will use the default one
final class EditorController {
  /// Picker Stule
  ///
  final bool isNeedToShowCameraPicker;
  final bool isNeedVideoCameraPicker;
  final PickerStyle? stylePicker;
  final CameraStyle? cameraStylePicker;
  final VoidCallback? onCameraPermissionDeniedCallback;

  ///

  /// Trim slider style
  final TrimSliderStyle trimSliderStyle;

  /// Crop grid style
  final CropGridStyle cropGridStyle;

  /// Assets list
  final ValueNotifier<List<StoryElement>> assets =
      ValueNotifier<List<StoryElement>>(<StoryElement>[]);

  /// Max audio duration allowed
  Duration maxAudioDuration;

  /// Min audio duration allowed
  Duration minAudioDuration;

  /// Selected item notifier
  final ValueNotifier<StoryElement?> selectedItem =
      ValueNotifier<StoryElement?>(null);

  /// Selected filter notifier
  final ValueNotifier<ColorFilterGenerator> selectedFilter =
      ValueNotifier<ColorFilterGenerator>(PresetFilters.none);

  /// Current story model
  final StoryModel _storyModel;

  /// Story model getter
  StoryModel get storyModel => _storyModel;

  /// Max video duration allowed
  final Duration maxVideoDuration;

  /// Min video duration allowed
  final Duration minVideoDuration;

  /// Element deleted callback.
  final Function(StoryElement)? onElementDeleted;

  /// Is showing overlay notifier
  final ValueNotifier<bool> isShowingOverlay = ValueNotifier<bool>(false);

  /// Constructor
  EditorController({
    String storyId = '',
    this.cropGridStyle = const CropGridStyle(),
    this.trimSliderStyle = const TrimSliderStyle(
      borderRadius: 12,
      onTrimmedColor: Color(0xFFEB671B),
      onTrimmingColor: Color(0xFFEB671B),
      lineColor: Color(0xFFEB671B),
    ),
    this.maxVideoDuration = const Duration(seconds: 30),
    this.minVideoDuration = const Duration(seconds: 5),
    this.onElementDeleted,
    this.maxAudioDuration = const Duration(seconds: 30),
    this.minAudioDuration = const Duration(seconds: 5),
    this.isNeedToShowCameraPicker = true,
    this.isNeedVideoCameraPicker = true,
    this.stylePicker,
    this.cameraStylePicker,
    this.onCameraPermissionDeniedCallback,
  }) : _storyModel = StoryModel(id: storyId);

  /// _isAvailableToAddVideo
  bool _isAvailableToAddVideo = true;

  /// isAvailableToAddVideo getter
  bool get isAvailableToAddVideo => _isAvailableToAddVideo;

  /// Open assets picker
  Future<void> addImage(BuildContext context) async {
    final PickerController pickerController = PickerController();
    _isAvailableToAddVideo = assets.value.isEmpty;
    final List<XFile> result = await AdvancedMediaPicker.openPicker(
      controller: pickerController,
      context: context,
      cameraStyle: cameraStylePicker ?? CameraStyle(),
      style: stylePicker ??
          PickerStyle(
            titleWidget: const SizedBox(),
            backgroundColor: Colors.black,
            borderRadius: BorderRadius.circular(16),
            typeSelectionWidget: const SizedBox.shrink(),
            selectIconBackgroundColor: Colors.transparent,
          ),
      isNeedToShowCamera: isNeedToShowCameraPicker,
      isNeedVideoCamera: isNeedVideoCameraPicker,
      allowedTypes: _isAvailableToAddVideo
          ? PickerAssetType.imageAndVideo
          : PickerAssetType.image,
      selectionLimit: 1,
      onCameraPermissionDeniedCallback: onCameraPermissionDeniedCallback,
    );
    if (result.isNotEmpty) {
      final XFile file = result.first;
      final CustomAssetType type =
          file.path.isVideo() ? CustomAssetType.video : CustomAssetType.image;
      addCustomAsset(file: file, type: type);
    }
  }

  /// Add text element to the editor
  void addText() {
    showTextOverlay(editorController: this);
  }

  /// Is audio playing notifier
  /// If you have audio in story you can control it
  final ValueNotifier<bool> audioIsPlaying = ValueNotifier<bool>(false);

  /// Complete editing and return the story model
  Future<StoryModel> complete() async {
    assets.value.forEach((StoryElement element) {
      element.layerIndex = assets.value.indexOf(element);
    });

    assets.value.forEach((StoryElement element) {
      element.videoController?.video.pause();
      element.audioController?.pause();
    });
    final StoryModel result;
    final bool isContainsVideo = assets.value
        .any((StoryElement element) => element.type == ItemType.video);
    storyModel.colorFilter = selectedFilter.value.name;
    if (isContainsVideo) {
      storyModel.isVideoIncluded = true;
    }
    final List<StoryElement> elements = <StoryElement>[...assets.value];

    final DateTime startTime = DateTime.now();
    print('#Comptression started# : ${startTime.toIso8601String()}');
    bool isAudioIncluded = false;
    bool isVideoIncluded = false;
    bool isImageIncluded = false;

    await Future.forEach(elements, (StoryElement element) async {
      final String filePath = '${element.elementFile?.path}';
      print('#element.elementFile?# : ${filePath}');
      print('#element.type?# : ${element.type}');
      final File file = File(filePath);

      if (await file.exists()) {
        final int sizeInBytes = await file.length();
        print('element.elementFile? : ${sizeInBytes / (1024 * 1024)} MB');
      } else {
        print('element.elementFile? : File does not exist');
      }

      if (element.type == ItemType.video) {
        isVideoIncluded = true;
        if (element.videoController != null) {
          storyModel.videoDuration = element
              .videoController!.trimmedDuration.inMilliseconds
              .toDouble();
          element.elementFile = await CompressService.trimVideoAndCompress(
              element.videoController!);
        }
      } else if (element.type == ItemType.image) {
        isImageIncluded = true;
        element.elementFile =
            await CompressService.compressImage(XFile(element.value));
      } else if (!storyModel.isVideoIncluded &&
          element.type == ItemType.audio) {
        isAudioIncluded = true;
        storyModel.videoDuration = element.elementDuration + 0.0;
      } else if (element.type == ItemType.audio) {
        isAudioIncluded = true;
      }
    });

    if (isAudioIncluded && isVideoIncluded) {
      final StoryElement? videoElement = elements.firstWhereOrNull(
        (StoryElement element) => element.type == ItemType.video,
      );
      final StoryElement? audioElement = elements.firstWhereOrNull(
        (StoryElement element) => element.type == ItemType.audio,
      );
      if (audioElement != null && videoElement != null) {
        final XFile videoWithNewAudio = await VideoUtils.addAudioToVideo(
          audioPath: audioElement.elementFile!.path,
          videoPath: videoElement.elementFile!.path,
        );
        videoElement.elementFile = videoWithNewAudio;
        videoElement.value = videoWithNewAudio.path;
        elements.removeWhere(
            (StoryElement element) => element.id == audioElement.id);
      }
    } else if (isAudioIncluded && isImageIncluded) {
      final StoryElement? audioElement = elements.firstWhereOrNull(
        (StoryElement element) => element.type == ItemType.audio,
      );
      final StoryElement? imageElement = elements.firstWhereOrNull(
        (StoryElement element) => element.type == ItemType.image,
      );
      if (audioElement != null && imageElement != null) {
        if (imageElement.elementFile!.path.isNetworkImage()) {
          final HttpClient httpClient = HttpClient();
          try {
            final Directory cacheDir = await getTemporaryDirectory();
            final File imageFile = File(
                '${cacheDir.path}/${DateTime.now().millisecondsSinceEpoch}.png');
            final HttpClientRequest request = await httpClient
                .getUrl(Uri.parse(imageElement.elementFile!.path));
            final HttpClientResponse response = await request.close();
            if (response.statusCode == 200) {
              final Uint8List bytes =
                  await consolidateHttpClientResponseBytes(response);
              await imageFile.writeAsBytes(bytes);
              imageElement.elementFile = XFile(imageFile.path);
            } else {}
          } catch (ex) {
            print(ex);
          } finally {
            httpClient.close();
          }
        }
        final XFile videoWithNewAudio = await VideoUtils.addAudioImage(
          audioPath: audioElement.elementFile!.path,
          imagePath: imageElement.elementFile!.path,
        );
        imageElement.elementFile = videoWithNewAudio;
        imageElement.type = ItemType.imageVideo;
        imageElement.value = videoWithNewAudio.path;
        elements.removeWhere(
            (StoryElement element) => element.id == audioElement.id);
        storyModel.isVideoIncluded = true;
      }
    }
    result = storyModel.copyWith(
      elements: elements,
    );
    result.isVideoIncluded = isVideoIncluded;
    assets.value.clear();
    selectedFilter.value = PresetFilters.none;
    selectedItem.value = null;

    if (result.paletteColors.length == 1) {
      result.paletteColors.add(result.paletteColors.first);
    }
    Future.delayed(const Duration(seconds: 5), () {
      assets.value.forEach((StoryElement element) {
        element.videoController?.dispose();
        element.videoControllerView?.dispose();
        element.audioController?.dispose();
      });
    });

    final DateTime endTime = DateTime.now();
    print('#Comptression end# : ${endTime.toIso8601String()}');
    print(
        '#Comptression Duration# : ${endTime.difference(startTime).inSeconds} seconds');

    debugPrint('storyModel :${result.toJson()}');
    return result;
  }

  /// Toggle filter selector
  void openFilter() {
    showFiltersOverlay(editorController: this);
  }

  /// Edit text element
  void editText(StoryElement storyElement) {
    assets.removeAsset(storyElement);
    showTextOverlay(
      storyElement: storyElement,
      editorController: this,
    );
  }

  /// Add Custom file widget asset
  Future<bool> addCustomAsset({
    XFile? file,
    String? url,
    required CustomAssetType type,
    String uniqueId = '',
    Widget Function(BuildContext context, Function() onPlay, Function() onPause,
            ValueNotifier<bool> isPlay)?
        customWidgetBuilder,
  }) async {
    final Completer<bool> completer = Completer<bool>();
    assert(file != null || url != null);
    switch (type) {
      case CustomAssetType.image:
        assets.addAsset(
          StoryElement(
            type: ItemType.image,
            position: const Offset(0.25, 0.25),
            value: file?.path ?? url ?? '',
            elementFile: file ?? XFile(url ?? ''),
            customWidgetUniqueID: uniqueId,
          ),
        );
        completer.complete(true);
        break;
      case CustomAssetType.video:
        if (file != null && _isAvailableToAddVideo) {
          unawaited(showVideoOverlay(
            videoFile: file,
            editorController: this,
            uniqueId: uniqueId,
            completer: completer,
          ));
        }
        break;
      case CustomAssetType.audio:
        unawaited(showAudioOverlay(
          audioFile: file,
          audioUrl: url,
          editorController: this,
          uniqueId: uniqueId,
          customWidgetBuilder: customWidgetBuilder,
          completer: completer,
        ));
        break;
    }
    return completer.future;
  }

  /// Add custom widget to assets
  void addCustomWidgetAsset(
    Widget widget, {
    String? customWidgetId,
    String customWidgetPayload = '',
    String customWidgetUniqueID = '',
  }) {
    assets.addAsset(
      StoryElement(
        type: ItemType.widget,
        position: const Offset(0.25, 0.25),
        child: widget,
        customWidgetId: customWidgetId ?? widget.hashCode.toString(),
        customWidgetPayload: customWidgetPayload,
        customWidgetUniqueID: customWidgetUniqueID,
      ),
    );
  }

  /// delete StoryElement from assets when it's out of the screen
  void checkDeleteElement(StoryElement storyElement, Size screen) {
    if (storyElement.type == ItemType.video) return;
    if (storyElement.position.dy * screen.height > screen.height - 90) {
      assets.removeAsset(storyElement);
      onElementDeleted?.call(storyElement);
    }
  }

  /// Remove element from assets
  void removeElement(StoryElement element) {
    element.audioController?.stop();
    element.videoController?.video.pause();
    element.audioController?.dispose();
    element.videoController?.dispose();
    element.videoControllerView?.pause();
    element.videoControllerView?.dispose();
    assets.removeAsset(element);
    onElementDeleted?.call(element);
  }

  /// Remove element from assets
  void removeElementByUniqueID(String uniqueID) {
    final StoryElement? element = assets.value.firstWhereOrNull(
      (StoryElement element) => element.customWidgetUniqueID == uniqueID,
    );
    element?.audioController?.stop();
    element?.videoController?.video.pause();
    element?.audioController?.dispose();
    element?.videoController?.dispose();
    element?.videoControllerView?.pause();
    element?.videoControllerView?.dispose();
    if (element != null) {
      assets.removeAsset(element);
      onElementDeleted?.call(element);
    }
  }

  /// Check if the assets contains video
  bool get isContainsVideo =>
      assets.value.firstWhereOrNull(
        (StoryElement element) => element.type == ItemType.video,
      ) !=
      null;

  /// Check if the assets contains audio
  bool get isContainsAudio =>
      assets.value.firstWhereOrNull(
        (StoryElement element) => element.type == ItemType.audio,
      ) !=
      null;

  /// Mute story video
  void muteVideo() {
    final StoryElement? videoElement = assets.value.firstWhereOrNull(
      (StoryElement element) => element.type == ItemType.video,
    );

    if (videoElement != null) {
      if (videoElement.videoController!.isVideoMuted) {
        videoElement.videoController!.unmuteVideo();
        videoElement.isVideoMuted = false;
      } else {
        videoElement.videoController!.muteVideo();
        videoElement.isVideoMuted = true;
      }
    }
  }

  /// Dispose the controller
  void dispose() {
    assets.value.forEach((StoryElement element) {
      element.videoController?.video.pause();
      element.videoController?.dispose();
      element.videoControllerView?.pause();
      element.videoControllerView?.dispose();
    });
    assets.dispose();
    selectedItem.dispose();
    selectedFilter.dispose();
    isShowingOverlay.dispose();
    audioIsPlaying.dispose();
  }
}
