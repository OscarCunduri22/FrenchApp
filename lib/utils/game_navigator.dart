import 'package:flutter/material.dart';
import 'package:frenc_app/view/family/game1/game_screen.dart';
import 'package:frenc_app/view/family/game2/game_screen.dart';
import 'package:frenc_app/view/family/game3/game_screen.dart';
import 'package:frenc_app/view/numbers/game1/game_screen.dart';
import 'package:frenc_app/view/numbers/game2/game_screen.dart';
import 'package:frenc_app/view/numbers/game3/game_screen.dart';
import 'package:frenc_app/view/vocals/game1/vocal_game.dart';
import 'package:frenc_app/view/vocals/game2/vocal_card_game.dart';
import 'package:frenc_app/view/vocals/game3/animal_name_game.dart';
import 'package:frenc_app/view/start_game.dart';

Widget getGameScreen(String category, int gameNumber) {
  switch (category) {
    case 'Nombres':
      switch (gameNumber) {
        case 1:
          return StartGame(
            title: 'Trouvez votre famille',
            buttons: [
              ButtonData(text: 'Jugar', widget: const TrainWagonNumbersGame()),
            ],
          );
        case 2:
          return StartGame(
            title: 'Trouvez votre famille',
            buttons: [
              ButtonData(text: 'Jugar', widget: const MemoryNumbersGame()),
            ],
          );
        case 3:
          return StartGame(
            title: 'Trouvez votre famille',
            buttons: [
              ButtonData(text: 'Jugar', widget: const BubbleNumbersGame()),
            ],
          );
        default:
          return Container();
      }
    case 'Voyelles':
      switch (gameNumber) {
        case 1:
          return StartGame(
              title: 'Attrapez la voyelle',
              buttons: [ButtonData(text: 'Jugar', widget: const VocalGame())]);
        case 2:
          return StartGame(title: 'Faites correspondre les voyelles', buttons: [
            ButtonData(text: 'Jugar', widget: const VocalMemoryPage())
          ]);
        case 3:
          return StartGame(title: 'Complétez le nom', buttons: [
            ButtonData(text: 'Jugar', widget: const AnimalNameGame())
          ]);
        default:
          return Container();
      }
    case 'Famille':
      switch (gameNumber) {
        case 1:
          return StartGame(
            title: 'Encuentra a la familia',
            buttons: [
              ButtonData(text: 'Jugar', widget: const FindFamilyGame()),
            ],
          );
        case 2:
          return StartGame(
            title: 'Reune a la familia',
            buttons: [
              ButtonData(text: 'Jugar', widget: const GatherFamilyGame()),
            ],
          );
        case 3:
          return StartGame(
            title: 'Empareja a la familia',
            buttons: [
              ButtonData(text: 'Jugar', widget: const MemoryGamePage()),
            ],
          );
        default:
          return Container();
      }
    default:
      return Container();
  }
}
