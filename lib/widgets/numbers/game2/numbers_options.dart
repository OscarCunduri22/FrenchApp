import 'package:flutter/material.dart';
import 'package:frenc_app/widgets/numbers/game2/number.dart';

class NumberOptionWidget extends StatelessWidget {
  final int number;

  NumberOptionWidget({required this.number});

  @override
  Widget build(BuildContext context) {
    return Draggable<int>(
      data: number,
      child: NumberBox(number: number),
      feedback: NumberBox(number: number, isDragging: true),
      childWhenDragging:
          NumberBox(number: number, isDragging: false, isDropped: true),
    );
  }
}
