// view_models/fruit_game_view_model.dart
import 'package:flutter/material.dart';
import 'package:frenc_app/model/fruit.dart';

class FruitGameViewModel extends ChangeNotifier {
  List<Fruit> fruits = [
    Fruit('banana', 'assets/images/auth/banana.png'),
    Fruit('orange', 'assets/images/auth/orange.png'),
    Fruit('pear', 'assets/images/auth/pear.png'),
    Fruit('strawberry', 'assets/images/auth/strawberry.png'),
    Fruit('watermelon', 'assets/images/auth/watermelon.png'),
  ];

  Map<String, bool> correctAnswers = {};

  FruitGameViewModel() {
    for (var fruit in fruits) {
      correctAnswers[fruit.name] = false;
    }
  }

  void setCorrectAnswer(String fruitName) {
    correctAnswers[fruitName] = true;
    notifyListeners();
  }

  bool isAllCorrect() {
    return correctAnswers.values.every((correct) => correct);
  }
}
