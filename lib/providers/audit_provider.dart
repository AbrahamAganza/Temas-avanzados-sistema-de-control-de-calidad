import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class AuditEvent {
  final String action;
  final String studentId;
  final DateTime timestamp;
  final Map<String, dynamic> details;

  AuditEvent({
    required this.action,
    required this.studentId,
    required this.timestamp,
    this.details = const {},
  });

  factory AuditEvent.fromJson(Map<String, dynamic> json) {
    return AuditEvent(
      action: json['action'] as String,
      studentId: json['studentId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      details: Map<String, dynamic>.from(json['details'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'action': action,
    'studentId': studentId,
    'timestamp': timestamp.toIso8601String(),
    'details': details,
  };
}

class AuditProvider with ChangeNotifier {
  List<AuditEvent> _events = [];
  bool _isLoading = true;

  List<AuditEvent> get events => _events;
  bool get isLoading => _isLoading;

  AuditProvider() {
    _loadEvents();
  }

  Future<File> get _auditFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/audit_log.json');
  }

  Future<void> _loadEvents() async {
    try {
      final file = await _auditFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        if (contents.isNotEmpty) {
          final data = json.decode(contents) as List;
          _events = data.map((json) => AuditEvent.fromJson(json)).toList();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading audit events: $e');
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveEvents() async {
    try {
      final file = await _auditFile;
      final jsonString = json.encode(_events.map((e) => e.toJson()).toList());
      await file.writeAsString(jsonString, flush: true);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving audit events: $e');
      }
    }
  }

  Future<void> addEvent(String action, String studentId, {Map<String, dynamic> details = const {}}) async {
    final event = AuditEvent(
      action: action,
      studentId: studentId,
      timestamp: DateTime.now(),
      details: details,
    );
    _events.insert(0, event); // Add to the top of the list
    await _saveEvents();
    notifyListeners();
  }
}
