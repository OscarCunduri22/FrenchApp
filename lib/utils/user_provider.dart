import 'package:flutter/material.dart';
import 'package:frenc_app/model/tutor.dart';
import 'package:frenc_app/model/student.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserProvider with ChangeNotifier {
  Tutor? _currentUser;
  Student? _currentStudent;
  String? _currentStudentId;

  Tutor? get currentUser => _currentUser;
  Student? get currentStudent => _currentStudent;
  String? get currentStudentId => _currentStudentId;

  UserProvider() {
    loadUserFromPreferences();
  }

  void setCurrentUser(Tutor? user) {
    _currentUser = user;
    notifyListeners();
    _saveUserToPreferences(user);
  }

  void setCurrentStudent(String studentId, Student student) {
    _currentStudentId = studentId;
    _currentStudent = student;
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
    _clearUserPreferences();
  }

  void clearStudent() {
    _currentStudent = null;
    _currentStudentId = null;
    notifyListeners();
  }

  Future<void> _saveUserToPreferences(Tutor? user) async {
    final prefs = await SharedPreferences.getInstance();
    if (user != null) {
      prefs.setString('user', jsonEncode(user.toJson()));
    } else {
      prefs.remove('user');
    }
  }

  Future<void> loadUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    if (userData != null) {
      _currentUser = Tutor.fromJson(jsonDecode(userData));
      notifyListeners();
    }
  }

  Future<void> _clearUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
  }
}
