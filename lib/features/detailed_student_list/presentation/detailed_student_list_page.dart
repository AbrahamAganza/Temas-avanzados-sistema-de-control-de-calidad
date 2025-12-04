import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tads/features/student/models/student_model.dart';
import 'package:tads/providers/accessibility_text_provider.dart';
import 'package:tads/providers/student_provider.dart';
import 'package:tads/providers/subject_provider.dart';
import 'package:tads/providers/text_to_speech_provider.dart';
import 'package:tads/providers/voice_assistant_provider.dart';

class DetailedStudentListPage extends StatelessWidget {
  const DetailedStudentListPage({super.key});

  Widget _buildSpeakableCell(BuildContext context, {required Widget child, required String speechText}) {
    final voiceAssistantProvider = context.watch<VoiceAssistantProvider>();
    final ttsProvider = context.read<TextToSpeechProvider>();

    return Listener(
      onPointerDown: (_) {
        if (voiceAssistantProvider.isEnabled) {
          ttsProvider.speak(speechText);
        }
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final accessibilityTextProvider = Provider.of<AccessibilityTextProvider>(context, listen: false);
    accessibilityTextProvider.setDescription(
      'Página de la lista detallada de estudiantes. Muestra una tabla con la información completa de cada estudiante, incluyendo sus calificaciones por unidad y los porcentajes de asistencia.'
    );

    final studentProvider = context.watch<StudentProvider>();
    final subjectProvider = context.watch<SubjectProvider>();

    if (subjectProvider.selectedSubjectId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('Por favor, selecciona una materia antes de ver la lista de estudiantes.'),
        ),
      );
    }

    final units = studentProvider.students.isNotEmpty
        ? studentProvider.students.first.calificaciones.keys.toList()
        : <String>['Unidad 1', 'Unidad 2', 'Unidad 3'];

    final List<DataColumn> columns = [
      const DataColumn(label: Text('ID')),
      const DataColumn(label: Text('Nombre Completo')),
      const DataColumn(label: Text('Carrera')),
      const DataColumn(label: Text('Semestre')),
      ...units.map((unit) => DataColumn(label: Text(unit))),
      ...units.map((unit) => DataColumn(label: Text('% Asist. $unit'))),
      const DataColumn(label: Text('% Asist. Total')),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Detallada de Estudiantes'),
      ),
      body: studentProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DataTable(
                    columns: columns,
                    rows: studentProvider.students.map((student) {
                      return DataRow(
                        cells: <DataCell>[
                          DataCell(_buildSpeakableCell(context, child: Text(student.id), speechText: 'ID: ${student.id}')),
                          DataCell(_buildSpeakableCell(context, child: Text(student.fullName), speechText: 'Nombre Completo: ${student.fullName}')),
                          DataCell(_buildSpeakableCell(context, child: Text(student.carrera), speechText: 'Carrera: ${student.carrera}')),
                          DataCell(_buildSpeakableCell(context, child: Text(student.semestre), speechText: 'Semestre: ${student.semestre}')),
                          ...units.map((unit) => DataCell(_buildSpeakableCell(context, child: Text(student.calificaciones[unit]?.toString() ?? 'N/A'), speechText: 'Calificación $unit: ${student.calificaciones[unit]?.toString() ?? 'No Asignada'}'))),
                          ...units.map((unit) {
                            final attended = student.asistencias[unit] ?? 0;
                            final totalDays = studentProvider.totalDays[unit] ?? 1;
                            final percent = (attended / totalDays * 100).toStringAsFixed(1);
                            return DataCell(_buildSpeakableCell(context, child: Text('$percent%'), speechText: 'Porcentaje de asistencia $unit: $percent porciento'));
                          }),
                          DataCell(_buildSpeakableCell(context, child: Text('${_calculateTotalAttendance(student, studentProvider.totalDays)}%'), speechText: 'Porcentaje de asistencia total: ${_calculateTotalAttendance(student, studentProvider.totalDays)} porciento')),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
    );
  }

  String _calculateTotalAttendance(Student student, Map<String, int> totalDays) {
    final totalAttended = student.asistencias.values.fold(0, (a, b) => a + b);
    final totalPossibleDays = totalDays.values.reduce((a, b) => a + b);
    return totalPossibleDays > 0 ? (totalAttended / totalPossibleDays * 100).toStringAsFixed(1) : '0.0';
  }
}
