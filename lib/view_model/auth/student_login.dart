import 'package:flutter/material.dart';
import 'package:frenc_app/model/fruit.dart';

class FruitGameViewModel extends ChangeNotifier {
  List<Fruit> fruits = [
    Fruit(name: 'banana'),
    Fruit(name: 'orange'),
    Fruit(name: 'lemon'),
    Fruit(name: 'strawberry'),
    Fruit(name: 'watermelon'),
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
