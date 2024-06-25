part of '../flutter_stories_editor.dart';

enum CustomAssetType {
  image,
  video,
  audio,
  customWidget,
}

/// Top bar widget controller if not provided by the user it will use the default one
final class EditorController {
  final ValueNotifier<List<StoryElement>> _assets =
      ValueNotifier<List<StoryElement>>(<StoryElement>[]);
  final ValueNotifier<StoryElement?> _selectedItem =
      ValueNotifier<StoryElement?>(null);
  final ValueNotifier<ColorFilterGenerator> _selectedFilter =
      ValueNotifier<ColorFilterGenerator>(PresetFilters.none);
  final ValueNotifier<bool> _isShowFilters = ValueNotifier<bool>(false);

  /// Open assets picker
  Future<void> addImage(BuildContext context) async {
    final PickerController pickerController = PickerController();
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
      allowedTypes: PickerAssetType.imageAndVideo,
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
    showTextOverlay();
  }

  /// Complete editing and return the story model
  StoryModel complete({
    String? id,
  }) {
    final StoryModel result = StoryModel(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
    ).copyWith(
      elements: <StoryElement>[..._assets.value],
      colorFiler: _selectedFilter.value,
    );

    _assets.value.clear();
    _selectedFilter.value = PresetFilters.none;
    _selectedItem.value = null;
    _isShowFilters.value = false;
    return result;
  }

  /// Toggle filter selector
  void toggleFilter() {
    _isShowFilters.value = !_isShowFilters.value;
  }

  /// Edit text element
  void editText(StoryElement storyElement) {
    _assets.removeAsset(storyElement);
    showTextOverlay(storyElement: storyElement);
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
        _assets.addAsset(
          StoryElement(
            type: ItemType.image,
            position: Offset(0.25, 0.25),
            value: file?.path ?? url ?? '',
          ),
        );
        break;
      case CustomAssetType.video:
        _assets.addAsset(
          StoryElement(
            position: Offset(0.25, 0.25),
            type: ItemType.video,
            value: file?.path ?? url ?? '',
          ),
        );
        break;
      case CustomAssetType.audio:
        break;
      case CustomAssetType.customWidget:
        break;
    }
  }

  /// Add custom widget to assets
  void addCustomWidgetAsset(Widget widget) {
    _assets.addAsset(
      StoryElement(
        type: ItemType.widget,
        position: Offset(0.25, 0.25),
        child: widget,
      ),
    );
  }
}
