import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frenc_app/utils/audio_manager.dart';

class GameProvider with ChangeNotifier {
  List<int> options = [];
  List<int?> sequence = [];
  List<int?> previousSequence = [];
  int correctAnswer = 0;
  int? selectedOption;
  bool isCompleted = false;
  int currentLevel = 0;
  final int totalLevels = 5;

  GameProvider() {
    generateNewLevel();
  }

  void selectOption(int option, VoidCallback onComplete) {
    selectedOption = option;
    if (checkAnswer()) {
      isCompleted = true;
      notifyListeners();
      _playCorrectAnswerSounds(onComplete);
    } else {
      selectedOption = null;
      notifyListeners();
    }
  }

  bool checkAnswer() {
    return selectedOption == correctAnswer;
  }

  void generateNewLevel() async {
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

  void _playCorrectAnswerSounds(VoidCallback onComplete) async {
    await AudioManager.effects().play('sound/numbers/yeahf.mp3');
    await Future.delayed(const Duration(seconds: 1));
    await AudioManager.effects().play('sound/numbers/repetir.m4a');
    await Future.delayed(const Duration(seconds: 2));
    await AudioManager.effects().play('sound/numbers/$correctAnswer.m4a');
    await Future.delayed(const Duration(seconds: 2));
    await AudioManager.effects().play('sound/numbers/$correctAnswer.m4a');
    await Future.delayed(const Duration(seconds: 1));

    isCompleted = false;
    notifyListeners();

    selectedOption = null;
    currentLevel++;
    if (currentLevel < totalLevels) {
      generateNewLevel();
    } else {
      onComplete();
    }
  }
}
