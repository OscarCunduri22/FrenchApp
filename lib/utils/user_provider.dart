import 'package:flutter/material.dart';
import 'package:frenc_app/model/tutor.dart';
import 'package:frenc_app/model/student.dart';

class UserProvider with ChangeNotifier {
  Tutor? _currentUser;
  Student? _currentStudent;
  String? _currentStudentId;

  Tutor? get currentUser => _currentUser;
  Student? get currentStudent => _currentStudent;
  String? get currentStudentId => _currentStudentId;

  void setCurrentUser(Tutor? user) {
    _currentUser = user;
    notifyListeners();
  }

  void setCurrentStudent(String studentId, Student student) {
    _currentStudentId = studentId;
    _currentStudent = student;
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }

  void clearStudent() {
    _currentStudent = null;
    _currentStudentId = null;
    notifyListeners();
  }
}
