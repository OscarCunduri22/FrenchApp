import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserTracking extends ChangeNotifier {
  Map<String, int> _timesPlayed = {};
  Map<String, int> _timesCompleted = {};

  Map<String, int> get timesPlayed => _timesPlayed;
  Map<String, int> get timesCompleted => _timesCompleted;

  UserTracking() {
    // _init() is removed since student-specific data should be loaded separately
  }

  Future<void> loadTrackingData(String studentId) async {
    await _loadFromPrefs(studentId);
    await _loadFromFirestore(studentId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> _loadFromPrefs(String studentId) async {
    final prefs = await SharedPreferences.getInstance();
    final timesPlayedString = prefs.getString('timesPlayed_$studentId');
    final timesCompletedString = prefs.getString('timesCompleted_$studentId');
    if (timesPlayedString != null) {
      _timesPlayed = Map<String, int>.from(json.decode(timesPlayedString));
    }
    if (timesCompletedString != null) {
      _timesCompleted = Map<String, int>.from(json.decode(timesCompletedString));
    }
  }

  Future<void> _loadFromFirestore(String studentId) async {
    final docSnapshot = await FirebaseFirestore.instance.collection('users').doc(studentId).get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data()!;
      _timesPlayed = Map<String, int>.from(data['timesPlayed'] ?? {});
      _timesCompleted = Map<String, int>.from(data['timesCompleted'] ?? {});
    }
  }

  Future<void> _saveToPrefs(String studentId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('timesPlayed_$studentId', json.encode(_timesPlayed));
    prefs.setString('timesCompleted_$studentId', json.encode(_timesCompleted));
  }

  Future<void> _saveToFirestore(String studentId) async {
    await FirebaseFirestore.instance.collection('users').doc(studentId).set({
      'timesPlayed': _timesPlayed,
      'timesCompleted': _timesCompleted,
    });
  }

  void incrementTimesPlayed(String studentId, String game) {
    _timesPlayed[game] = (_timesPlayed[game] ?? 0) + 1;
    _saveToPrefs(studentId);
    _saveToFirestore(studentId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void incrementTimesCompleted(String studentId, String game) {
    _timesCompleted[game] = (_timesCompleted[game] ?? 0) + 1;
    _saveToPrefs(studentId);
    _saveToFirestore(studentId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  int getTotalGamesPlayed() {
    return _timesPlayed.values.fold(0, (sum, value) => sum + value);
  }

  String getMostPlayedGame() {
    if (_timesPlayed.isEmpty) {
      return "N/A";
    }
    return _timesPlayed.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}
