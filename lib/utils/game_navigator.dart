import 'package:flutter/material.dart';
import 'package:frenc_app/view/family/game1/game_screen.dart';
import 'package:frenc_app/view/family/game2/game_screen.dart';
import 'package:frenc_app/view/family/game3/game_screen.dart';
import 'package:frenc_app/view/numbers/game1/game_screen.dart';
import 'package:frenc_app/view/numbers/game2/game_screen.dart';
import 'package:frenc_app/view/numbers/game3/game_screen.dart';
import 'package:frenc_app/view/vocals/game1/vocal_game.dart';
import 'package:frenc_app/view/vocals/game3/animal_name_game.dart';

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
          return const VocalGame();
        case 2:
          return Container();
        case 3:
          return const AnimalNameGame();
        default:
          return Container();
      }
    case 'Famille':
      switch (gameNumber) {
        case 1:
          return const FindFamilyGame();
        case 2:
          return const GatherFamilyGame();
        case 3:
          return const MemoryGamePage();
        default:
          return Container();
      }
    default:
      return Container();
  }
}
