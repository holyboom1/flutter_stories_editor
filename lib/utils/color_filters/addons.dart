import 'dart:math';

// | R' |   | a00 a01 a02 a03 a04 |   | R |
// | G' |   | a10 a11 a22 a33 a44 |   | G |
// | B' | = | a20 a21 a22 a33 a44 | * | B |
// | A' |   | a30 a31 a22 a33 a44 |   | A |
// | 1  |   |  0   0   0   0   1  |   | 1 |
class ColorFilterAddons {
  /// color(1 - scale) - color * scale
  static List<double> colorOverlay(double red, double green, double blue, double scale) {
    return [
      (1 - scale),
      0,
      0,
      0,
      -1 * red * scale,
      0,
      (1 - scale),
      0,
      0,
      -1 * green * scale,
      0,
      0,
      (1 - scale),
      0,
      -1 * blue * scale,
      0,
      0,
      0,
      1,
      0
    ];
  }

  static List<double> rgbScale(double r, double g, double b) {
    return [
      r,
      0,
      0,
      0,
      0,
      0,
      g,
      0,
      0,
      0,
      0,
      0,
      b,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
  }

  static List<double> addictiveColor(double r, double g, double b) {
    return [
      1,
      0,
      0,
      0,
      r,
      0,
      1,
      0,
      0,
      g,
      0,
      0,
      1,
      0,
      b,
      0,
      0,
      0,
      1,
      0,
    ];
  }

  /// (0.2126 * color.red + 0.7152 * color.green + 0.0722 * color.blue)
  static List<double> grayscale() {
    return [
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
  }

  static List<double> sepia(double value) {
    return [
      (1 - (0.607 * value)),
      0.769 * value,
      0.189 * value,
      0,
      0,
      0.349 * value,
      (1 - (0.314 * value)),
      0.168 * value,
      0,
      0,
      0.272 * value,
      0.534 * value,
      (1 - (0.869 * value)),
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
  }

  /// Invert the colors
  static List<double> invert() {
    return [
      -1,
      0,
      0,
      0,
      255,
      0,
      -1,
      0,
      0,
      255,
      0,
      0,
      -1,
      0,
      255,
      0,
      0,
      0,
      1,
      0,
    ];
  }

  /// Brightness adjustment
  static List<double> brightness(double value) {
    if (value <= 0) {
      value = value * 255;
    } else {
      value = value * 100;
    }

    if (value == 0) {
      return [
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ];
    }

    return List<double>.from(<double>[
      1,
      0,
      0,
      0,
      value,
      0,
      1,
      0,
      0,
      value,
      0,
      0,
      1,
      0,
      value,
      0,
      0,
      0,
      1,
      0
    ]).map((i) => i.toDouble()).toList();
  }

  /// Contrast adjustment
  static List<double> contrast(double value) {
    double adj = value * 255;
    double factor = (259 * (adj + 255)) / (255 * (259 - adj));

    return [
      factor,
      0,
      0,
      0,
      128 * (1 - factor),
      0,
      factor,
      0,
      0,
      128 * (1 - factor),
      0,
      0,
      factor,
      0,
      128 * (1 - factor),
      0,
      0,
      0,
      1,
      0,
    ];
  }

  /// Hue adjustment
  static List<double> hue(double value) {
    value = value * pi;

    if (value == 0) {
      return [
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ];
    }

    final double cosVal = cos(value);
    final double sinVal = sin(value);
    final double lumR = 0.213;
    final double lumG = 0.715;
    final double lumB = 0.072;

    return List<double>.from(<double>[
      (lumR + (cosVal * (1 - lumR))) + (sinVal * (-lumR)),
      (lumG + (cosVal * (-lumG))) + (sinVal * (-lumG)),
      (lumB + (cosVal * (-lumB))) + (sinVal * (1 - lumB)),
      0,
      0,
      (lumR + (cosVal * (-lumR))) + (sinVal * 0.143),
      (lumG + (cosVal * (1 - lumG))) + (sinVal * 0.14),
      (lumB + (cosVal * (-lumB))) + (sinVal * (-0.283)),
      0,
      0,
      (lumR + (cosVal * (-lumR))) + (sinVal * (-(1 - lumR))),
      (lumG + (cosVal * (-lumG))) + (sinVal * lumG),
      (lumB + (cosVal * (1 - lumB))) + (sinVal * lumB),
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]).map((i) => i.toDouble()).toList();
  }

  /// Saturation adjustment
  static List<double> saturation(double value) {
    value = value * 100;

    if (value == 0) {
      return [
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ];
    }

    final x = ((1 + ((value > 0) ? ((3 * value) / 100) : (value / 100)))).toDouble();
    final double lumR = 0.3086;
    final double lumG = 0.6094;
    final double lumB = 0.082;

    return List<double>.from(<double>[
      (lumR * (1 - x)) + x,
      lumG * (1 - x),
      lumB * (1 - x),
      0,
      0,
      lumR * (1 - x),
      (lumG * (1 - x)) + x,
      lumB * (1 - x),
      0,
      0,
      lumR * (1 - x),
      lumG * (1 - x),
      (lumB * (1 - x)) + x,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]).map((i) => i.toDouble()).toList();
  }
}
