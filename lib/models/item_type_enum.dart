enum ItemType {
  text,
  image,
  video,
  imageVideo,
  audio,
  widget,
  none;

  static ItemType fromString(String type) {
    switch (type) {
      case 'text':
        return ItemType.text;
      case 'image':
        return ItemType.image;
      case 'imageVideo':
        return ItemType.imageVideo;
      case 'video':
        return ItemType.video;
      case 'audio':
        return ItemType.audio;
      case 'widget':
        return ItemType.widget;
      default:
        return ItemType.none;
    }
  }

  @override
  String toString() {
    switch (this) {
      case ItemType.text:
        return 'text';
      case ItemType.image:
        return 'image';
      case ItemType.imageVideo:
        return 'imageVideo';
      case ItemType.video:
        return 'video';
      case ItemType.audio:
        return 'audio';
      case ItemType.widget:
        return 'widget';
      default:
        return 'none';
    }
  }
}
