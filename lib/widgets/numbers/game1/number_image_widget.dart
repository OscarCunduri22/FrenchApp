import 'package:flutter/material.dart';

class NumberImageWidget extends StatelessWidget {
  final String imagePath;

  const NumberImageWidget({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      width: 100,
      height: 100,
    );
  }
}
