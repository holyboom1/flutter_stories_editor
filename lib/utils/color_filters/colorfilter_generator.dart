import 'package:flutter/material.dart';
import 'package:matrix2d/matrix2d.dart';

class ColorFilterGenerator {
  String name;
  List<List<double>> filters;
  List<double> matrix = <double>[
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
    0
  ];

  ColorFilterGenerator({
    required this.name,
    required this.filters,
  }) {
    buildMatrix();
  }

  // | a00 a01 a02 a03 a04 |   | a00 a01 a02 a03 a04 |
  // | a10 a11 a22 a33 a44 |   | a10 a11 a22 a33 a44 |
  // | a20 a21 a22 a33 a44 | * | a20 a21 a22 a33 a44 |
  // | a30 a31 a22 a33 a44 |   | a30 a31 a22 a33 a44 |
  // |  0   0   0   0   1  |   |  0   0   0   0   1  |
  /// Build matrix of current filter
  void buildMatrix() {
    if (filters.isEmpty) {
      return;
    }

    const Matrix2d m2d = Matrix2d();

    List result = m2d.reshape(<dynamic>[filters[0]], 4, 5);

    for (int i = 1; i < filters.length; i++) {
      final List listB = <dynamic>[
        ...(filters[i] is ColorFilterGenerator
            ? (filters[i] as ColorFilterGenerator).matrix
            : filters[i]),
        0,
        0,
        0,
        0,
        1,
      ];

      result = m2d.dot(
        result,
        m2d.reshape(<dynamic>[listB], 5, 5),
      );
    }

    matrix = List<double>.from(result.flatten.sublist(0, 20));
  }

  /// Create new filter from this filter with given opacity
  ColorFilterGenerator opacity(double value) {
    return ColorFilterGenerator(
      name: name,
      filters: <List<double>>[
        ...filters,
        <double>[
          value,
          0,
          0,
          0,
          0,
          0,
          value,
          0,
          0,
          0,
          0,
          0,
          value,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ],
      ],
    );
  }

  /// Apply filter to given child
  Widget build(Widget child) {
    Widget tree = child;

    for (final List<double> filter in filters) {
      tree = ColorFiltered(
        colorFilter: ColorFilter.matrix(filter),
        child: tree,
      );
    }

    return tree;
  }
}
