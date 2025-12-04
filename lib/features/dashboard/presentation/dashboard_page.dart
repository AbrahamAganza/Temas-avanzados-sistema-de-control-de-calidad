import 'dart:io';
import 'dart:ui';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tads/core/routes.dart';
import 'package:tads/features/accessibility/presentation/providers/accessibility_provider.dart';
import 'package:tads/providers/accessibility_text_provider.dart';
import 'package:tads/providers/auth_provider.dart';
import 'package:tads/providers/student_provider.dart';
import 'package:tads/providers/subject_provider.dart';
import 'package:tads/providers/text_to_speech_provider.dart';
import 'package:tads/providers/voice_assistant_provider.dart';
import 'package:tads/main.dart'; // Importar para acceder a routeObserver

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with RouteAware {
  final GlobalKey _chartKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
    _updateAccessibilityText();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _updateAccessibilityText();
    super.didPopNext();
  }

  void _updateAccessibilityText() {
    final accessibilityTextProvider = Provider.of<AccessibilityTextProvider>(context, listen: false);
    accessibilityTextProvider.setDescription(
      'Página principal o Dashboard. Muestra un resumen de las estadísticas de la materia seleccionada, incluyendo el total de estudiantes, estudiantes en riesgo, y el promedio general. También se muestra una gráfica con la distribución de calificaciones. Usa el menú lateral para navegar a otras secciones.'
    );
  }

  void _captureAndSaveChart() async {
    try {
      RenderRepaintBoundary boundary = _chartKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await File('${directory.path}/grafico_distribucion.png').create();
      await imagePath.writeAsBytes(pngBytes);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gráfico guardado en: ${imagePath.path}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el gráfico: $e')),
      );
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
    final theme = Theme.of(context);
    final studentProvider = context.watch<StudentProvider>();
    final subjectProvider = context.watch<SubjectProvider>();
    final isDarkMode = theme.brightness == Brightness.dark;

    final gradeDistributionGroups = studentProvider.gradeDistribution.entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [BarChartRodData(toY: entry.value.toDouble(), color: isDarkMode ? Colors.white : theme.colorScheme.primary, width: 20)],
      );
    }).toList();

    return Scaffold(
      appBar: buildAppBar(context, theme, subjectProvider),
      drawer: buildDrawer(context, theme),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: subjectProvider.selectedSubjectId == null
          ? const Center(child: Text('Por favor, selecciona o crea una materia.'))
          : studentProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSpeakableWidget(
                          speechText: 'Bienvenido',
                          child: Text('BIENVENIDO', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 40),
                        _buildSpeakableWidget(
                          speechText: 'Total de estudiantes: ${studentProvider.totalStudents}',
                          child: buildStatisticRow('Total estudiantes', studentProvider.totalStudents.toString(), theme),
                        ),
                        const SizedBox(height: 15),
                        _buildSpeakableWidget(
                          speechText: 'Estudiantes en riesgo: ${studentProvider.atRiskStudents}',
                          child: buildStatisticRow('Estudiantes en Riesgo', studentProvider.atRiskStudents.toString(), theme),
                        ),
                        const SizedBox(height: 15),
                        _buildSpeakableWidget(
                          speechText: 'Promedio GPA: ${studentProvider.averageGpa.toStringAsFixed(2)}',
                          child: buildStatisticRow('Promedio GPA', studentProvider.averageGpa.toStringAsFixed(2), theme),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSpeakableWidget(
                              speechText: 'Gráfico de distribución de calificaciones promedio',
                              child: Text('Distribución de Calificaciones Promedio', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
                            ),
                            _buildSpeakableWidget(
                              speechText: 'Botón para compartir gráfico',
                              child: IconButton(
                                icon: const Icon(Icons.share),
                                onPressed: _captureAndSaveChart,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildSpeakableWidget(
                          speechText: 'Gráfico de barras que muestra la cantidad de estudiantes por rango de calificación.',
                          child: RepaintBoundary(
                            key: _chartKey,
                            child: Container(
                              color: isDarkMode ? Colors.black : Colors.white,
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                height: 300,
                                decoration: BoxDecoration(
                                  color: isDarkMode ? theme.cardColor.withOpacity(0.5) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: BarChart(
                                  BarChartData(
                                    alignment: BarChartAlignment.spaceAround,
                                    barTouchData: BarTouchData(enabled: false),
                                    titlesData: FlTitlesData(
                                      show: true,
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: (double value, TitleMeta meta) {
                                            final style = TextStyle(fontSize: 10, color: isDarkMode ? Colors.white : Colors.black);
                                            String text;
                                            switch (value.toInt()) {
                                              case 0: text = '<60'; break;
                                              case 1: text = '60-69'; break;
                                              case 2: text = '70-79'; break;
                                              case 3: text = '80-89'; break;
                                              case 4: text = '90-100'; break;
                                              default: text = ''; break;
                                            }
                                            return SideTitleWidget(axisSide: meta.axisSide, space: 4, child: Text(text, style: style));
                                          },
                                          reservedSize: 30,
                                        ),
                                      ),
                                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, interval: 1, getTitlesWidget: (value, meta) {
                                        return Text(value.toInt().toString(), style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: 10));
                                      })),
                                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    ),
                                    gridData: FlGridData(show: true, checkToShowHorizontalLine: (value) => value % 1 == 0, getDrawingHorizontalLine: (value) => FlLine(color: isDarkMode ? Colors.white24 : Colors.black26, strokeWidth: 0.8)),
                                    borderData: FlBorderData(show: false),
                                    barGroups: gradeDistributionGroups,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
    );
  }

  AppBar buildAppBar(BuildContext context, ThemeData theme, SubjectProvider subjectProvider) {
    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      title: _buildSpeakableWidget(
        speechText: 'Selector de materia. Materia actual: ${subjectProvider.subjects.firstWhere((s) => s.id == subjectProvider.selectedSubjectId, orElse: () => subjectProvider.subjects.first).name}',
        child: DropdownButton<String>(
          value: subjectProvider.selectedSubjectId,
          hint: const Text('Selecciona una materia'),
          onChanged: (String? newValue) {
            if (newValue != null) {
              subjectProvider.selectSubject(newValue);
            }
          },
          items: subjectProvider.subjects.map<DropdownMenuItem<String>>((subject) {
            return DropdownMenuItem<String>(
              value: subject.id,
              child: Text(subject.name),
            );
          }).toList(),
        ),
      ),
      centerTitle: false,
    );
  }

  Widget buildStatisticRow(String title, String value, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: theme.textTheme.titleMedium),
        Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
      ],
    );
  }

  Drawer buildDrawer(BuildContext context, ThemeData theme) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _buildSpeakableWidget(
            speechText: 'Menú principal',
            child: DrawerHeader(
              decoration: BoxDecoration(color: theme.appBarTheme.backgroundColor),
              child: Text('Menú Principal', style: theme.appBarTheme.titleTextStyle),
            ),
          ),
          _buildSpeakableWidget(
            speechText: 'Ir a gestionar materias',
            child: ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Gestionar Materias'),
              onTap: () => context.push(Routes.subjectManagementPage),
            ),
          ),
          const Divider(),
          _buildSpeakableWidget(
            speechText: 'Ir a registrar estudiante',
            child: ListTile(
              leading: const Icon(Icons.app_registration),
              title: const Text('Registrar Estudiante'),
              onTap: () => context.push(Routes.studentRegistrationPage),
            ),
          ),
          _buildSpeakableWidget(
            speechText: 'Ir a la lista detallada de alumnos',
            child: ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('Lista Detallada de Alumnos'),
              onTap: () => context.push(Routes.detailedStudentListPage),
            ),
          ),
          _buildSpeakableWidget(
            speechText: 'Ir a asistencias',
            child: ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: const Text('Asistencias'),
              onTap: () => context.push(Routes.attendancePage),
            ),
          ),
          _buildSpeakableWidget(
            speechText: 'Ir al Pareto de factores de riesgo',
            child: ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Pareto de Factores de Riesgo'),
              onTap: () => context.push(Routes.paretoAnalysisPage),
            ),
          ),
          _buildSpeakableWidget(
            speechText: 'Ir a la gráfica de dispersión',
            child: ListTile(
              leading: const Icon(Icons.scatter_plot),
              title: const Text('Dispersión'),
              onTap: () => context.push(Routes.dispersionDiagramPage),
            ),
          ),
          const Divider(),
          _buildSpeakableWidget(
            speechText: 'Ir a auditoría',
            child: ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Auditoría'),
              onTap: () => context.push(Routes.auditPage),
            ),
          ),
          _buildSpeakableWidget(
            speechText: 'Ir a exportar datos',
            child: ListTile(
              leading: const Icon(Icons.cloud_download),
              title: const Text('Exportar Datos'),
              onTap: () => context.push(Routes.exportDataPage),
            ),
          ),
          const Divider(),
          _buildSpeakableWidget(
            speechText: 'Cerrar sesión',
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar Sesión'),
              onTap: () async {
                final authProvider = context.read<AuthProvider>();
                await authProvider.logout();
                context.go(Routes.loginPage);
              },
            ),
          ),
          _buildSpeakableWidget(
            speechText: 'Ir a ajustes',
            child: ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Ajustes'),
              onTap: () => context.push(Routes.settingsPage),
            ),
          ),
        ],
      ),
    );
  }
}
