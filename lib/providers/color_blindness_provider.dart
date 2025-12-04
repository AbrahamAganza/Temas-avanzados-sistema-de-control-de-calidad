import 'package:flutter/material.dart';

// Enum para representar los diferentes modos de daltonismo
enum ColorBlindMode {
  none,
  achromatopsia,     // Daltonismo total (escala de grises)
  redGreenDeficiency, // Protanopia / Deuteranopia
}

class ColorBlindnessProvider with ChangeNotifier {
  ColorBlindMode _mode = ColorBlindMode.none;

  ColorBlindMode get mode => _mode;

  void setMode(ColorBlindMode newMode) {
    if (_mode == newMode) {
      // Si el usuario presiona el mismo modo de nuevo, se desactiva
      _mode = ColorBlindMode.none;
    } else {
      _mode = newMode;
    }
    notifyListeners();
  }
}
