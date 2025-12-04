import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechProvider with ChangeNotifier {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;

  bool get isSpeaking => _isSpeaking;

  TextToSpeechProvider() {
    _flutterTts.setStartHandler(() {
      _isSpeaking = true;
      notifyListeners();
    });

    _flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
      notifyListeners();
    });

    _flutterTts.setErrorHandler((msg) {
      _isSpeaking = false;
      notifyListeners();
    });
  }

  Future<void> speak(String text) async {
    if (text.isEmpty) return;
    await _flutterTts.setLanguage("es-ES");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    _isSpeaking = false;
    notifyListeners();
  }

  Future<void> toggle(String text) async {
    if (_isSpeaking) {
      await stop();
    } else {
      await speak(text);
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }
}
