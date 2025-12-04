import 'package:tads/core/router.dart';
import 'package:tads/features/accessibility/presentation/providers/accessibility_provider.dart';
import 'package:tads/features/accessibility/presentation/widgets/accessibility_buttons.dart';
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
import 'package:tads/shared/theme/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

// Observador de rutas de Flutter
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

void main() async {
  try {
    await dotenv.load();

    WidgetsFlutterBinding.ensureInitialized();
    if (kDebugMode) {
      print('Inicializando...');
    }

    runApp(
      MultiProvider(
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
      ),
    );
  } catch (e, stackTrace) {
    if (kDebugMode) {
      print('Error en main: $e');
      print('StackTrace: $stackTrace');
    }

    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text('Error de inicialización'),
                SizedBox(height: 8),
                Text('$e', textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<GoRouter> _routerFuture;

  @override
  void initState() {
    super.initState();
    _routerFuture = createRouter(context);
  }

  ThemeData _getTheme(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDyslexiaFriendly = context.watch<DyslexiaFriendlyProvider>().isDyslexiaFriendly;
    final colorBlindMode = context.watch<ColorBlindnessProvider>().mode;

    bool isDarkMode = themeNotifier.themeMode == ThemeMode.dark;
    ThemeData baseTheme;

    // 1. Determinar el tema de COLOR base
    switch (colorBlindMode) {
      case ColorBlindMode.achromatopsia:
        baseTheme = isDarkMode ? AppTheme.achromatopsiaDarkTheme : AppTheme.achromatopsiaLightTheme;
        break;
      case ColorBlindMode.redGreenDeficiency:
        baseTheme = isDarkMode ? AppTheme.redGreenDeficiencyDarkTheme : AppTheme.redGreenDeficiencyLightTheme;
        break;
      case ColorBlindMode.none:
      default:
        baseTheme = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
    }

    // 2. Si el modo dislexia está activo, APLICA la fuente sobre el tema base
    if (isDyslexiaFriendly) {
      return baseTheme.copyWith(
        textTheme: isDarkMode
            ? AppTheme.dyslexiaFriendlyTextTheme.apply(bodyColor: Colors.white, displayColor: Colors.white)
            : AppTheme.dyslexiaFriendlyTextTheme,
      );
    }

    return baseTheme;
  }

  @override
  Widget build(BuildContext context) {
    final theme = _getTheme(context);

    return FutureBuilder<GoRouter>(
      future: _routerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Error al crear el router: ${snapshot.error}'),
              ),
            ),
          );
        }

        return MaterialApp.router(
          title: 'Temas avanzados de desarrollo de software',
          debugShowCheckedModeBanner: false,
          routerConfig: snapshot.data!,
          theme: theme.colorScheme.brightness == Brightness.light ? theme : AppTheme.lightTheme,
          darkTheme: theme.colorScheme.brightness == Brightness.dark ? theme : AppTheme.darkTheme,
          themeMode: Provider.of<ThemeNotifier>(context).themeMode,
          builder: (context, child) {
            final accessibilityProvider = Provider.of<AccessibilityProvider>(context);
            final accessibilityText = context.watch<AccessibilityTextProvider>().description;
            return Builder(
              builder: (context) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(accessibilityProvider.zoomLevel),
                  ),
                  child: Stack(
                    children: [
                      child!,
                      AccessibilityButtons(description: accessibilityText),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
