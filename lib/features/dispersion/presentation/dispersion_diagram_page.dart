import 'dart:io';
import 'dart:ui';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tads/features/student/models/student_model.dart';
import 'package:tads/providers/accessibility_text_provider.dart';
import 'package:tads/providers/color_blindness_provider.dart';
import 'package:tads/providers/student_provider.dart';
import 'package:tads/providers/text_to_speech_provider.dart';
import 'package:tads/providers/voice_assistant_provider.dart';

class DispersionDiagramPage extends StatelessWidget {
  const DispersionDiagramPage({super.key});

  Widget _buildSpeakableWidget(BuildContext context, {required Widget child, required String speechText}) {
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
      'Página del diagrama de dispersión. Muestra la relación entre la asistencia y el rendimiento académico. El eje horizontal X representa el porcentaje de asistencia, y el eje vertical Y representa la calificación promedio del estudiante. Cada punto en el gráfico es un estudiante.'
    );

    final studentProvider = context.watch<StudentProvider>();
    final theme = Theme.of(context);
    final colorBlindMode = context.watch<ColorBlindnessProvider>().mode;
    final isDarkMode = theme.brightness == Brightness.dark;
    final GlobalKey _chartKey = GlobalKey();

    final List<ScatterSpot> spots = studentProvider.students.map((student) {
      final totalAttended = student.asistencias.values.fold(0, (a, b) => a + b);
      final totalDays = studentProvider.totalDays.values.reduce((a, b) => a + b);
      final attendancePercent = totalDays > 0 ? (totalAttended / totalDays * 100) : 0.0;

      return ScatterSpot(
        attendancePercent,
        student.averageGrade,
      );
    }).toList();

    void _captureAndSaveChart() async {
      try {
        RenderRepaintBoundary boundary = _chartKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
        var image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
        Uint8List pngBytes = byteData!.buffer.asUint8List();

        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/diagrama_dispersion.png').create();
        await imagePath.writeAsBytes(pngBytes);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gráfico guardado en: ${imagePath.path}')),
        );
      } catch(e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el gráfico: $e')),
        );
      }
    }

    Widget chartWidget = ScatterChart(
      ScatterChartData(
        scatterSpots: spots,
        minX: 0,
        maxX: 100,
        minY: 0,
        maxY: 100,
        scatterTouchData: ScatterTouchData(
          enabled: true,
          handleBuiltInTouches: true,
          touchTooltipData: ScatterTouchTooltipData(
            getTooltipItems: (touchedSpot) {
              Student? student;
              try {
                student = studentProvider.students.firstWhere(
                  (s) {
                    final totalAttended = s.asistencias.values.fold(0, (a, b) => a + b);
                    final totalDays = studentProvider.totalDays.values.reduce((a, b) => a + b);
                    final attendancePercent = totalDays > 0 ? (totalAttended / totalDays * 100) : 0.0;
                    bool xMatch = (attendancePercent - touchedSpot.x).abs() < 0.01;
                    bool yMatch = (s.averageGrade - touchedSpot.y).abs() < 0.01;
                    return xMatch && yMatch;
                  },
                );
              } catch (e) {
                student = null;
              }

              if (student == null) {
                return ScatterTooltipItem('', textStyle: const TextStyle(fontSize: 0, color: Colors.transparent));
              }

              final totalAttended = student.asistencias.values.fold(0, (a, b) => a + b);
              final totalDays = studentProvider.totalDays.values.reduce((a, b) => a + b);
              final attendancePercent = totalDays > 0 ? (totalAttended / totalDays * 100) : 0.0;

              return ScatterTooltipItem(
                '${student.fullName}\nAsistencia: ${attendancePercent.toStringAsFixed(1)}%\nPromedio: ${student.averageGrade.toStringAsFixed(1)}',
                textStyle: const TextStyle(color: Colors.white, fontSize: 12),
                bottomMargin: 10,
              );
            },
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: theme.colorScheme.onBackground, width: 1),
        ),
        gridData: FlGridData(show: true, getDrawingHorizontalLine: (value) => FlLine(color: theme.colorScheme.onSurface.withOpacity(0.1)), getDrawingVerticalLine: (value) => FlLine(color: theme.colorScheme.onSurface.withOpacity(0.1))),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, interval: 10, getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: TextStyle(color: theme.colorScheme.onBackground, fontSize: 10)) )),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, interval: 10, getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: TextStyle(color: theme.colorScheme.onBackground, fontSize: 10)) )),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
      ),
    );

    final bool applyGrayscale =
        colorBlindMode == ColorBlindMode.achromatopsia ||
        colorBlindMode == ColorBlindMode.redGreenDeficiency;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Diagrama de Dispersión'),
        actions: [
          _buildSpeakableWidget(context,
            speechText: 'Botón para compartir el gráfico',
            child: IconButton(
              icon: const Icon(Icons.share),
              onPressed: _captureAndSaveChart,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSpeakableWidget(context,
              speechText: 'Título: Relación entre Asistencia y Calificación Promedio',
              child: Text(
                'Relación entre Asistencia (%) y Calificación Promedio',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: studentProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildSpeakableWidget(context,
                    speechText: 'Gráfico de dispersión. El eje horizontal es el porcentaje de asistencia y el eje vertical es la calificación. Cada punto es un estudiante.',
                    child: RepaintBoundary(
                        key: _chartKey,
                        child: Container(
                          color: isDarkMode ? Colors.black : Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: applyGrayscale
                                ? ColorFiltered(
                                    colorFilter: const ColorFilter.mode(
                                      Colors.grey,
                                      BlendMode.saturation,
                                    ),
                                    child: chartWidget,
                                  )
                                : chartWidget,
                          ),
                        ),
                      ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
