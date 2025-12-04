import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class JsonService {
  Future<dynamic> get(String path) async {
    // This service now only reads and decodes the specified JSON file.
    final response = await rootBundle.loadString(path);
    final data = await json.decode(response);
    return data;
  }
}
