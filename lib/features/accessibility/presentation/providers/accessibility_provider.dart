import 'package:flutter/foundation.dart';

class AccessibilityProvider with ChangeNotifier {
  double _zoomLevel = 1.0;

  double get zoomLevel => _zoomLevel;

  void zoomIn() {
    if (_zoomLevel < 1.5) {
      _zoomLevel += 0.1;
      notifyListeners();
    }
  }

  void zoomOut() {
    if (_zoomLevel > 0.8) {
      _zoomLevel -= 0.1;
      notifyListeners();
    }
  }
}
