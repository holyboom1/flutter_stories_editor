import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

class FixedBarViewer extends StatelessWidget {
  final File audioFile;
  final int audioDuration;
  final double barHeight;
  final double barWeight;
  final BoxFit fit;

  final Color? barColor;
  final Color? backgroundColor;

  /// For showing the bars generated from the audio,
  /// like a frame by frame preview
  const FixedBarViewer(
      {Key? key,
      required this.audioFile,
      required this.audioDuration,
      required this.barHeight,
      required this.barWeight,
      required this.fit,
      this.backgroundColor,
      this.barColor})
      : super(key: key);

  Stream<List<int?>> generateBars() async* {
    final List<int> bars = <int>[];
    final Random r = Random();
    for (int i = 1; i <= barWeight / 5.0; i++) {
      final int number = 1 + r.nextInt(barHeight.toInt() - 1);
      bars.add(r.nextInt(number));
      yield bars;
    }
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;
    return StreamBuilder<List<int?>>(
      stream: generateBars(),
      builder: (BuildContext context, AsyncSnapshot<List<int?>> snapshot) {
        if (snapshot.hasData) {
          final List<int?> bars = snapshot.data!;
          return Container(
            color: backgroundColor ?? Colors.white,
            width: double.infinity,
            child: Row(
              children: bars.map((int? height) {
                i++;
                return Container(
                  height: height?.toDouble(),
                  decoration: BoxDecoration(
                    color: barColor ?? Colors.black,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  width: 5.0,
                );
              }).toList(),
            ),
          );
        } else {
          return Container(
            color: Colors.grey[900],
            height: barHeight,
            width: double.maxFinite,
          );
        }
      },
    );
  }
}
