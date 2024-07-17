import 'package:flutter/material.dart';

class Constants {
  static const String _iconPath = 'packages/flutter_stories_editor/assets/icons/';
  static const String _imagePath = 'packages/flutter_stories_editor/assets/image/';

  static const String iconPalet = '${_iconPath}palet.png';
  static const String imageFilter = '${_imagePath}filter_preview.jpg';

  static const String cropIcon = '${_iconPath}crop.svg';
  static const String filtersIcon = '${_iconPath}filters.svg';
  static const String imageIcon = '${_iconPath}image.svg';
  static const String musicIcon = '${_iconPath}music.svg';
  static const String muteIcon = '${_iconPath}mute.svg';
  static const String textIcon = '${_iconPath}text.svg';
  static const String backArrowIcon = '${_iconPath}back_arrow.svg';

  static const String alignCenterIcon = '${_iconPath}align_center.svg';
  static const String alignLeftIcon = '${_iconPath}align_left.svg';
  static const String alignRightIcon = '${_iconPath}align_right.svg';
  static const String textAaBlackIcon = '${_iconPath}TextAaBlack.svg';
  static const String textAaWhiteIcon = '${_iconPath}TextAaWhite.svg';

  static const List<({Color background, Color text})> textColors =
      <({Color background, Color text})>[
    (background: Color(0xFF808080), text: Color(0xFFFFFFFF)),
    (background: Color(0xFFA9A9A9), text: Color(0xFF000000)),
    (background: Color(0xFFC0C0C0), text: Color(0xFF000000)),
    (background: Color(0xFFD3D3D3), text: Color(0xFF000000)),
    (background: Color(0xFF2F4F4F), text: Color(0xFFFFFFFF)),
    (background: Color(0xFF696969), text: Color(0xFFFFFFFF)),
    (background: Color(0xFF000000), text: Color(0xFFFFFFFF)),
    (background: Color(0xFFFFFFFF), text: Color(0xFF000000)),
    (background: Colors.transparent, text: Color(0xFF000000)),
    (background: Color(0xFF000000), text: Colors.transparent),
    (background: Color(0xFFEE5548), text: Color(0xFFFBE9EA)),
    (background: Color(0xFF2E8B57), text: Color(0xFFE0F7FA)),
    (background: Color(0xFF1E90FF), text: Color(0xFFFFFFFF)),
    (background: Color(0xFF8A2BE2), text: Color(0xFFF5FFFA)),
    (background: Color(0xFFFFD700), text: Color(0xFF3E2723)),
    (background: Color(0xFF4CAF50), text: Color(0xFFF1F8E9)),
    (background: Color(0xFFFF4500), text: Color(0xFFFFF8E1)),
    (background: Color(0xFF6A5ACD), text: Color(0xFFF3E5F5)),
    (background: Color(0xFF00CED1), text: Color(0xFFE0F2F1)),
    (background: Color(0xFFFF1493), text: Color(0xFFFFE4E1)),
    (background: Color(0xFF00BFFF), text: Color(0xFFF0F8FF)),
    (background: Color(0xFFADFF2F), text: Color(0xFF1B5E20)),
    (background: Color(0xFFFF69B4), text: Color(0xFFFFEBEE)),
    (background: Color(0xFFCD5C5C), text: Color(0xFFFFF3E0)),
    (background: Color(0xFFDAA520), text: Color(0xFFF5F5DC)),
    (background: Color(0xFFB0C4DE), text: Color(0xFF00008B)),
    (background: Color(0xFF4682B4), text: Color(0xFFF0FFFF)),
    (background: Color(0xFF40E0D0), text: Color(0xFF004D40)),
    (background: Color(0xFF7B68EE), text: Color(0xFFFFF8E1)),
    (background: Color(0xFFFA8072), text: Color(0xFFFFF0F5)),
    (background: Color(0xFFF08080), text: Color(0xFF4A148C)),
    (background: Color(0xFF3CB371), text: Color(0xFFE0F7FA)),
    (background: Color(0xFF7FFFD4), text: Color(0xFF004D40)),
    (background: Color(0xFFFFA500), text: Color(0xFF3E2723)),
    (background: Color(0xFFFF6347), text: Color(0xFFFFF3E0)),
    (background: Color(0xFF4682B4), text: Color(0xFFFAFAFA)),
    (background: Color(0xFFBDB76B), text: Color(0xFF000000)),
    (background: Color(0xFF556B2F), text: Color(0xFFFAFAFA)),
    (background: Color(0xFF8FBC8F), text: Color(0xFF000000)),
  ];
}
