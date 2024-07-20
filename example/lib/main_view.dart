import 'package:flutter/material.dart';
import 'package:flutter_stories_editor/flutter_stories_view.dart';
import 'package:flutter_stories_editor/models/story_model.dart';

void main() {
  runApp(MyAppView(
    key: UniqueKey(),
  ));
}

final StoryModel story = StoryModel.fromJson({
  'id': '01J37EP2CE8FYXYATVPTXX394C',
  'elements': [
    {
      'id': '1721458883568767',
      'type': 'video',
      'value':
          'https://storage.googleapis.com/jiggl-bucket/01J37EP410PM7M6NYRR225KJX62024_07_20_06_53_49.mp4',
      'containerColor': 4294967295,
      'textStyle': {
        'color': 4294967295,
        'fontSize': null,
        'letterSpacing': null,
        'fontWeight': 3,
        'fontStyle': 0
      },
      'textAlign': 2,
      'position': {'dx': 0.0, 'dy': 0.38417849946776156},
      'scale': 1.0,
      'rotation': 0.0,
      'customWidgetId': '',
      'isVideoMuted': false
    }
  ],
  'colorFiler': 'None',
  'isVideoIncluded': false,
  'videoDuration': 0.0,
  'paletteColors': [4279902242, 4286348638],
});

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: FlutterStoriesViewer(
            storyModel: story,
          ),
        ),
      ),
    );
  }
}
