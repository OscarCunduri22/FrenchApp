// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class NumberBox extends StatelessWidget {
  final int? number;
  final bool isDragging;
  final bool isDropped;

  NumberBox({
    this.number,
    this.isDragging = false,
    this.isDropped = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 80,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/numbers/game2/label.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.bottomCenter,
      child: number != null
          ? Text(
              '$number',
              style: const TextStyle(
                  fontSize: 30,
                  color: Color(0xFF815E3F),
                  fontFamily: 'FuzzyBubblesFont',
                  fontWeight: FontWeight.bold),
            )
          : Container(),
    );
  }
}
