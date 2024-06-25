
<p align="center">
  <a href="https://flutter.dev">
    <img src="https://img.shields.io/badge/Platform-Flutter-02569B?logo=flutter"
      alt="Platform" />
  </a>
  <a href="https://pub.dartlang.org/packages/flutter_stories_editor">
    <img src="https://img.shields.io/pub/v/flutter_stories_editor.svg"
      alt="Pub Package" />
  </a>
  <a href="https://github.com/holyboom1/flutter_stories_editor/issues">
    <img src="https://img.shields.io/github/workflow/status/holyboom1/flutter_stories_editor/CI?logo=github"
      alt="Build Status" />
  </a>
  <br>
  <a href="https://codecov.io/gh/holyboom1/flutter_stories_editor">
    <img src="https://codecov.io/gh/holyboom1/flutter_stories_editor/branch/master/graph/badge.svg"
      alt="Codecov Coverage" />
  </a>
  <a href="https://opensource.org/licenses/MIT">
    <img src="https://img.shields.io/github/license/holyboom1/flutter_stories_editor?color=red"
      alt="License: MIT" />
  </a>

</p>

# Stories Editor / Viewer

#### _Stories Editor / Viewer Package for Flutter_

## Getting Started

This plugin displays a gallery with user's Albums and Photos with ability to take photo and video.

## Prepare for use

### Configure native platforms

Minimum platform versions:
**Android 16, iOS 9.0, macOS 10.15**.

- Android: [Android config preparation](#android-config-preparation).
- iOS: [iOS config preparation](#ios-config-preparation).
- macOS: Pretty much the same with iOS.

#### iOS config preparation

Define the `NSPhotoLibraryUsageDescription` , `NSCameraUsageDescription`
and `NSMicrophoneUsageDescription`
key-value in the `ios/Runner/Info.plist`:

```plist
<key>NSPhotoLibraryUsageDescription</key>
<string>In order to access your photo library</string>
<key>NSCameraUsageDescription</key>
<string>your usage description here</string>
<key>NSMicrophoneUsageDescription</key>
<string>your usage description here</string>
```

## Usage

1. Add the plugin to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_stories_editor: ^0.0.1
```

2. Import the plugin in your Dart code:

```dart
import 'package:flutter_stories_editor/flutter_stories_editor.dart';
```

3. Use the plugin in your Dart code:

```dart
 final EditorController editorController = EditorController();
... 
FlutterStoriesEditor(
backgroundColor: Colors.pink,
controller: editorController,
topBar: const Text('Top bar'),
onDone: (StoryModel story) {},
onClose: (StoryModel story) {},
);
```

### EditorController methods

```dart
/// Open assets picker
Future<void> addImage(BuildContext context);
/// Add text element to the editor
void addText();
/// Complete editing and return the story model
StoryModel complete({String? id});
/// Toggle filter selector
void toggleFilter();
/// Edit text element
void editText(StoryElement storyElement);
/// Add Custom file widget asset
void addCustomAsset({
  XFile? file,
  String? url,
  required CustomAssetType type,
});
/// Add custom widget to assets
void addCustomWidgetAsset(Widget widget);
```

### To Show stories use FlutterStoriesViewer widget

```dart
FlutterStoriesViewer(
                    storyModel: storyModel,
                    backgroundColor:  Colors.pink,
                  )
```

## Screenshots / Demo
### Editor
![editor_1.png](doc%2Feditor_1.png)
![editor_2.png](doc%2Feditor_2.png)
![editor_3.png](doc%2Feditor_3.png)
![editor_4.png](doc%2Feditor_4.png)
### Viewer
![viewer_1.png](doc%2Fviewer_1.png)

###### [![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/C0C8Z5SA5)


