import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final ValueNotifier<double>? progress;
  const LoadingOverlay({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black45,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: progress != null
                ? ValueListenableBuilder<double>(
                    valueListenable: progress!,
                    builder:
                        (BuildContext context, double value, Widget? child) {
                      return Container(
                        width: 110,
                        height: 110,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(
                              value: value,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${(value * 100).toStringAsFixed(2)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
