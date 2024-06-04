import 'package:flutter/material.dart';

class GameViewModel extends ChangeNotifier {
  final List<String> _numbers = [
    'one',
    'two',
    'three',
    'four',
    'five',
    'six',
    'seven',
    'eight',
    'nine',
    'ten',
  ];
  final List<String> _images = [
    'assets/images/numbers/1.png',
    'assets/images/numbers/2.png',
    'assets/images/numbers/3.png',
    'assets/images/numbers/4.png',
    'assets/images/numbers/5.png',
    'assets/images/numbers/6.png',
    'assets/images/numbers/7.png',
    'assets/images/numbers/8.png',
    'assets/images/numbers/9.png',
    'assets/images/numbers/10.png',
  ];

  int _currentIndex = 0;
  late List<String?> characterSlots;
  bool _currentIndexChanged = false;

  GameViewModel() {
    characterSlots = List<String?>.filled(_numbers[_currentIndex].length, null);
  }

  List<String> get numbers => _numbers;
  List<String> get images => _images;
  int get currentIndex => _currentIndex;
  bool get currentIndexChanged => _currentIndexChanged;

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
        WidgetsBinding.instance.addPostFrameCallback((_) {
          nextWord();
        });
      }
    }
  }

  void nextWord() {
    _currentIndex = (_currentIndex + 1) % _numbers.length;
    characterSlots = List<String?>.filled(_numbers[_currentIndex].length, null);
    _currentIndexChanged = true;
    notifyListeners();
  }

  void onCorrect() {
    // Call the next word method after a delay to allow for confetti animation
    Future.delayed(const Duration(seconds: 1), () {
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
}
