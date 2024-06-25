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
    _init();
  }

  void _init() async {
    await _loadFromPrefs();
    await _loadFromFirestore();
    // Usar `addPostFrameCallback` para asegurarse de que los listeners se notifiquen fuera del ciclo de construcción de widgets
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final timesPlayedString = prefs.getString('timesPlayed');
    final timesCompletedString = prefs.getString('timesCompleted');
    if (timesPlayedString != null) {
      _timesPlayed = Map<String, int>.from(json.decode(timesPlayedString));
    }
    if (timesCompletedString != null) {
      _timesCompleted = Map<String, int>.from(json.decode(timesCompletedString));
    }
  }

  Future<void> _loadFromFirestore() async {
    final docSnapshot = await FirebaseFirestore.instance.collection('users').doc('userId').get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data()!;
      _timesPlayed = Map<String, int>.from(data['timesPlayed'] ?? {});
      _timesCompleted = Map<String, int>.from(data['timesCompleted'] ?? {});
    }
  }

  void _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('timesPlayed', json.encode(_timesPlayed));
    prefs.setString('timesCompleted', json.encode(_timesCompleted));
  }

  void _saveToFirestore() async {
    await FirebaseFirestore.instance.collection('users').doc('userId').set({
      'timesPlayed': _timesPlayed,
      'timesCompleted': _timesCompleted,
    });
  }

  void incrementTimesPlayed(String game) {
    _timesPlayed[game] = (_timesPlayed[game] ?? 0) + 1;
    _saveToPrefs();
    _saveToFirestore();
    //notifyListeners();
  }

  void incrementTimesCompleted(String game) {
    _timesCompleted[game] = (_timesCompleted[game] ?? 0) + 1;
    _saveToPrefs();
    _saveToFirestore();
    notifyListeners();
  }
}
