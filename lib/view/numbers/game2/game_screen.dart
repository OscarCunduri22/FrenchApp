import 'package:flutter/material.dart';
import 'package:frenc_app/view_model/numbers/game2/game_provider.dart';
import 'package:frenc_app/widgets/numbers/game2/numbers_options.dart';
import 'package:frenc_app/widgets/numbers/game2/train_cart.dart';
import 'package:provider/provider.dart';

class TrainWagonNumbersGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Drag and Drop Game'),
        ),
        body: Consumer<GameProvider>(
          builder: (context, gameProvider, child) {
            return Column(
              children: [
                SizedBox(height: 20),
                Text(
                  'Select the number to complete the sequence',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: gameProvider.options
                      .map((number) => NumberOptionWidget(number: number))
                      .toList(),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: gameProvider.sequence
                      .map((number) => TrainCar(number: number))
                      .toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
