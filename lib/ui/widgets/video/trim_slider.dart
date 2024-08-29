import 'package:flutter/material.dart';

import '../../../utils/video_editor/lib/domain/bloc/controller.dart';
import '../../../utils/video_editor/lib/ui/trim/trim_slider.dart';

class TrimSliderWidget extends StatelessWidget {
  final VideoEditorController _controller;
  final double height;

  TrimSliderWidget({
    super.key,
    required VideoEditorController controller,
    required this.height,
  }) : _controller = controller;

  final ValueNotifier<Rect> _rectNotifier = ValueNotifier<Rect>(Rect.zero);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AnimatedBuilder(
          animation: Listenable.merge(<Listenable?>[
            _controller,
            _controller.video,
          ]),
          builder: (_, __) {
            final Duration pos = _controller.trimmedDuration;

            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 20,
              child: Stack(
                children: <Widget>[
                  ValueListenableBuilder<Rect>(
                    valueListenable: _rectNotifier,
                    child: Container(
                      width: 70,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Center(
                        child: Text(
                          formatter(pos),
                          style: const TextStyle(
                            color: Color(0xFFE75A22),
                            fontSize: 12,
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    builder: (BuildContext context, Rect value, Widget? child) {
                      final double leftPadding = value.left == 0
                          ? MediaQuery.of(context).size.width / 2
                          : value.left + (value.right - value.left) / 2;
                      return Positioned(
                        left: leftPadding - 35,
                        child: child!,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(vertical: height / 4),
          child: TrimSlider(
              controller: _controller,
              height: height,
              horizontalMargin: height / 4,
              onRectUpdate: (Rect rect) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _rectNotifier.value = rect;
                });
              }),
        )
      ],
    );
  }
}

String formatter(Duration duration) => <String>[
      duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
      duration.inSeconds.remainder(60).toString().padLeft(2, '0'),
      duration.inMilliseconds.remainder(1000).toString().padLeft(2, '0'),
    ].join(':');
