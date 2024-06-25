import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/extensions.dart';

enum ImageType {
  svg,
  other,
  network,
  none,
}

class AppImage extends StatelessWidget {
  final double? height;
  final double? width;
  final String image;
  final TextStyle? textStyle;
  final BorderRadius borderRadius;
  final BoxFit? fit;
  final Color? color;
  final ColorFilter? colorFilter;

  const AppImage({
    required this.image,
    this.textStyle,
    this.height,
    this.width,
    this.color,
    this.borderRadius = BorderRadius.zero,
    this.fit,
    this.colorFilter,
    Key? key,
  }) : super(key: key);

  ImageType _getImageType(String fileName) {
    if (fileName.isEmpty) {
      return ImageType.none;
    }
    if (fileName.isNetworkImage()) {
      return ImageType.network;
    }
    if (fileName.isSvg()) {
      return ImageType.svg;
    }
    return ImageType.other;
  }

  @override
  Widget build(BuildContext context) {
    switch (_getImageType(image)) {
      case ImageType.svg:
        return ClipRRect(
          borderRadius: borderRadius,
          child: SizedBox(
            height: height,
            width: width,
            child: SvgPicture.asset(
              image,
              fit: fit ?? BoxFit.contain,
              color: color,
              width: width,
              height: height,
              colorFilter: colorFilter,
            ),
          ),
        );
      case ImageType.other:
        return ClipRRect(
          borderRadius: borderRadius,
          child: SizedBox(
            height: height,
            width: width,
            child: Image.asset(
              image,
              width: width,
              height: height,
              fit: fit,
            ),
          ),
        );
      case ImageType.network:
        if (image.isSvg()) {
          return ClipRRect(
            borderRadius: borderRadius,
            child: SizedBox(
              height: height,
              width: width,
              child: SvgPicture.network(
                image,
                placeholderBuilder: (_) => Container(color: Colors.transparent),
                fit: fit ?? BoxFit.contain,
                width: width,
                height: height,
              ),
            ),
          );
        }
        return ClipRRect(
          borderRadius: borderRadius,
          child: CachedNetworkImage(
            fadeInDuration: const Duration(milliseconds: 300),
            imageUrl: image,
            placeholder: (_, __) => Container(color: Colors.transparent),
            errorWidget: (_, __, ___) => Container(color: Colors.transparent),
            fit: fit,
            width: width,
            height: height,
          ),
        );
      case ImageType.none:
        return SizedBox(
          height: height,
          width: width,
        );
    }
  }
}
