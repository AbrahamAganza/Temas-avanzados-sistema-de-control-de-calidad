import 'package:tads/features/auth/controllers/login_controller.dart';
import 'package:tads/providers/auth_provider.dart';
import 'package:tads/providers/text_to_speech_provider.dart';
import 'package:tads/providers/voice_assistant_provider.dart';
import 'package:tads/shared/components/login_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  final Function(String userId, String token) onLoginSuccess;
  const LoginForm({super.key, required this.onLoginSuccess});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Widget auxiliar para envolver los campos de texto
  Widget _buildSpeakableWidget({required BuildContext context, required Widget child, required String speechText}) {
    final voiceAssistantProvider = context.watch<VoiceAssistantProvider>();
    final ttsProvider = context.read<TextToSpeechProvider>();

    return Listener(
      // El evento onPointerDown es una forma de bajo nivel para detectar un "toque"
      onPointerDown: (_) { // Usamos _ para ignorar los detalles del evento de puntero
        if (voiceAssistantProvider.isEnabled) {
          ttsProvider.speak(speechText);
        }
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LoginController>();
    final theme = Theme.of(context);

    final inputDecoration = InputDecoration(
      labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
      filled: true,
      fillColor: Colors.transparent,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.colorScheme.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.colorScheme.error, width: 2.0),
      ),
    );

    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (controller.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                controller.errorMessage!,
                style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.bold),
              ),
            ),
          _buildSpeakableWidget(
            context: context,
            speechText: 'Campo para ingresar el correo electrónico.',
            child: TextFormField(
              controller: _emailController,
              autofillHints: const [AutofillHints.email],
              decoration: inputDecoration.copyWith(labelText: 'Email'),
              style: TextStyle(color: theme.colorScheme.onSurface),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu email';
                }
                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value)) {
                  return 'Por favor ingresa un email válido';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildSpeakableWidget(
            context: context,
            speechText: 'Campo para ingresar la contraseña.',
            child: TextFormField(
              controller: _passwordController,
              autofillHints: const [AutofillHints.password],
              decoration: inputDecoration.copyWith(labelText: 'Contraseña'),
              style: TextStyle(color: theme.colorScheme.onSurface),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu contraseña';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildSpeakableWidget(
            context: context,
            speechText: 'Botón para iniciar sesión.',
            child: LoginButton(
              onPressed: controller.isLoading
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        final success = await controller.login(
                          _emailController.text.trim(),
                          _passwordController.text,
                        );
                        if (success) {
                          final authProvider = context.read<AuthProvider>();
                          if (authProvider.token != null && authProvider.userId != null) {
                            widget.onLoginSuccess(
                                authProvider.userId!, authProvider.token!);
                          }
                        }
                      }
                    },
              child: controller.isLoading
                  ? SizedBox(
                        height: 20.0,
                        width: 20.0,
                        child: CircularProgressIndicator(
                          color: theme.colorScheme.onPrimary,
                          strokeWidth: 4.0,
                        ),
                      )
                    : const Text('Iniciar sesión'),
            ),
          ),
        ],
      ),
    );
  }
}
