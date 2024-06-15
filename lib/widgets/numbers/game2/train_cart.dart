import 'package:flutter/material.dart';
import 'package:frenc_app/view_model/numbers/game2/game_provider.dart';
import 'package:provider/provider.dart';

class TrainCar extends StatelessWidget {
  final int? number;

  TrainCar({this.number});

  @override
  Widget build(BuildContext context) {
    return DragTarget<int>(
      onAccept: (data) {
        context.read<GameProvider>().selectOption(data);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 100,
          height: 100,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.red,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: number != null
                ? Text(
                    '$number',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  )
                : (context.watch<GameProvider>().selectedOption != null
                    ? Text(
                        '${context.watch<GameProvider>().selectedOption}',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      )
                    : Container()),
          ),
        );
      },
    );
  }
}
