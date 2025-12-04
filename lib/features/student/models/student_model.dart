import 'package:flutter/foundation.dart';

class Student {
  String id;
  String name;
  String paternalSurname;
  String maternalSurname;
  String carrera;
  String semestre;
  String subjectId;
  Map<String, int> calificaciones;
  Map<String, int> asistencias; // Días de asistencia por unidad
  Map<String, bool> factoresRiesgo;

  Student({
    required this.id,
    required this.name,
    required this.paternalSurname,
    required this.maternalSurname,
    required this.carrera,
    required this.semestre,
    required this.subjectId,
    required this.calificaciones,
    required this.asistencias,
    required this.factoresRiesgo,
  });

  String get fullName => '$name $paternalSurname $maternalSurname';

  double get averageGrade {
    if (calificaciones.isEmpty) return 0;
    return calificaciones.values.reduce((a, b) => a + b) / calificaciones.length;
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as String,
      name: json['name'] as String,
      paternalSurname: json['paternalSurname'] as String,
      maternalSurname: json['maternalSurname'] as String,
      carrera: json['carrera'] as String,
      semestre: json['semestre'] as String,
      subjectId: json['subjectId'] as String,
      calificaciones: Map<String, int>.from(json['calificaciones']),
      asistencias: Map<String, int>.from(json['asistencias'] ?? { 'Unidad 1': 0, 'Unidad 2': 0, 'Unidad 3': 0 }),
      factoresRiesgo: Map<String, bool>.from(json['factoresRiesgo']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'paternalSurname': paternalSurname,
      'maternalSurname': maternalSurname,
      'carrera': carrera,
      'semestre': semestre,
      'subjectId': subjectId,
      'calificaciones': calificaciones,
      'asistencias': asistencias,
      'factoresRiesgo': factoresRiesgo,
    };
  }

  Student copyWith({
    String? id,
    String? name,
    String? paternalSurname,
    String? maternalSurname,
    String? carrera,
    String? semestre,
    String? subjectId,
    Map<String, int>? calificaciones,
    Map<String, int>? asistencias,
    Map<String, bool>? factoresRiesgo,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      paternalSurname: paternalSurname ?? this.paternalSurname,
      maternalSurname: maternalSurname ?? this.maternalSurname,
      carrera: carrera ?? this.carrera,
      semestre: semestre ?? this.semestre,
      subjectId: subjectId ?? this.subjectId,
      calificaciones: calificaciones ?? Map<String, int>.from(this.calificaciones),
      asistencias: asistencias ?? Map<String, int>.from(this.asistencias),
      factoresRiesgo: factoresRiesgo ?? Map<String, bool>.from(this.factoresRiesgo),
    );
  }
}
