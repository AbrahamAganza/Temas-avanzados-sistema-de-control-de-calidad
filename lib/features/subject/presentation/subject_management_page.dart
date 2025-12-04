import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tads/providers/accessibility_text_provider.dart';
import 'package:tads/providers/subject_provider.dart';
import 'package:tads/providers/text_to_speech_provider.dart';
import 'package:tads/providers/voice_assistant_provider.dart';

class SubjectManagementPage extends StatefulWidget {
  const SubjectManagementPage({super.key});

  @override
  State<SubjectManagementPage> createState() => _SubjectManagementPageState();
}

class _SubjectManagementPageState extends State<SubjectManagementPage> {
  final _subjectNameController = TextEditingController();

  @override
  void dispose() {
    _subjectNameController.dispose();
    super.dispose();
  }

  void _addSubject() {
    if (_subjectNameController.text.isNotEmpty) {
      final subjectProvider = context.read<SubjectProvider>();
      subjectProvider.addSubject(_subjectNameController.text);

      if (context.read<VoiceAssistantProvider>().isEnabled) {
        context.read<TextToSpeechProvider>().speak('Materia ${_subjectNameController.text} añadida');
      }
      _subjectNameController.clear();
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
      'Página de gestión de materias. Use el campo de texto y el botón para añadir una nueva materia. Debajo, se muestra una lista de las materias existentes. Toque una materia de la lista para seleccionarla como la materia activa en toda la aplicación.'
    );

    final subjectProvider = context.watch<SubjectProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Materias'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSpeakableWidget(
              speechText: 'Campo para escribir el nombre de la nueva materia.',
              child: TextField(
                controller: _subjectNameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la Materia',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSpeakableWidget(
              speechText: 'Botón para añadir la materia escrita.',
              child: ElevatedButton(
                onPressed: _addSubject,
                child: const Text('Añadir Materia'),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: subjectProvider.subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjectProvider.subjects[index];
                  return _buildSpeakableWidget(
                    speechText: 'Materia: ${subject.name}. Tocar para seleccionar como materia activa.',
                    child: ListTile(
                      title: Text(subject.name),
                      subtitle: Text(subject.id),
                      onTap: () {
                        subjectProvider.selectSubject(subject.id);
                        if (context.read<VoiceAssistantProvider>().isEnabled) {
                           context.read<TextToSpeechProvider>().speak('Materia ${subject.name} seleccionada.');
                        }
                        Navigator.of(context).pop();
                      },
                      selected: subject.id == subjectProvider.selectedSubjectId,
                      selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
