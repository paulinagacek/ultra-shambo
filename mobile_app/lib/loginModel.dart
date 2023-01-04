import 'package:flutter/material.dart';
import 'package:mobile_app/globals.dart';

class LoginModel extends ChangeNotifier {
  get isVisible => _isVisible;
  bool _isVisible = false;
  set isVisible(value) {
    _isVisible = value;
    notifyListeners();
  }

  get isRepeatedVisible => _isRepeatedVisible;
  bool _isRepeatedVisible = false;
  set isRepeatedVisible(value) {
    _isRepeatedVisible = value;
    notifyListeners();
  }

  get isEmailValid => _isValid;
  bool _isValid = false;
  void isValidEmail(String input) {
    _isValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(input);
    notifyListeners();
  }
}
