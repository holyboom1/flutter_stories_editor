import 'package:flutter/material.dart';

class BaseIconButton extends StatelessWidget {
  final Widget icon;
  final Function() onPressed;

  const BaseIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(child: icon),
      ),
    );
  }
}
