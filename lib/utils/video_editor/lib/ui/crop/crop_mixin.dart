import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../domain/bloc/controller.dart';
import '../../domain/entities/transform_data.dart';
import '../../domain/helpers.dart';
import '../../ui/crop/crop_grid.dart';
import '../../ui/crop/crop_grid_painter.dart';
import '../../ui/image_viewer.dart';
import '../../ui/transform.dart';
import '../../ui/video_viewer.dart';

mixin CropPreviewMixin<T extends StatefulWidget> on State<T> {
  final ValueNotifier<Rect> rect = ValueNotifier<Rect>(Rect.zero);
  final ValueNotifier<TransformData> transform =
      ValueNotifier<TransformData>(const TransformData());

  Size viewerSize = Size.zero;
  Size layout = Size.zero;

  @override
  void dispose() {
    transform.dispose();
    rect.dispose();
    super.dispose();
  }

  /// Returns the size of the max crop dimension based on available space and
  /// original video aspect ratio
  Size computeLayout(
    VideoEditorController controller, {
    EdgeInsets margin = EdgeInsets.zero,
    bool shouldFlipped = false,
  }) {
    if (viewerSize == Size.zero) return Size.zero;
    final double videoRatio = controller.video.value.aspectRatio;
    final Size size = Size(viewerSize.width - margin.horizontal,
        viewerSize.height - margin.vertical);
    if (shouldFlipped) {
      return computeSizeWithRatio(videoRatio > 1 ? size.flipped : size,
              getOppositeRatio(videoRatio))
          .flipped;
    }
    return computeSizeWithRatio(size, videoRatio);
  }

  void updateRectFromBuild();

  Widget buildView(BuildContext context, TransformData transform);

  /// Returns the [VideoViewer] tranformed with editing view
  /// Paint rect on top of the video area outside of the crop rect
  Widget buildVideoView(
    VideoEditorController controller,
    TransformData transform,
    CropBoundaries boundary, {
    bool showGrid = false,
  }) {
    return Center(
      child: SizedBox.fromSize(
        size: layout,
        child: CropTransformWithAnimation(
          shouldAnimate: layout != Size.zero,
          transform: transform,
          child: VideoViewer(
            controller: controller,
            child: showGrid
                ? buildPaint(
                    controller,
                    boundary: boundary,
                    showGrid: showGrid,
                    showCenterRects:
                        controller.preferredCropAspectRatio == null,
                  )
                : null,
          ),
        ),
      ),
    );
  }

  /// Returns the [ImageViewer] tranformed with editing view
  /// Paint rect on top of the video area outside of the crop rect
  Widget buildImageView(
    VideoEditorController controller,
    Uint8List bytes,
    TransformData transform,
  ) {
    return SizedBox.fromSize(
      size: layout,
      child: CropTransformWithAnimation(
        shouldAnimate: layout != Size.zero,
        transform: transform,
        child: ImageViewer(
          controller: controller,
          bytes: bytes,
          child: buildPaint(controller),
        ),
      ),
    );
  }

  Widget buildPaint(
    VideoEditorController controller, {
    CropBoundaries? boundary,
    bool showGrid = false,
    bool showCenterRects = false,
  }) {
    return ValueListenableBuilder(
      valueListenable: rect,

      /// Build a [Widget] that hides the cropped area and show the crop grid if widget.showGris is true
      builder: (_, Rect value, __) => RepaintBoundary(
        child: CustomPaint(
          size: Size.infinite,
          painter: CropGridPainter(
            value,
            style: controller.cropStyle,
            boundary: boundary,
            showGrid: showGrid,
            showCenterRects: showCenterRects,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, BoxConstraints constraints) {
      final Size size = constraints.biggest;
      if (size != viewerSize) {
        viewerSize = constraints.biggest;
        updateRectFromBuild();
      }

      return ValueListenableBuilder(
        valueListenable: transform,
        builder: (_, TransformData transform, __) =>
            buildView(context, transform),
      );
    });
  }
}
