import 'package:flutter/material.dart';

import '../../../utils/video_editor/lib/domain/bloc/controller.dart';
import '../../../utils/video_editor/lib/ui/trim/trim_slider.dart';
import '../../../utils/video_editor/lib/ui/trim/trim_timeline.dart';

class TrimSliderWidget extends StatelessWidget {
  final VideoEditorController _controller;
  final double height;

  const TrimSliderWidget({
    super.key,
    required VideoEditorController controller,
    required this.height,
  }) : _controller = controller;

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
            final int duration = _controller.videoDuration.inSeconds;
            final double pos = _controller.trimPosition * duration;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: height / 4),
              child: Row(children: <Widget>[
                if (pos.isFinite)
                  Text(formatter(Duration(seconds: pos.toInt()))),
                const Expanded(child: SizedBox()),
                if (_controller.isTrimming)
                  Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    Text(formatter(_controller.startTrim)),
                    const SizedBox(width: 10),
                    Text(formatter(_controller.endTrim)),
                  ]),
              ]),
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
            child: TrimTimeline(
              controller: _controller,
              padding: const EdgeInsets.only(top: 10),
            ),
          ),
        )
      ],
    );
  }
}

String formatter(Duration duration) => <String>[
      duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
      duration.inSeconds.remainder(60).toString().padLeft(2, '0')
    ].join(':');
