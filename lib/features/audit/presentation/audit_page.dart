import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tads/providers/accessibility_text_provider.dart';
import 'package:tads/providers/audit_provider.dart';
import 'package:tads/providers/text_to_speech_provider.dart';
import 'package:tads/providers/voice_assistant_provider.dart';

class AuditPage extends StatelessWidget {
  const AuditPage({super.key});

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
      'Página de auditoría. Muestra un registro cronológico de todas las acciones importantes realizadas en el sistema, como la creación, actualización o eliminación de estudiantes. Cada entrada muestra la acción, el estudiante afectado y la fecha y hora del evento.'
    );

    final auditProvider = context.watch<AuditProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Auditoría'),
      ),
      body: auditProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: auditProvider.events.length,
              itemBuilder: (context, index) {
                final event = auditProvider.events[index];
                final speechText = 'Evento de ${event.action}. Estudiante: ${event.details['nombre'] ?? event.studentId}. Fecha: ${event.timestamp.toString().substring(0, 10)}';
                return _buildSpeakableWidget(
                  context,
                  speechText: speechText,
                  child: ListTile(
                    leading: _getIconForAction(event.action),
                    title: Text('${event.action}: ${event.details['nombre'] ?? event.studentId}'),
                    subtitle: Text('ID: ${event.studentId}'),
                    trailing: Text(event.timestamp.toString().substring(0, 16)),
                  ),
                );
              },
            ),
    );
  }

  Icon _getIconForAction(String action) {
    switch (action) {
      case 'Creación':
        return const Icon(Icons.add, color: Colors.green);
      case 'Actualización':
        return const Icon(Icons.edit, color: Colors.blue);
      case 'Eliminación':
        return const Icon(Icons.delete, color: Colors.red);
      default:
        return const Icon(Icons.history);
    }
  }
}
