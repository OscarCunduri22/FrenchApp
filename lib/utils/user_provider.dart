import 'package:flutter/material.dart';
import 'package:frenc_app/model/tutor.dart';

class UserProvider with ChangeNotifier {
  Tutor? _currentUser;

  Tutor? get currentUser => _currentUser;

  void setCurrentUser(Tutor? user) {
    _currentUser = user;
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }
}
