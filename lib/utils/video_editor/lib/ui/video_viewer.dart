import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../domain/bloc/controller.dart';

class VideoViewer extends StatefulWidget {
  const VideoViewer({super.key, required this.controller, this.child});

  final VideoEditorController controller;
  final Widget? child;

  @override
  State<VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.controller.video.setLooping(true);
    if (!widget.controller.isPlaying) {
      widget.controller.video.play();
    }
  }

  AppLifecycleState _appLifecycleState = AppLifecycleState.resumed;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appLifecycleState = state;
    if (state == AppLifecycleState.resumed) {
      widget.controller.video.play();
    } else {
      widget.controller.video.pause();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: <Widget>[
            if (widget.child == null)
              ClipRect(
                clipper: CustomVideoClipper(
                  top: widget.controller.minCrop.dy * constraints.maxHeight,
                  bottom: (1 - widget.controller.maxCrop.dy) * constraints.maxHeight,
                  left: widget.controller.minCrop.dx * constraints.maxWidth,
                  right: (1 - widget.controller.maxCrop.dx) * constraints.maxWidth,
                ),
                child: VideoPlayer(widget.controller.video),
              ),
            if (widget.child != null) ...<Widget>[
              AspectRatio(
                aspectRatio: widget.controller.video.value.aspectRatio,
                child: VideoPlayer(widget.controller.video),
              ),
              AspectRatio(
                aspectRatio: widget.controller.video.value.aspectRatio,
                child: widget.child,
              ),
            ]
          ],
        );
      },
    );
  }
}

class CustomVideoClipper extends CustomClipper<Rect> {
  final double top;
  final double bottom;
  final double left;
  final double right;

  CustomVideoClipper({
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
  });

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(
      left,
      top,
      size.width - right,
      size.height - bottom,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
