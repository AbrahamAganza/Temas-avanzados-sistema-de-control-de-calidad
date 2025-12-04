import 'dart:io';
import 'dart:ui';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tads/providers/accessibility_text_provider.dart';
import 'package:tads/providers/color_blindness_provider.dart';
import 'package:tads/providers/student_provider.dart';
import 'package:tads/providers/text_to_speech_provider.dart';
import 'package:tads/providers/voice_assistant_provider.dart';

class ParetoAnalysisPage extends StatelessWidget {
  const ParetoAnalysisPage({super.key});

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
      'Página de análisis de Pareto de factores de riesgo. Muestra un gráfico de Pareto que combina barras y una línea. Las barras representan la frecuencia de cada factor de riesgo, ordenadas de mayor a menor. La línea roja representa el porcentaje acumulado, ayudando a identificar los factores que causan la mayoría de los problemas, según el principio de Pareto.'
    );

    final studentProvider = context.watch<StudentProvider>();
    final theme = Theme.of(context);
    final colorBlindMode = context.watch<ColorBlindnessProvider>().mode;
    final isAchromatopsia = colorBlindMode == ColorBlindMode.achromatopsia;
    final isRedGreenDeficiency = colorBlindMode == ColorBlindMode.redGreenDeficiency;

    final isDarkMode = theme.brightness == Brightness.dark;
    final GlobalKey _chartKey = GlobalKey();

    final Map<String, int> riskFactorCounts = {};
    if (!studentProvider.isLoading) {
      for (var student in studentProvider.students) {
        for (var entry in student.factoresRiesgo.entries) {
          if (entry.value) {
            riskFactorCounts[entry.key] = (riskFactorCounts[entry.key] ?? 0) + 1;
          }
        }
      }
    }

    final sortedEntries = riskFactorCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    final sortedRiskFactors = Map.fromEntries(sortedEntries);

    final double maxCount = sortedRiskFactors.values.isNotEmpty ? sortedRiskFactors.values.first.toDouble() : 1.0;
    final int totalCount = sortedRiskFactors.values.isNotEmpty ? sortedRiskFactors.values.reduce((a, b) => a + b) : 0;
    
    final List<BarChartGroupData> barGroups = [];
    final List<FlSpot> lineSpots = [];
    double cumulativeValue = 0;

    for (int i = 0; i < sortedRiskFactors.length; i++) {
      final entry = sortedRiskFactors.entries.elementAt(i);
      cumulativeValue += entry.value;
      
      final double cumulativeY = totalCount > 0 ? (cumulativeValue / totalCount) * maxCount : 0.0;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [BarChartRodData(toY: entry.value.toDouble(), color: theme.colorScheme.primary, width: 20)],
        ),
      );
      lineSpots.add(FlSpot(i.toDouble(), cumulativeY));
    }

    void _captureAndSaveChart() async {
      try {
        RenderRepaintBoundary boundary = _chartKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
        var image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
        Uint8List pngBytes = byteData!.buffer.asUint8List();

        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/pareto_factores_riesgo.png').create();
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Análisis de Pareto de Factores de Riesgo'),
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
              speechText: 'Título: Factores de Riesgo Más Comunes',
              child: Text(
                'Factores de Riesgo Más Comunes',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
             _buildSpeakableWidget(context,
              speechText: 'Este gráfico muestra los factores de riesgo más frecuentes entre los estudiantes.',
              child: const Text('El gráfico muestra los factores de riesgo más frecuentes entre los estudiantes.'),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: studentProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : sortedRiskFactors.isEmpty
                      ? const Center(child: Text('No hay datos de factores de riesgo para mostrar.'))
                      : _buildSpeakableWidget(context, 
                        speechText: 'Gráfico de Pareto. Las barras son la frecuencia de cada factor, la línea es el acumulado.',
                        child: RepaintBoundary(
                            key: _chartKey,
                            child: Container(
                              color: isDarkMode ? Colors.black : Colors.white,
                              padding: const EdgeInsets.all(16.0),
                              child: Stack(
                                  children: [
                                    _buildBarChart(barGroups, maxCount, sortedRiskFactors, theme),
                                    _buildLineChart(lineSpots, maxCount, barGroups.length, isAchromatopsia, isRedGreenDeficiency, theme),
                                  ],
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

  Widget _buildBarChart(List<BarChartGroupData> barGroups, double maxCount, Map<String, int> sortedRiskFactors, ThemeData theme) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxCount * 1.2,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value.toInt() >= sortedRiskFactors.length) return const SizedBox.shrink();
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 4.0,
                  child: Text(sortedRiskFactors.keys.elementAt(value.toInt()), style: TextStyle(fontSize: 10, color: theme.colorScheme.onBackground)),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, interval: 1, getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: TextStyle(color: theme.colorScheme.onBackground, fontSize: 10)) )),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const Text('');
                final percentage = maxCount > 0 ? (value / maxCount) * 100 : 0.0;
                if (percentage.round() % 20 == 0 && percentage.round() <= 100) {
                  return Text('${percentage.round()}%', style: TextStyle(fontSize: 10, color: theme.colorScheme.onBackground));
                }
                return const Text('');
              },
            ),
          ),
        ),
        gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (value) => FlLine(color: theme.colorScheme.onSurface.withOpacity(0.1), strokeWidth: 0.8)),
        borderData: FlBorderData(show: true, border: Border.all(color: theme.colorScheme.onBackground, width: 1)),
        barGroups: barGroups,
      ),
    );
  }

  Widget _buildLineChart(List<FlSpot> lineSpots, double maxCount, int barGroupsLength, bool isAchromatopsia, bool isRedGreenDeficiency, ThemeData theme) {
    Color lineColor = Colors.red;
    if (isRedGreenDeficiency || isAchromatopsia) {
      lineColor = theme.colorScheme.secondary;
    }
    
    return LineChart(
      LineChartData(
        minY: 0,
        maxY: maxCount * 1.2,
        minX: -0.5,
        maxX: (barGroupsLength - 1).toDouble() + 0.5,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: lineSpots,
            isCurved: true,
            color: lineColor,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true, getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(radius: 4, color: lineColor, strokeColor: Colors.white, strokeWidth: 2)),
            dashArray: isAchromatopsia ? [5, 5] : null, // Línea punteada si hay acromatopsia
          ),
        ],
      ),
    );
  }
}
