import 'package:flutter/material.dart';

class GameStatusProvider extends ChangeNotifier {
  final String studentId;
  final String category;
  final int gameNumber;
  bool isCompleted = false;
  double progressValue = 0.0;

  GameStatusProvider({
    required this.studentId,
    required this.category,
    required this.gameNumber,
  });

  void completeGame() {
    isCompleted = true;
    notifyListeners();
  }

  void updateProgress(double progress) {
    progressValue = progress;
    notifyListeners();
  }
}
