import 'package:flutter/material.dart';
import 'package:flutter_stories_editor/flutter_stories_view.dart';
import 'package:flutter_stories_editor/models/story_model.dart';

void main() {
  runApp(MyAppView(
    key: UniqueKey(),
  ));
}

final StoryModel story2 = StoryModel.fromJson({
  "id": "01J3MMFRJ1TX6RFQ6S5E62Y21H",
  "author": {
    "id": "01J3CP3APSF8TMCREP3PDRB7T7",
    "pseudonym": "Cat",
    "bio": null,
    "avatar":
        "https://storage.googleapis.com/jiggl-bucket/performer/image/01J3CP3APS11P5V2KTMCWT6VRT2024_07_22_07_39_35.png",
    "ownerId": "01J3CNY2TF67ZT24QGS0A89TSK",
    "countStories": 7,
    "hasFollowed": null,
    "hasFollowing": null
  },
  "createdAt": "2024-07-25T09:45:20.705356Z",
  "updatedAt": null,
  "colorFilter": "None",
  "isVideoIncluded": true,
  "videoDuration": 30000,
  "paletteColors": [4278190080, 4278190080],
  "isViewed": true,
  "isLiked": false,
  "countLikes": 0,
  "elements": [
    {
      "id": "01J3MMFT3BGJM37V1Z3YRD8BY6",
      "layerIndex": 0,
      "storyId": "01J3MMFRJ1TX6RFQ6S5E62Y21H",
      "createdAt": "2024-07-25T09:45:22.283192Z",
      "updatedAt": null,
      "type": "imageVideo",
      "value":
          "https://storage.googleapis.com/jiggl-bucket/01J3MMFSXKVWQ5YB13T5K5541M2024_07_25_09_45_22.mp4",
      "containerColor": 4278190080,
      "textStyle": {
        "color": 4294967295,
        "fontSize": 16.0,
        "fontStyle": 0,
        "fontFamily": "",
        "fontWeight": 3,
        "letterSpacing": 1.0
      },
      "textAlign": 2,
      "position": {"dx": 0.25, "dy": 0.24144079885877318},
      "scale": 1.0,
      "rotation": 0.0,
      "customWidgetId": "",
      "customWidgetPayload": ""
    },
    {
      "id": "01J3MMFT3B9HBM3TMNFT0ZW7H9",
      "layerIndex": 2,
      "storyId": "01J3MMFRJ1TX6RFQ6S5E62Y21H",
      "createdAt": "2024-07-25T09:45:22.283198Z",
      "updatedAt": null,
      "type": "widget",
      "value": "",
      "containerColor": 4278190080,
      "textStyle": {
        "color": 4294967295,
        "fontSize": 16.0,
        "fontStyle": 0,
        "fontFamily": "",
        "fontWeight": 3,
        "letterSpacing": 1.0
      },
      "textAlign": 2,
      "position": {"dx": 0.20080574171537055, "dy": 0.5809557774607703},
      "scale": 1.0,
      "rotation": 0.0,
      "customWidgetId": "track",
      "customWidgetPayload":
          "{\"id\":\"01J3KNPEY8EHMWAF37YDHD8Z0J\",\"name\":\"Lost in the echo\",\"file\":\"https://storage.googleapis.com/jiggl-bucket/backend/files/2024/07/25/00471407377294.mp3\",\"cover\":\"https://storage.googleapis.com/jiggl-bucket/backend/files/2024/07/25/00471507629292.jpeg\",\"author\":{\"id\":\"01J3KN0JMH78XN0GRBV6M4EQYB\",\"pseudonym\":\"Duke\",\"avatar\":\"https://storage.googleapis.com/jiggl-bucket/performer/image/01J3KN0JMHEBT0V7XG27N8YTHD2024_07_25_00_35_17.png\",\"bio\":\"Name: Duke Cassidy\\r\\nAge: 25 years\\r\\nOrigin: Seattle, Washington, USA\\r\\n\\r\\nBiography: Singer and musician who grew up in the family of a famous rock musician and an opera singer. Surrounded from childhood by the world of music and glamor, he absorbed his father's rebellious spirit and his mother's kindness, which shaped his strong character and confidence. He travels extensively, plays guitar and keyboards, performs and continues to inspire millions with his music and life story. Duke is currently actively invo\"}}"
    }
  ]
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
