import 'package:flutter/material.dart';
import 'package:flutter_stories_editor/flutter_stories_editor.dart';

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

  final EditorController editorController = EditorController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: IconButton(
          onPressed: () async {
            // final ByteData audio = await rootBundle.load('assets/test_mp3.mp3');
            // final Uint8List audioBytes = audio.buffer.asUint8List();
            // final XFile file = XFile.fromData(audioBytes,
            //     name: 'my_text.txt', mimeType: 'audio/mp3');
            // editorController.addCustomAsset(
            //     type: CustomAssetType.audio, file: file);
            //
            editorController.addCustomAsset(
                type: CustomAssetType.audio,
                url:
                    'https://storage.googleapis.com/jiggl-bucket/backend/files/2024/05/03/11173305733636.mp3');
          },
          icon: const Icon(Icons.audiotrack),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 16),
              if (storyModel == null)
                Expanded(
                  child: FlutterStoriesEditor(
                    controller: editorController,
                    backgroundColor: Colors.pink,
                    onDone: (Future<StoryModel> story) async {
                      storyModel = await story;
                      setState(() {});
                    },
                    onClose: (Future<StoryModel> story) {
                      print('Story editor closed');
                    },
                  ),
                )
              else
                Expanded(
                  child: FlutterStoriesViewer(
                    storyModel: storyModel!,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
