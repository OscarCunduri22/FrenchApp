import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class GameProvider with ChangeNotifier {
  List<int> options = [];
  List<int?> sequence = [];
  List<int?> previousSequence = [];
  int correctAnswer = 0;
  int? selectedOption;
  bool isCompleted = false;

  GameProvider() {
    generateNewLevel();
  }

  void selectOption(int option) {
    selectedOption = option;
    if (checkAnswer()) {
      isCompleted = true;
      notifyListeners();
      Timer(const Duration(seconds: 2), () {
        selectedOption = null;
        generateNewLevel();
        isCompleted = false;
        notifyListeners();
      });
    } else {
      selectedOption = null;
      notifyListeners();
    }
  }

  bool checkAnswer() {
    return selectedOption == correctAnswer;
  }

  void generateNewLevel() {
    Random random = Random();
    List<int?> newSequence;
    do {
      int sequenceStart = random.nextInt(7) + 1;
      newSequence = List.generate(3, (index) => sequenceStart + index);
    } while (newSequence == previousSequence);

    sequence = newSequence;
    previousSequence = List.from(sequence);
    correctAnswer = sequence[1]!;
    sequence[1] = null;

    Set<int> optionsSet = {correctAnswer};
    while (optionsSet.length < 4) {
      optionsSet.add(random.nextInt(10) + 1);
    }
    options = optionsSet.toList();
    options.shuffle();
  }
}
