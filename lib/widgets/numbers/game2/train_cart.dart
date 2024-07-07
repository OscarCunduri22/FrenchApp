// ignore_for_file: deprecated_member_use, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:frenc_app/view_model/numbers/game2/game_provider.dart';
import 'package:frenc_app/widgets/numbers/game2/number.dart';
import 'package:provider/provider.dart';

class TrainCar extends StatelessWidget {
  final int? number;
  final bool isMiddle;
  final VoidCallback onComplete;

  TrainCar(
      {super.key,
      this.number,
      this.isMiddle = false,
      required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return DragTarget<int>(
      onAccept: (data) {
        context.read<GameProvider>().selectOption(data, onComplete);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 135,
          height: 120,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage(
                  'assets/images/numbers/game2/tren2-removebg-preview.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: isMiddle
                ? (context.watch<GameProvider>().selectedOption != null
                    ? NumberBox(
                        number: context.watch<GameProvider>().selectedOption!)
                    : NumberBox(number: null))
                : (number != null ? NumberBox(number: number!) : Container()),
          ),
        );
      },
    );
  }
}
