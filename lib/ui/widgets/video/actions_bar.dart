import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../base_icon_button.dart';
import '../image_widget.dart';

class VideoActionsBar extends StatelessWidget {
  final Function() onCropClick;
  const VideoActionsBar({
    super.key,
    required this.onCropClick,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: 0,
      height: MediaQuery.of(context).size.height * 0.3,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BaseIconButton(
              icon: const AppImage(image: Constants.cropIcon),
              isCircle: false,
              onPressed: onCropClick,
            ),
          ],
        ),
      ),
    );
  }
}
