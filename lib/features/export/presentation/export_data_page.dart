import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tads/providers/accessibility_text_provider.dart';
import 'package:tads/providers/color_blindness_provider.dart';
import 'package:tads/providers/student_provider.dart';
import 'package:tads/features/student/models/student_model.dart';
import 'package:tads/providers/text_to_speech_provider.dart';
import 'package:tads/providers/voice_assistant_provider.dart';

class ExportDataPage extends StatefulWidget {
  const ExportDataPage({super.key});

  @override
  State<ExportDataPage> createState() => _ExportDataPageState();
}

class _ExportDataPageState extends State<ExportDataPage> {
  bool _isExporting = false;

  Future<void> _onExport(String format) async {
    setState(() {
      _isExporting = true;
    });

    try {
      final studentProvider = context.read<StudentProvider>();
      final voiceAssistantProvider = context.read<VoiceAssistantProvider>();
      final ttsProvider = context.read<TextToSpeechProvider>();
      String data;
      String fileName;

      if (format == 'csv') {
        data = _generateCsv(studentProvider, studentProvider.students);
        fileName = 'estudiantes.csv';
      } else {
        data = _generateHtml(studentProvider, studentProvider.students);
        fileName = 'estudiantes.html';
      }

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsString(data);

      final successMessage = 'Archivo guardado en: $filePath';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage)),
      );
      if (voiceAssistantProvider.isEnabled) {
        ttsProvider.speak(successMessage);
      }
      
    } catch (e) {
      final errorMessage = 'Error al exportar: $e';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
       if (context.read<VoiceAssistantProvider>().isEnabled) {
        context.read<TextToSpeechProvider>().speak(errorMessage);
      }
    } finally {
      setState(() {
        _isExporting = false;
      });
    }
  }

  String _generateCsv(StudentProvider studentProvider, List<Student> students) {
    final units = students.isNotEmpty ? students.first.calificaciones.keys.toList() : <String>['Unidad 1', 'Unidad 2', 'Unidad 3'];
    final headers = ['ID', 'Nombre Completo', 'Carrera', 'Semestre', ...units, ...units.map((u) => '% Asist. $u'), '% Asist. Total'];
    final List<List<dynamic>> rows = [headers];

    for (var student in students) {
      final row = [
        student.id,
        student.fullName,
        student.carrera,
        student.semestre,
        ...units.map((unit) => student.calificaciones[unit] ?? 'N/A'),
        ...units.map((unit) {
          final attended = student.asistencias[unit] ?? 0;
          final totalDays = studentProvider.totalDays[unit] ?? 1;
          return (attended / totalDays * 100).toStringAsFixed(1) + '%';
        }),
        _calculateTotalAttendance(student, studentProvider.totalDays) + '%',
      ];
      rows.add(row);
    }

    return rows.map((row) => row.join(',')).join('\n');
  }

  String _calculateTotalAttendance(Student student, Map<String, int> totalDays) {
    final totalAttended = student.asistencias.values.fold(0, (a, b) => a + b);
    final totalPossibleDays = totalDays.values.reduce((a,b) => a+b);
    return totalPossibleDays > 0 ? (totalAttended / totalPossibleDays * 100).toStringAsFixed(1) : '0.0';
  }

  String _generateHtml(StudentProvider studentProvider, List<Student> students) {
    final units = students.isNotEmpty ? students.first.calificaciones.keys.toList() : <String>['Unidad 1', 'Unidad 2', 'Unidad 3'];
    final buffer = StringBuffer();

    buffer.writeln('<!DOCTYPE html>');
    buffer.writeln('<html>');
    buffer.writeln('<head>');
    buffer.writeln('<title>Lista de Estudiantes</title>');
    buffer.writeln('<style>');
    buffer.writeln('body { font-family: sans-serif; }');
    buffer.writeln('table { border-collapse: collapse; width: 100%; }');
    buffer.writeln('th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }');
    buffer.writeln('tr:nth-child(even) { background-color: #f2f2f2; }');
    buffer.writeln('</style>');
    buffer.writeln('</head>');
    buffer.writeln('<body>');
    buffer.writeln('<h2>Lista Detallada de Estudiantes</h2>');
    buffer.writeln('<table>');
    buffer.writeln('<thead>');
    buffer.writeln('<tr>');
    buffer.writeln('<th>ID</th><th>Nombre Completo</th><th>Carrera</th><th>Semestre</th>');
    for (var unit in units) { buffer.writeln('<th>$unit</th>'); }
    for (var unit in units) { buffer.writeln('<th>% Asist. $unit</th>'); }
    buffer.writeln('<th>% Asist. Total</th>');
    buffer.writeln('</tr>');
    buffer.writeln('</thead>');
    buffer.writeln('<tbody>');

    for (var student in students) {
      buffer.writeln('<tr>');
      buffer.writeln('<td>${student.id}</td><td>${student.fullName}</td><td>${student.carrera}</td><td>${student.semestre}</td>');
      for (var unit in units) { buffer.writeln('<td>${student.calificaciones[unit] ?? 'N/A'}</td>'); }
      for (var unit in units) {
        final attended = student.asistencias[unit] ?? 0;
        final totalDays = studentProvider.totalDays[unit] ?? 1;
        final percent = (attended / totalDays * 100).toStringAsFixed(1);
        buffer.writeln('<td>$percent%</td>');
      }
      final totalPercent = _calculateTotalAttendance(student, studentProvider.totalDays);
      buffer.writeln('<td>$totalPercent%</td>');
      buffer.writeln('</tr>');
    }

    buffer.writeln('</tbody>');
    buffer.writeln('</table>');
    buffer.writeln('</body>');
    buffer.writeln('</html>');

    return buffer.toString();
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
      'Página para exportar datos. Puede generar un archivo con todos los datos de los estudiantes en formato CSV para hojas de cálculo, o en formato HTML para visualización web o impresión a PDF.'
    );

    final theme = Theme.of(context);
    final colorBlindMode = context.watch<ColorBlindnessProvider>().mode;

    // Determinar el color del botón de HTML/PDF
    Color pdfButtonColor;
    if (colorBlindMode == ColorBlindMode.redGreenDeficiency || colorBlindMode == ColorBlindMode.achromatopsia) {
      pdfButtonColor = theme.colorScheme.secondary;
    } else {
      pdfButtonColor = Colors.red;
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Exportar Datos'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSpeakableWidget(
              speechText: 'Título: Exportar Datos de Estudiantes',
              child: Text(
                'Exportar Datos de Estudiantes',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            _buildSpeakableWidget(
              speechText: 'Esta función generará un archivo que puedes guardar en tu dispositivo.',
              child: const Text(
                'Esta función generará un archivo que puedes guardar en tu dispositivo.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 40),
            _isExporting
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    _buildSpeakableWidget(
                      speechText: 'Botón para exportar los datos en formato CSV.',
                      child: ElevatedButton.icon(
                        onPressed: () => _onExport('csv'),
                        icon: Icon(Icons.grid_on, color: theme.colorScheme.onPrimary),
                        label: Text('Exportar a CSV', style: TextStyle(color: theme.colorScheme.onPrimary)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSpeakableWidget(
                      speechText: 'Botón para exportar los datos en formato HTML, que se puede imprimir a PDF.',
                      child: ElevatedButton.icon(
                        onPressed: () => _onExport('html'),
                        icon: Icon(Icons.picture_as_pdf, color: theme.colorScheme.onSecondary.withOpacity(0.8)),
                        label: Text('Exportar a HTML/PDF', style: TextStyle(color: theme.colorScheme.onSecondary.withOpacity(0.8))),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: pdfButtonColor,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
