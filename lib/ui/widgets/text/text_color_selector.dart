import 'package:flutter/material.dart';
import 'package:flutter_stories_editor/constants.dart';

class TextColorSelector extends StatelessWidget {
  final Size screen;
  final Function({required Color background, required Color text}) changeContainerColor;

  const TextColorSelector({
    super.key,
    required this.screen,
    required this.changeContainerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SizedBox(
        width: screen.width,
        height: 60,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: Constants.textColors.length + 2,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(width: 0);
          },
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return const SizedBox(width: 8);
            }
            if (index == Constants.textColors.length + 1) {
              return const SizedBox(width: 8);
            }

            final Color backgroundColor = Constants.textColors[index - 1].background;
            final Color textColor = Constants.textColors[index - 1].text;

            return InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                changeContainerColor(
                  background: backgroundColor,
                  text: textColor,
                );
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
