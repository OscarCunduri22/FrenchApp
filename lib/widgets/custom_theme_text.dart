// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum TextType { Title, Subtitle }

enum ColorType { Primary, Secondary }

enum ShadowType { Light, Dark }

class CustomTextWidget extends StatelessWidget {
  final String text;
  final TextType type;
  final double fontSize;
  final FontWeight fontWeight;
  final double letterSpacing;
  final ColorType? color;
  final TextAlign? align;
  final bool shadow;
  final ShadowType shadowColor;
  final TextOverflow? overflow;

  const CustomTextWidget({
    Key? key,
    required this.text,
    required this.type,
    required this.fontSize,
    this.fontWeight = FontWeight.normal,
    this.letterSpacing = 0.0,
    this.color,
    this.align,
    this.shadow = true,
    this.shadowColor = ShadowType.Dark,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color getShadowColor(ShadowType shadowType) {
      return shadowType == ShadowType.Light ? Colors.white : Colors.black;
    }

    if (type == TextType.Title) {
      final splitIndex = (text.length / 2).ceil();
      final firstPart = text.substring(0, splitIndex);
      final secondPart = text.substring(splitIndex);

      return RichText(
        text: TextSpan(
          text: firstPart,
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: "TitanOneFont",
            fontWeight: fontWeight,
            color: const Color(0xFF016171),
            letterSpacing: letterSpacing,
            shadows: shadow
                ? [
                    Shadow(
                      blurRadius: 0.0,
                      color: getShadowColor(shadowColor),
                      offset: const Offset(4.0, 4.0),
                    ),
                  ]
                : null,
          ),
          children: <TextSpan>[
            TextSpan(
              text: secondPart,
              style: TextStyle(
                fontSize: fontSize,
                fontFamily: "TitanOneFont",
                fontWeight: fontWeight,
                color: const Color(0xFFF15E2F),
                shadows: shadow
                    ? [
                        Shadow(
                          blurRadius: 0.0,
                          color: getShadowColor(shadowColor),
                          offset: const Offset(4.0, 4.0),
                        ),
                      ]
                    : null,
              ),
            ),
          ],
        ),
      );
    } else if (type == TextType.Subtitle) {
      return Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: "TitanOneFont",
          fontWeight: fontWeight,
          color: color == ColorType.Primary
              ? const Color(0xFF016171)
              : const Color(0xFFF15E2F),
          letterSpacing: letterSpacing,
          shadows: shadow
              ? [
                  Shadow(
                    color: getShadowColor(shadowColor),
                    offset: const Offset(2.0, 2.0),
                  ),
                ]
              : null,
        ),
        textAlign: align,
        overflow: overflow,
      );
    } else {
      throw ArgumentError(
          "Invalid type: $type. Must be 'Title' or 'Subtitle'.");
    }
  }
}
