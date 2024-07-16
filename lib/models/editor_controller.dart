import 'dart:async';

import 'package:advanced_media_picker/advanced_media_picker.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../utils/color_filters/colorfilter_generator.dart';
import '../utils/color_filters/presets.dart';
import '../utils/compress_service.dart';
import '../utils/extensions.dart';
import '../utils/overlay_util.dart';
import '../utils/video_editor/lib/domain/entities/crop_style.dart';
import '../utils/video_editor/lib/domain/entities/trim_style.dart';
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
  /// Trim slider style
  final TrimSliderStyle trimSliderStyle;

  /// Crop grid style
  final CropGridStyle cropGridStyle;

  /// Assets list
  final ValueNotifier<List<StoryElement>> assets =
      ValueNotifier<List<StoryElement>>(<StoryElement>[]);

  /// Selected item notifier
  final ValueNotifier<StoryElement?> selectedItem = ValueNotifier<StoryElement?>(null);

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
    this.minVideoDuration = const Duration(seconds: 1),
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
      style: PickerStyle(
        titleWidget: const SizedBox(),
        backgroundColor: Colors.black,
        borderRadius: BorderRadius.circular(16),
        typeSelectionWidget: const SizedBox.shrink(),
        selectIconBackgroundColor: Colors.transparent,
      ),
      allowedTypes: _isAvailableToAddVideo ? PickerAssetType.imageAndVideo : PickerAssetType.image,
      selectionLimit: 1,
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

  /// Complete editing and return the story model
  Future<StoryModel> complete() async {
    final StoryModel result;
    final bool isContainsVideo =
        assets.value.any((StoryElement element) => element.type == ItemType.video);
    final bool isContainsImage =
        assets.value.any((StoryElement element) => element.type == ItemType.image);

    if (isContainsVideo) {
      storyModel.isVideoIncluded = true;
    }
    if (isContainsImage) {}
    final List<StoryElement> elements = <StoryElement>[...assets.value];
    result = storyModel.copyWith(
      elements: elements,
    );

    await Future.forEach(elements, (StoryElement element) async {
      if (element.type == ItemType.video) {
        if (element.videoController != null) {
          element.elementFile =
              await CompressService.trimVideoAndCompress(element.videoController!);
        }
      } else if (element.type == ItemType.image) {
        element.elementFile = await CompressService.compressImage(XFile(element.value));
      }
    });

    assets.value.clear();
    selectedFilter.value = PresetFilters.none;
    selectedItem.value = null;
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
  void addCustomAsset({
    XFile? file,
    String? url,
    required CustomAssetType type,
  }) {
    assert(file != null || url != null);
    switch (type) {
      case CustomAssetType.image:
        assets.addAsset(
          StoryElement(
            type: ItemType.image,
            position: const Offset(0.25, 0.25),
            value: file?.path ?? url ?? '',
          ),
        );
        break;
      case CustomAssetType.video:
        if (file != null && _isAvailableToAddVideo) {
          showVideoOverlay(videoFile: file, editorController: this);
        }
        break;
      case CustomAssetType.audio:
        if (file != null) {
          showAudioOverlay(audioFile: file, editorController: this);
        }
        break;
    }
  }

  /// Add custom widget to assets
  void addCustomWidgetAsset(Widget widget, {String? customWidgetId}) {
    assets.addAsset(
      StoryElement(
        type: ItemType.widget,
        position: const Offset(0.25, 0.25),
        child: widget,
        customWidgetId: customWidgetId ?? widget.hashCode.toString(),
      ),
    );
  }

  /// delete StoryElement from assets when it's out of the screen
  void checkDeleteElement(StoryElement storyElement, Size screen) {
    if (storyElement.position.dy * screen.height > screen.height - 90) {
      assets.removeAsset(storyElement);
    }
  }

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
}
