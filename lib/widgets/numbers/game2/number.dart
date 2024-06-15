import 'package:flutter/material.dart';

class NumberBox extends StatelessWidget {
  final int number;
  final bool isDragging;
  final bool isDropped;

  NumberBox(
      {required this.number, this.isDragging = false, this.isDropped = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color:
            isDragging ? Colors.blue : (isDropped ? Colors.grey : Colors.white),
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          '$number',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
