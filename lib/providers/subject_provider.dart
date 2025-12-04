import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class Subject {
  final String id;
  final String name;

  Subject({required this.id, required this.name});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class SubjectProvider with ChangeNotifier {
  final String? userId;
  List<Subject> _subjects = [];
  String? _selectedSubjectId;
  bool _isLoading = true;
  final Uuid _uuid = const Uuid();

  List<Subject> get subjects => _subjects;
  String? get selectedSubjectId => _selectedSubjectId;
  Subject? get selectedSubject => _selectedSubjectId == null
      ? null
      : _subjects.firstWhere((s) => s.id == _selectedSubjectId);
  bool get isLoading => _isLoading;

  SubjectProvider(this.userId) {
    if (userId != null) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    await _loadSubjects();
    await _loadSelectedSubjectId();
    _isLoading = false;
    notifyListeners();
  }

  Future<File> get _subjectsFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/subjects_$userId.json');
  }

  Future<File> get _selectedSubjectFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/selected_subject_$userId.json');
  }

  Future<void> _loadSubjects() async {
    try {
      final file = await _subjectsFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        if (contents.isNotEmpty) {
          final data = json.decode(contents) as List;
          _subjects = data.map((json) => Subject.fromJson(json)).toList();
        }
      }
    } catch (e) {
      if (kDebugMode) print('Error loading subjects: $e');
    }
  }

  Future<void> _loadSelectedSubjectId() async {
    try {
      final file = await _selectedSubjectFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        if (contents.isNotEmpty) {
          _selectedSubjectId = json.decode(contents) as String?;
        }
      }
    } catch (e) {
      if (kDebugMode) print('Error loading selected subject: $e');
    }
  }

  Future<void> addSubject(String name) async {
    final newSubject = Subject(id: _uuid.v4(), name: name);
    _subjects.add(newSubject);
    if (_subjects.length == 1) {
      _selectedSubjectId = newSubject.id;
    }
    await _saveSubjects();
    await _saveSelectedSubjectId();
    notifyListeners();
  }

  Future<void> selectSubject(String subjectId) async {
    _selectedSubjectId = subjectId;
    await _saveSelectedSubjectId();
    notifyListeners();
  }

  Future<void> _saveSubjects() async {
    final file = await _subjectsFile;
    await file.writeAsString(json.encode(_subjects.map((s) => s.toJson()).toList()));
  }

  Future<void> _saveSelectedSubjectId() async {
    final file = await _selectedSubjectFile;
    await file.writeAsString(json.encode(_selectedSubjectId));
  }
}
