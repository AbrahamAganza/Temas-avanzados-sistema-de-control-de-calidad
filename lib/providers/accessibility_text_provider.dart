import 'package:flutter/material.dart';

class AccessibilityTextProvider with ChangeNotifier {
  String _description = '';

  String get description => _description;

  void setDescription(String newDescription) {
    if (_description != newDescription) {
      // Usamos un post-frame callback para evitar errores de ciclo de vida de los widgets.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _description = newDescription;
        notifyListeners();
      });
    }
  }
}
