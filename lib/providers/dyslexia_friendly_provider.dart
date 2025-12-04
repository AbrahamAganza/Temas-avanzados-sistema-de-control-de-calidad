import 'package:flutter/material.dart';

class DyslexiaFriendlyProvider with ChangeNotifier {
  bool _isDyslexiaFriendly = false;

  bool get isDyslexiaFriendly => _isDyslexiaFriendly;

  void toggleDyslexiaFriendly() {
    _isDyslexiaFriendly = !_isDyslexiaFriendly;
    notifyListeners();
  }
}
