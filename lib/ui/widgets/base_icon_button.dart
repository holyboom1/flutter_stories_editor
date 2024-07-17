import 'package:flutter/material.dart';

class BaseIconButton extends StatelessWidget {
  final Widget icon;
  final Function() onPressed;
  final bool isCircle;
  final bool withText;
  final Color backgroundColor;

  const BaseIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isCircle = true,
    this.withText = false,
    this.backgroundColor = const Color(0x99131313),
  });

  @override
  Widget build(BuildContext context) {
    if (!isCircle) {
      return GestureDetector(
        onTap: onPressed,
        child: Container(
          width: withText ? null : 38,
          height: 38,
          padding: const EdgeInsets.all(8),
          decoration: ShapeDecoration(
            color: const Color(0xFF212121),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Center(child: icon),
        ),
      );
    }
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: withText ? null : 38,
        height: 38,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(child: icon),
      ),
    );
  }
}
