import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tads/features/student/models/student_model.dart';
import 'package:tads/providers/audit_provider.dart';

class StudentProvider with ChangeNotifier {
  final AuditProvider? auditProvider;
  final String? subjectId;
  final String? userId;
  List<Student> _students = [];
  Map<String, int> _totalDays = { 'Unidad 1': 1, 'Unidad 2': 1, 'Unidad 3': 1 };
  bool _isLoading = true;
  String? _saveStatus;

  List<Student> get students => _students.where((s) => s.subjectId == subjectId).toList();
  Map<String, int> get totalDays => _totalDays;
  bool get isLoading => _isLoading;
  String? get saveStatus => _saveStatus;

  set saveStatus(String? status) {
    _saveStatus = status;
    notifyListeners();
  }

  StudentProvider({this.auditProvider, this.subjectId, this.userId}) {
    if (subjectId != null && userId != null) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    await _loadStudents();
    await _loadTotalDays();
    _isLoading = false;
    notifyListeners();
  }

  Future<File> get _studentsFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/students_${userId}_${subjectId}.json');
  }

  Future<File> get _totalDaysFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/total_days_${userId}_${subjectId}.json');
  }

  Future<void> _saveStudents() async {
    final file = await _studentsFile;
    final jsonString = json.encode(_students.map((s) => s.toJson()).toList());
    await file.writeAsString(jsonString, flush: true);
  }

  Future<void> _saveTotalDays() async {
    final file = await _totalDaysFile;
    final jsonString = json.encode(_totalDays);
    await file.writeAsString(jsonString, flush: true);
  }

  Future<void> _loadStudents() async {
    try {
      final file = await _studentsFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        if (contents.isNotEmpty) {
          final data = json.decode(contents) as List;
          _students = data.map((json) => Student.fromJson(json)).toList();
        }
      } else {
        _students = [];
      }
    } catch (e) {
      _students = [];
    }
  }

  Future<void> _loadTotalDays() async {
    try {
      final file = await _totalDaysFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        if (contents.isNotEmpty) {
          _totalDays = Map<String, int>.from(json.decode(contents));
        }
      }
    } catch (e) {
      // Use default values if file doesn't exist or is invalid
    }
  }

  Future<void> addStudent(Student student) async {
    final newStudent = student.copyWith(subjectId: subjectId, asistencias: {
      for (var unit in totalDays.keys) unit: 0,
    });
    _students.add(newStudent);
    await _saveStudents();
    auditProvider?.addEvent('Creación', newStudent.id, details: {'nombre': newStudent.fullName, 'materia': subjectId});
    notifyListeners();
  }

  Future<void> updateStudent(Student student, {bool preserveAttendance = false}) async {
    final index = _students.indexWhere((s) => s.id == student.id);
    if (index != -1) {
      final oldStudent = _students[index];
      final updatedStudent = student.copyWith(
        asistencias: preserveAttendance ? oldStudent.asistencias : student.asistencias,
      );
      _students[index] = updatedStudent;
      await _saveStudents();
      auditProvider?.addEvent('Actualización', student.id, details: {'nombre': student.fullName, 'materia': subjectId});
      notifyListeners();
    }
  }

  Future<void> updateTotalDays(Map<String, int> newTotalDays) async {
    _totalDays = newTotalDays;
    await _saveTotalDays();
    notifyListeners();
  }

  Future<void> deleteStudent(String studentId) async {
    final student = _students.firstWhere((s) => s.id == studentId);
    _students.removeWhere((s) => s.id == studentId);
    await _saveStudents();
    auditProvider?.addEvent('Eliminación', studentId, details: {'nombre': student.fullName, 'materia': subjectId});
    notifyListeners();
  }
  
  int get totalStudents => students.length;
  int get atRiskStudents => students.where((s) => s.factoresRiesgo.values.any((isAtRisk) => isAtRisk)).length;
  double get averageGpa {
    if (students.isEmpty) return 0.0;
    final allGrades = students.expand((s) => s.calificaciones.values).toList();
    if (allGrades.isEmpty) return 0.0;
    return allGrades.reduce((a, b) => a + b) / allGrades.length;
  }
  Map<int, int> get gradeDistribution {
    final counts = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0};
    for (var student in students) {
      final average = student.averageGrade;
      if (average < 60) counts[0] = counts[0]! + 1;
      else if (average < 70) counts[1] = counts[1]! + 1;
      else if (average < 80) counts[2] = counts[2]! + 1;
      else if (average < 90) counts[3] = counts[3]! + 1;
      else counts[4] = counts[4]! + 1;
    }
    return counts;
  }
}
