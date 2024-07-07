import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frenc_app/utils/audio_manager.dart';
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

  final List<String> _audioFiles = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
  ];

  int _currentIndex = 0;
  late List<String?> characterSlots;
  bool _currentIndexChanged = false;
  bool _isGameCompleted = false;
  bool _isCorrect = false;
  bool _isPlayingSound = false;
  final int totalLevels = 10;

  final UserTracking userTracking;
  final String studentId;

  GameViewModel(this.userTracking, this.studentId) {
    characterSlots = List<String?>.filled(_numbers[_currentIndex].length, null);
    _incrementTimesPlayed();
  }

  List<String> get numbers => _numbers;
  List<String> get images => _images;
  int get currentIndex => _currentIndex;
  bool get currentIndexChanged => _currentIndexChanged;
  bool get isGameCompleted => _isGameCompleted;
  bool get isCorrect => _isCorrect;
  bool get isPlayingSound => _isPlayingSound;

  set currentIndexChanged(bool value) {
    _currentIndexChanged = value;
    notifyListeners();
  }

  set isCorrect(bool value) {
    _isCorrect = value;
    notifyListeners();
  }

  void addCharacter(int index, String character) {
    if (characterSlots[index] == null) {
      if (character == _numbers[_currentIndex][index]) {
        characterSlots[index] = character;
        notifyListeners();
        if (characterSlots.every((element) => element != null)) {
          onCorrect();
        }
      } else {
        _playIncorrectLetterSound();
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
      _incrementTimesCompleted();
      notifyListeners();
    }
  }

  void onCorrect() {
    markAsCorrect();
    _playCorrectAnswerSounds(_audioFiles[_currentIndex]).then((_) {
      nextWord();
    });
  }

  void markAsCorrect() {
    _isCorrect = true;
    notifyListeners();
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

  Future<void> _playCorrectAnswerSounds(String audioFileName) async {
    _isPlayingSound = true;
    notifyListeners();

    await AudioManager.effects().play('sound/numbers/yeahf.mp3');
    await Future.delayed(const Duration(seconds: 1));
    await AudioManager.effects().play('sound/numbers/repetir.m4a');
    await Future.delayed(const Duration(seconds: 2));
    await AudioManager.effects().play('sound/numbers/$audioFileName.m4a');
    await Future.delayed(const Duration(seconds: 2));
    await AudioManager.effects().play('sound/numbers/$audioFileName.m4a');
    await Future.delayed(const Duration(seconds: 1));

    _isPlayingSound = false;
    notifyListeners();
  }

  Future<void> _playIncorrectLetterSound() async {
    await AudioManager.effects().play('sound/incorrect.mp3');
  }

  void _incrementTimesPlayed() {
    userTracking.incrementTimesPlayed(studentId, 'bubble_numbers_game');
  }

  void _incrementTimesCompleted() {
    userTracking.incrementTimesCompleted(studentId, 'bubble_numbers_game');
  }
}
