import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tads/features/student/models/student_model.dart';
import 'package:tads/providers/accessibility_text_provider.dart';
import 'package:tads/providers/student_provider.dart';
import 'package:tads/providers/subject_provider.dart';
import 'package:tads/providers/text_to_speech_provider.dart';
import 'package:tads/providers/voice_assistant_provider.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  late Map<String, TextEditingController> _totalDaysControllers;
  final Map<String, Map<String, int>> _updatedAttendances = {};

  @override
  void initState() {
    super.initState();
    final studentProvider = context.read<StudentProvider>();
    _totalDaysControllers = {
      for (var unit in studentProvider.totalDays.keys)
        unit: TextEditingController(text: studentProvider.totalDays[unit].toString()),
    };
  }

  @override
  void dispose() {
    _totalDaysControllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  void _saveChanges() {
    final studentProvider = context.read<StudentProvider>();
    final newTotalDays = {
      for (var entry in _totalDaysControllers.entries)
        entry.key: int.tryParse(entry.value.text) ?? 1,
    };
    studentProvider.updateTotalDays(newTotalDays);

    _updatedAttendances.forEach((studentId, attendances) {
      final student = studentProvider.students.firstWhere((s) => s.id == studentId);
      final updatedStudent = student.copyWith(asistencias: attendances);
      studentProvider.updateStudent(updatedStudent);
    });
    _updatedAttendances.clear();

    final successMessage = 'Asistencias guardadas exitosamente';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(successMessage)),
    );
    if (context.read<VoiceAssistantProvider>().isEnabled) {
      context.read<TextToSpeechProvider>().speak(successMessage);
    }
  }

  Widget _buildSpeakableWidget({required Widget child, required String speechText}) {
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
      'Página de registro de asistencias. En la parte superior, puede editar los días totales de clase para cada unidad. Debajo, se muestra una tabla para registrar las asistencias de cada estudiante por unidad. Presione el ícono de guardar en la esquina superior derecha para aplicar los cambios.'
    );

    final studentProvider = context.watch<StudentProvider>();
    final subjectProvider = context.watch<SubjectProvider>();

    if (subjectProvider.selectedSubjectId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('Por favor, selecciona una materia antes de ver las asistencias.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Asistencias'),
        actions: [
          _buildSpeakableWidget(
            speechText: 'Botón para guardar todos los cambios de asistencia.',
            child: IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveChanges,
            ),
          ),
        ],
      ),
      body: studentProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildTotalDaysInputs(),
                  const SizedBox(height: 20),
                  _buildAttendanceTable(studentProvider),
                ],
              ),
            ),
    );
  }

  Widget _buildTotalDaysInputs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _totalDaysControllers.keys.map((unidad) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _buildSpeakableWidget(
              speechText: 'Campo para días totales de la $unidad',
              child: TextField(
                controller: _totalDaysControllers[unidad],
                decoration: InputDecoration(labelText: 'Días Totales $unidad'),
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAttendanceTable(StudentProvider studentProvider) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('Nombre')),
        DataColumn(label: Text('Asist. U1')),
        DataColumn(label: Text('% U1')),
        DataColumn(label: Text('Asist. U2')),
        DataColumn(label: Text('% U2')),
        DataColumn(label: Text('Asist. U3')),
        DataColumn(label: Text('% U3')),
        DataColumn(label: Text('% Total')),
      ],
      rows: studentProvider.students.map((student) {
        final totalDaysU1 = int.tryParse(_totalDaysControllers['Unidad 1']!.text) ?? 1;
        final totalDaysU2 = int.tryParse(_totalDaysControllers['Unidad 2']!.text) ?? 1;
        final totalDaysU3 = int.tryParse(_totalDaysControllers['Unidad 3']!.text) ?? 1;

        final attendedU1 = _updatedAttendances[student.id]?['Unidad 1'] ?? student.asistencias['Unidad 1'] ?? 0;
        final attendedU2 = _updatedAttendances[student.id]?['Unidad 2'] ?? student.asistencias['Unidad 2'] ?? 0;
        final attendedU3 = _updatedAttendances[student.id]?['Unidad 3'] ?? student.asistencias['Unidad 3'] ?? 0;

        final percentU1 = (attendedU1 / totalDaysU1 * 100).toStringAsFixed(1);
        final percentU2 = (attendedU2 / totalDaysU2 * 100).toStringAsFixed(1);
        final percentU3 = (attendedU3 / totalDaysU3 * 100).toStringAsFixed(1);

        final totalAttended = attendedU1 + attendedU2 + attendedU3;
        final totalDays = totalDaysU1 + totalDaysU2 + totalDaysU3;

        final totalPercent = totalDays > 0 ? (totalAttended / totalDays * 100).toStringAsFixed(1) : '0.0';

        return DataRow(
          cells: <DataCell>[
            DataCell(Text(student.id)),
            DataCell(Text(student.fullName)),
            DataCell(_buildSpeakableWidget(child: _buildAttendanceCell(student, 'Unidad 1', totalDaysU1), speechText: 'Asistencias de ${student.name} para la Unidad 1')),
            DataCell(Text('$percentU1%')),
            DataCell(_buildSpeakableWidget(child: _buildAttendanceCell(student, 'Unidad 2', totalDaysU2), speechText: 'Asistencias de ${student.name} para la Unidad 2')),
            DataCell(Text('$percentU2%')),
            DataCell(_buildSpeakableWidget(child: _buildAttendanceCell(student, 'Unidad 3', totalDaysU3), speechText: 'Asistencias de ${student.name} para la Unidad 3')),
            DataCell(Text('$percentU3%')),
            DataCell(Text('$totalPercent%')),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildAttendanceCell(Student student, String unidad, int totalDays) {
    return TextFormField(
      initialValue: (_updatedAttendances[student.id]?[unidad] ?? student.asistencias[unidad])?.toString() ?? '0',
      keyboardType: TextInputType.number,
      onChanged: (value) {
        final newAttendance = int.tryParse(value) ?? 0;
        if (newAttendance > totalDays) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('La asistencia no puede ser mayor a los días totales')),
          );
          return;
        }
        setState(() {
          _updatedAttendances.putIfAbsent(student.id, () => Map.from(student.asistencias));
          _updatedAttendances[student.id]![unidad] = newAttendance;
        });
      },
    );
  }
}
