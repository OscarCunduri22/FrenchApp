import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frenc_app/utils/user_tracking.dart';

class GameViewModel extends ChangeNotifier {
  final List<String> _numbers = [
    'UN',
    'DEUX',
    'TROIS',
    'QUATRE',
    'CINQ',
    'SIX',
    'SEPT',
    'HUIT',
    'NEUF',
    'DIX',
  ];

  final List<String> _images = [
    'assets/images/numbers/game1/1.png',
    'assets/images/numbers/game1/2.png',
    'assets/images/numbers/game1/3.png',
    'assets/images/numbers/game1/4.png',
    'assets/images/numbers/game1/5.png',
    'assets/images/numbers/game1/6.png',
    'assets/images/numbers/game1/7.png',
    'assets/images/numbers/game1/8.png',
    'assets/images/numbers/game1/9.png',
    'assets/images/numbers/game1/10.png',
  ];

  int _currentIndex = 0;
  late List<String?> characterSlots;
  bool _currentIndexChanged = false;
  bool _isGameCompleted = false;
  final int totalLevels = 10;

  final UserTracking userTracking;
  final String studentId;

  GameViewModel(this.userTracking, this.studentId) {
    characterSlots = List<String?>.filled(_numbers[_currentIndex].length, null);
    _incrementTimesPlayed(); // Incrementar contador de juegos jugados
  }

  List<String> get numbers => _numbers;
  List<String> get images => _images;
  int get currentIndex => _currentIndex;
  bool get currentIndexChanged => _currentIndexChanged;
  bool get isGameCompleted => _isGameCompleted;

  set currentIndexChanged(bool value) {
    _currentIndexChanged = value;
    notifyListeners();
  }

  void addCharacter(int index, String character) {
    if (characterSlots[index] == null &&
        character == _numbers[_currentIndex][index]) {
      characterSlots[index] = character;
      notifyListeners();

      if (characterSlots.every((element) => element != null)) {
        onCorrect();
      }
    }
  }

  void nextWord() {
    if (_currentIndex < totalLevels - 1) {
      _currentIndex++;
      characterSlots =
          List<String?>.filled(_numbers[_currentIndex].length, null);
      _currentIndexChanged = true;
      notifyListeners();
    } else {
      _isGameCompleted = true;
      _incrementTimesCompleted(); // Incrementar contador de juegos completados
      notifyListeners();
    }
  }

  void onCorrect() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    Future.delayed(const Duration(seconds: 2), () {
      nextWord();
    });
  }

  List<String> getShuffledCharacters(String word) {
    List<String> characters = word.split('');
    characters.shuffle();
    return characters;
  }

  void resetCharacterSlots() {
    characterSlots = List<String?>.filled(_numbers[_currentIndex].length, null);
    notifyListeners();
  }

  void _incrementTimesPlayed() {
    userTracking.incrementTimesPlayed(studentId, 'bubble_numbers_game');
  }

  void _incrementTimesCompleted() {
    userTracking.incrementTimesCompleted(studentId, 'bubble_numbers_game');
  }
}
