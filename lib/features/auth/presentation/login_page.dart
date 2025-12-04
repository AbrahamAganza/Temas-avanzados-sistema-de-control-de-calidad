import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tads/core/routes.dart';
import 'package:tads/features/auth/controllers/login_controller.dart';
import 'package:tads/features/auth/widgets/login_form.dart';
import 'package:tads/providers/accessibility_text_provider.dart';
import 'package:tads/providers/auth_provider.dart';
import 'package:tads/shared/components/login_background.dart';
import 'package:tads/main.dart'; // Importar para acceder a routeObserver

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const String routeName = Routes.loginPage;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Suscribirse a los cambios de ruta
    routeObserver.subscribe(this, ModalRoute.of(context)!);
    // Establecer el texto la primera vez que se construye la página
    _updateAccessibilityText();
  }

  @override
  void dispose() {
    // Darse de baja del observador de rutas
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Este método se llama cuando la página vuelve a ser la superior de la pila (ej. al presionar 'atrás')
    _updateAccessibilityText();
    super.didPopNext();
  }
  
  void _updateAccessibilityText() {
    final accessibilityTextProvider = Provider.of<AccessibilityTextProvider>(context, listen: false);
    accessibilityTextProvider.setDescription(
      'Página de inicio de sesión. Ingrese su correo electrónico y contraseña en los campos correspondientes. Luego, presione el botón Iniciar sesión.'
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      body: LoginBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(35.0),
            child: AutofillGroup(
              child: ChangeNotifierProvider(
                create: (_) => LoginController(authProvider.authRepository, authProvider),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 32),
                      child: SvgPicture.asset(
                        'assets/logo_tec.svg',
                        colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.srcIn),
                      ),
                    ),
                    Text(
                      'Temas avanzados de desarrollo de software',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    LoginForm(
                      onLoginSuccess: (userId, token) async {
                        TextInput.finishAutofillContext();
                        context.go(Routes.dashboardPage);
                      },
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        text: 'Versión 1.0',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
