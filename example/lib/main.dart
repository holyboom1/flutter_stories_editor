import 'package:flutter/material.dart';
import 'package:flutter_stories_editor/flutter_stories_editor.dart';
import 'package:flutter_stories_editor/models/story_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  StoryModel? storyModel;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 16),
              if (storyModel == null)
                Expanded(
                  child: FlutterStoriesEditor(
                    backgroundColor: Colors.pink,
                    onDone: (StoryModel story) {
                      storyModel = story;
                      setState(() {});
                    },
                    onClose: (StoryModel story) {
                      print('Story editor closed');
                    },
                  ),
                )
              else
                Expanded(
                  child: FlutterStoriesViewer(
                    storyModel: storyModel!,
                    backgroundColor: Colors.pink,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
