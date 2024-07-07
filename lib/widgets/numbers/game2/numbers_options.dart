// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:frenc_app/widgets/numbers/game2/number.dart';

class NumberOptionWidget extends StatelessWidget {
  final int number;

  NumberOptionWidget({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return Draggable<int>(
      data: number,
      feedback: NumberBox(number: number, isDragging: true),
      childWhenDragging:
          NumberBox(number: number, isDragging: false, isDropped: true),
      child: NumberBox(number: number),
    );
  }
}
