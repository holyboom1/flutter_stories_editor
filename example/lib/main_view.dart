import 'package:flutter/material.dart';
import 'package:flutter_stories_editor/flutter_stories_view.dart';
import 'package:flutter_stories_editor/models/story_model.dart';

void main() {
  runApp(MyAppView(
    key: UniqueKey(),
  ));
}

final StoryModel story2 = StoryModel.fromJson({
  'id': '01J37EP2CE8FYXYATVPTXX394C',
  'elements': [
    {
      'layerIndex': 0,
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
  'colorFilter': 'None',
  'isVideoIncluded': false,
  'videoDuration': 0.0,
  'paletteColors': [4279902242, 4286348638],
});
final StoryModel story1 = StoryModel.fromJson({
  "id": "01J37XP08HYZZC79MZEQK16MXK",
  "author": {
    "id": "01J35P74NDEV7W63SC7M0ZCPQG",
    "pseudonym": "NastassiaFlutter",
    "bio": "Flutter is the best of the best. Backend hater.",
    "avatar":
        "https://storage.googleapis.com/jiggl-bucket/performer/image/01J35P74NDMHJ5M3EKFHV1B2K82024_07_19_14_26_58.jpeg",
    "ownerId": "01J35P4KMAPHR1Z6JGVCY0370T",
    "countStories": 1
  },
  "createdAt": "2024-07-20T11:15:54.769566Z",
  "updatedAt": null,
  "colorFilter": "None",
  "isVideoIncluded": false,
  "videoDuration": 0,
  "paletteColors": [4279902242, 4286348638],
  "isViewed": true,
  "isLiked": false,
  "countLikes": 0,
  "elements": []
});
bool isStory1 = true;
StoryModel story = story2;

class MyAppView extends StatefulWidget {
  const MyAppView({super.key});

  @override
  State<MyAppView> createState() => _MyAppViewState();
}

class _MyAppViewState extends State<MyAppView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: ListView(
            children: [
              TextButton(
                  onPressed: () {
                    isStory1 = !isStory1;
                    if (isStory1) {
                      story = story2;
                    } else {
                      story = story1;
                    }
                    setState(() {});
                  },
                  child: const Text('1')),
              FlutterStoriesViewer(
                  storyModel: story,
                  onVideoEvent: (bool isInited, Duration currnetPosition) {
                    print(
                        'isInited: $isInited, currnetPosition: $currnetPosition');
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
