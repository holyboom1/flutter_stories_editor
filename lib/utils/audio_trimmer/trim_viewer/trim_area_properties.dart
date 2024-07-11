import 'package:flutter/material.dart';

class TrimAreaProperties {
  /// By default it is set to `BoxFit.fitHeight`.
  final BoxFit barFit;

  /// For adding a blur to the trim area edges. Use `blurColor`
  /// for specifying the color of the blur (usually it's the
  /// background color which helps in blending).
  ///
  /// By default it is set to `false`.
  final bool blurEdges;

  /// For specifying the color of the blur. Use the color of the
  /// background to blend with it.
  ///
  /// By default it is set to `Colors.black`.
  final Color blurColor;

  /// For specifying the widget to be placed at the start
  /// of the trimmer area. You can pass `null` for hiding
  /// the widget.
  ///
  /// By default it is set as:
  ///
  /// ```dart
  /// Icon(
  ///   Icons.arrow_back_ios_new_rounded,
  ///   color: Colors.white,
  ///   size: 16,
  /// )
  /// ```
  final Widget? startIcon;

  /// For specifying the widget to be placed at the end
  /// of the trimmer area. You can pass `null` for hiding
  /// the widget.
  ///
  /// By default it is set as:
  ///
  /// ```dart
  /// Icon(
  ///   Icons.arrow_forward_ios_rounded,
  ///   color: Colors.white,
  ///   size: 16,
  /// )
  /// ```
  final Widget? endIcon;

  /// For specifying the size of the circular border radius
  /// to be applied to each corner of the trimmer area Container.
  ///
  /// By default it is set to `4.0`.
  final double borderRadius;

  /// Helps defining the Trim Area properties.
  ///
  /// A better look at the structure of the **Trim Viewer**:
  ///
  /// All the parameters are optional:
  ///
  /// * [blurEdges] for adding a blur to the trim area edges. Use `blurColor`
  /// for specifying the color of the blur (usually it's the background color
  /// which helps in blending). By default it is set to `false`.
  ///
  ///
  /// * [blurColor] for specifying the color of the blur. Use the color of the
  /// background to blend with it. By default it is set to `Colors.black`.
  ///
  ///
  /// * [startIcon] for specifying the widget to be placed at the start
  /// of the trimmer area. You can pass `null` for hiding
  /// the widget.
  ///
  ///
  /// * [endIcon] for specifying the widget to be placed at the end
  /// of the trimmer area. You can pass `null` for hiding
  /// the widget.
  ///
  ///
  /// * [borderRadius] for specifying the size of the circular border radius
  /// to be applied to each corner of the trimmer area Container.
  /// By default it is set to `4.0`.
  ///
  const TrimAreaProperties({
    this.barFit = BoxFit.fitHeight,
    this.blurEdges = false,
    this.blurColor = Colors.black,
    this.startIcon,
    this.endIcon,
    this.borderRadius = 4.0,
  });

  /// Helps defining the Fixed Trim Area properties.
  ///
  /// A better look at the structure of the **Trim Viewer**:
  ///
  /// All the parameters are optional:
  ///
  /// By default it is set to `BoxFit.fitHeight`.
  ///
  ///
  /// * [borderRadius] for specifying the size of the circular border radius
  /// to be applied to each corner of the trimmer area Container.
  /// By default it is set to `4.0`.
  ///
  factory TrimAreaProperties.fixed({
    BoxFit barFit,
    double borderRadius,
  }) = FixedTrimAreaProperties;

  /// Helps defining the Trim Area properties with blur & arrows on the edges.
  ///
  /// A better look at the structure of the **Trim Viewer**:
  ///
  ///
  factory TrimAreaProperties.edgeBlur({
    BoxFit barFit,
    bool blurEdges,
    Color blurColor,
    Widget? startIcon,
    Widget? endIcon,
    double borderRadius,
  }) = _TrimAreaPropertiesWithBlur;
}

class FixedTrimAreaProperties extends TrimAreaProperties {
  /// Helps defining the Fixed Trim Area properties.
  ///
  /// A better look at the structure of the **Trim Viewer**:
  ///
  ///
  /// All the parameters are optional:
  ///
  /// By default it is set to `BoxFit.fitHeight`.
  ///
  ///
  /// * [borderRadius] for specifying the size of the circular border radius
  /// to be applied to each corner of the trimmer area Container.
  /// By default it is set to `4.0`.
  ///
  const FixedTrimAreaProperties({
    super.barFit,
    super.borderRadius,
  });
}

class _TrimAreaPropertiesWithBlur extends TrimAreaProperties {
  _TrimAreaPropertiesWithBlur({
    super.barFit = BoxFit.fitHeight,
    super.blurColor = Colors.black,
    super.borderRadius = 4.0,
    super.startIcon = const Icon(
      Icons.arrow_back_ios_new_rounded,
      color: Colors.white,
      size: 16,
    ),
    super.endIcon = const Icon(
      Icons.arrow_forward_ios_rounded,
      color: Colors.white,
      size: 16,
    ),
    super.blurEdges = true,
  });
}
