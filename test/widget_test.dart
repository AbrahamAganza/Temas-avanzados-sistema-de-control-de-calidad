import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tads/main.dart';
import 'package:tads/providers/accessibility_text_provider.dart';
import 'package:tads/providers/auth_provider.dart';
import 'package:tads/providers/audit_provider.dart';
import 'package:tads/providers/color_blindness_provider.dart';
import 'package:tads/providers/dyslexia_friendly_provider.dart';
import 'package:tads/providers/route_notifier.dart';
import 'package:tads/providers/student_provider.dart';
import 'package:tads/providers/subject_provider.dart';
import 'package:tads/providers/text_to_speech_provider.dart';
import 'package:tads/providers/theme_notifier.dart';
import 'package:tads/providers/voice_assistant_provider.dart';
import 'package:tads/features/accessibility/presentation/providers/accessibility_provider.dart';

void main() {
  // Define una función para crear la app con todos sus proveedores
  Widget createTestApp() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RouteNotifier()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => AuditProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AccessibilityProvider()),
        ChangeNotifierProvider(create: (_) => AccessibilityTextProvider()),
        ChangeNotifierProvider(create: (_) => DyslexiaFriendlyProvider()),
        ChangeNotifierProvider(create: (_) => ColorBlindnessProvider()),
        ChangeNotifierProvider(create: (_) => TextToSpeechProvider()),
        ChangeNotifierProvider(create: (_) => VoiceAssistantProvider()),
        ChangeNotifierProxyProvider<AuthProvider, SubjectProvider>(
          create: (context) => SubjectProvider(null),
          update: (context, auth, previous) => SubjectProvider(auth.userId),
        ),
        ChangeNotifierProxyProvider2<AuditProvider, SubjectProvider, StudentProvider>(
          create: (context) => StudentProvider(),
          update: (context, auditProvider, subjectProvider, studentProvider) =>
              StudentProvider(auditProvider: auditProvider, subjectId: subjectProvider.selectedSubjectId, userId: subjectProvider.userId),
        ),
      ],
      child: const MyApp(),
    );
  }

  testWidgets('App starts and displays login page', (WidgetTester tester) async {
    // Usa la función para construir la app con el entorno de proveedores correcto
    await tester.pumpWidget(createTestApp());

    // Espera a que todas las animaciones y futuros (como el router) se completen
    await tester.pumpAndSettle();

    // Verifica que un elemento de la página de login (el campo de Email) esté presente
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
  });
}
