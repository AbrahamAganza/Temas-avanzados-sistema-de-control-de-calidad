import 'package:flutter/material.dart';

class VoiceAssistantProvider with ChangeNotifier {
  bool _isEnabled = false;

  bool get isEnabled => _isEnabled;

  void toggle() {
    _isEnabled = !_isEnabled;
    notifyListeners();
  }
}
