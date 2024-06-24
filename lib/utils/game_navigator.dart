import 'package:flutter/material.dart';
import 'package:frenc_app/view/numbers/game1/game_screen.dart';
import 'package:frenc_app/view/numbers/game2/game_screen.dart';
import 'package:frenc_app/view/numbers/game3/game_screen.dart';

Widget getGameScreen(String category, int gameNumber) {
  switch (category) {
    case 'Nombres':
      switch (gameNumber) {
        case 1:
          return TrainWagonNumbersGame();
        case 2:
          return MemoryNumbersGame();
        case 3:
          return const BubbleNumbersGame();
        default:
          return Container();
      }
    case 'Voyelles':
      switch (gameNumber) {
        case 1:
          return Container();
        case 2:
          return Container();
        case 3:
          return Container();
        default:
          return Container();
      }
    case 'Famille':
      switch (gameNumber) {
        case 1:
          return Container();
        case 2:
          return Container();
        case 3:
          return Container();
        default:
          return Container();
      }
    default:
      return Container();
  }
}
