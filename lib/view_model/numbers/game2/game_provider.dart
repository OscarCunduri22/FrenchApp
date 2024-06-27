import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frenc_app/utils/user_tracking.dart';

class GameProvider with ChangeNotifier {
  List<int> options = [];
  List<int?> sequence = [];
  List<int?> previousSequence = [];
  int correctAnswer = 0;
  int? selectedOption;
  bool isCompleted = false;
  int currentLevel = 0;
  final int totalLevels = 5;

  final UserTracking userTracking;
  final String studentId;

  GameProvider(this.userTracking, this.studentId) {
    _incrementTimesPlayed(); // Incrementar contador de juegos jugados
    generateNewLevel();
  }

  void selectOption(int option, VoidCallback onComplete) {
    selectedOption = option;
    if (checkAnswer()) {
      isCompleted = true;
      notifyListeners();
      Timer(const Duration(seconds: 2), () {
        selectedOption = null;
        currentLevel++;
        if (currentLevel < totalLevels) {
          generateNewLevel();
        } else {
          _incrementTimesCompleted(); // Incrementar contador de juegos completados
          onComplete();
        }
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

  double get progressValue => currentLevel / totalLevels;

  void _incrementTimesPlayed() {
    userTracking.incrementTimesPlayed(studentId, 'train_wagon_numbers_game');
  }

  void _incrementTimesCompleted() {
    userTracking.incrementTimesCompleted(studentId, 'train_wagon_numbers_game');
  }
}
