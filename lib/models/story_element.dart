import 'package:advanced_media_picker/advanced_media_picker.dart';
import 'package:flutter/material.dart';

import '../utils/extensions.dart';
import '../utils/video_editor/lib/domain/bloc/controller.dart';
import 'item_type_enum.dart';

/// A class that represents a story element.
class StoryElement {
  /// The unique identifier of the element.
  final int id;

  /// Element key.
  final GlobalKey key = GlobalKey();

  /// Element type.
  final ItemType type;

  /// Element file.
  XFile? elementFile;

  /// Element value.
  String value = '';

  /// Element container color.
  Color containerColor;

  /// Element text style.
  TextStyle textStyle;

  /// Element text align.
  TextAlign textAlign;

  /// Element position.
  Offset position;

  /// Element size.
  double scale = 1.0;

  /// Element rotation.
  double rotation = 0.0;

  /// Element focus node.
  final FocusNode focusNode = FocusNode();

  /// Element child.
  Widget child;

  /// Custom widget id.
  String customWidgetId;

  /// Custom widget payload.
  String customWidgetPayload;

  /// Custom widget UniqueID.
  String customWidgetUniqueID;

  /// Video muted .
  bool isVideoMuted;

  /// Video controller.
  VideoEditorController? videoController;

  /// Hover delete indicator.
  ValueNotifier<bool> hoverDelete = ValueNotifier<bool>(false);

  /// Item size.
  ValueNotifier<Size> itemSize = ValueNotifier<Size>(Size.zero);

  /// Layer index.
  int layerIndex;

  /// Creates a new story element.
  StoryElement({
    int? id,
    this.layerIndex = 0,
    required this.type,
    this.value = '',
    this.containerColor = Colors.black,
    this.textStyle = const TextStyle(
        color: Colors.white,
        fontSize: 16,
        letterSpacing: 1.0,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal),
    this.position = const Offset(0.4, 0.4),
    this.scale = 1.0,
    this.rotation = 0.0,
    this.textAlign = TextAlign.center,
    this.child = const SizedBox(),
    this.customWidgetId = '',
    this.customWidgetPayload = '',
    this.customWidgetUniqueID = '',
    this.isVideoMuted = false,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'type': type.toString(),
      'value': value,
      'containerColor': containerColor.value,
      'textStyle': textStyle.toJson(),
      'textAlign': '${textAlign.index}',
      'position': position.toJson(),
      'scale': scale,
      'rotation': rotation,
      'customWidgetId': customWidgetId,
      'isVideoMuted': isVideoMuted,
      'layerIndex': layerIndex,
    };
  }

  factory StoryElement.fromJson(Map<String, dynamic> json) {
    return StoryElement(
      layerIndex: json['layerIndex'] as int,
      id: int.tryParse(json['id']) ?? DateTime.now().millisecondsSinceEpoch,
      type: ItemType.fromString(json['type']),
      value: json['value'] as String,
      containerColor: Color(json['containerColor']),
      textStyle: const TextStyle()..fromJson(json['textStyle'] as Map<String, dynamic>),
      textAlign: TextAlign.values[int.tryParse(json['textAlign']) ?? 0],
      position: Offset.zero.fromJson(json['position'] as Map<String, double>),
      scale: json['scale'] as double,
      rotation: json['rotation'] as double,
      customWidgetId: json['customWidgetId'] as String,
      isVideoMuted: json['isVideoMuted'] as bool,
    );
  }
}
