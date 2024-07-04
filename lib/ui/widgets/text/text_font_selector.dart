import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFontSelector extends StatefulWidget {
  final Size screen;
  final Function({required TextStyle textStyle}) changeContainerFont;

  const TextFontSelector({
    super.key,
    required this.screen,
    required this.changeContainerFont,
  });

  @override
  State<TextFontSelector> createState() => _TextFontSelectorState();
}

class _TextFontSelectorState extends State<TextFontSelector> {
  Map<String, Function> fonts = GoogleFonts.asMap();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SizedBox(
        width: widget.screen.width,
        height: 60,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: fonts.length + 2,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(width: 0);
          },
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return const SizedBox(width: 8);
            }
            if (index == fonts.length + 1) {
              return const SizedBox(width: 8);
            }

            final TextStyle font =
                fonts[fonts.keys.elementAt(index - 1)]!.call();

            return InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                widget.changeContainerFont(
                  textStyle: font,
                );
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                height: 35,
                width: 35,
                decoration: const BoxDecoration(
                  color: Colors.black38,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    'Aa',
                    textAlign: TextAlign.center,
                    style: font.copyWith(
                      fontSize: 14,
                      color: Colors.white,
                    ),
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
