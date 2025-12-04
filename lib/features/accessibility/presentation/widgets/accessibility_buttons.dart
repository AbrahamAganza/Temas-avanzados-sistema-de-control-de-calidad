import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tads/features/accessibility/presentation/providers/accessibility_provider.dart';
import 'package:tads/providers/color_blindness_provider.dart';
import 'package:tads/providers/dyslexia_friendly_provider.dart';
import 'package:tads/providers/text_to_speech_provider.dart';
import 'package:tads/providers/theme_notifier.dart';
import 'package:tads/providers/voice_assistant_provider.dart';

class AccessibilityButtons extends StatefulWidget {
  final String description;
  const AccessibilityButtons({super.key, this.description = 'No hay descripción disponible para esta página.'});

  @override
  State<AccessibilityButtons> createState() => _AccessibilityButtonsState();
}

class _AccessibilityButtonsState extends State<AccessibilityButtons> with SingleTickerProviderStateMixin {
  bool _isMenuOpen = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
      if (_isMenuOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }
  
  void _speak(String text) {
    // Helper para no tener que escribir esto cada vez
    context.read<TextToSpeechProvider>().speak(text);
  }

  Widget _buildOptionButton({
    required String heroTag,
    required VoidCallback onPressed,
    required IconData icon,
    Color? activeColor,
  }) {
    return FloatingActionButton(
      heroTag: heroTag,
      mini: true,
      onPressed: onPressed,
      child: Icon(icon, color: activeColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accessibilityProvider = Provider.of<AccessibilityProvider>(context);
    final themeNotifier = context.watch<ThemeNotifier>();
    final dyslexiaFriendlyProvider = context.watch<DyslexiaFriendlyProvider>();
    final colorBlindnessProvider = context.watch<ColorBlindnessProvider>();
    final ttsProvider = context.watch<TextToSpeechProvider>();
    final voiceAssistantProvider = context.watch<VoiceAssistantProvider>();

    // Función unificada para manejar el feedback de voz
    void handlePress(VoidCallback action, String message) {
      action();
      if (voiceAssistantProvider.isEnabled) {
        _speak(message);
      }
    }

    return Positioned(
      bottom: 20,
      right: 20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizeTransition(
            sizeFactor: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                 _buildOptionButton(
                  heroTag: 'voice_assistant',
                  onPressed: () {
                    final bool isNowEnabled = !voiceAssistantProvider.isEnabled;
                    handlePress(
                      () => voiceAssistantProvider.toggle(), 
                      isNowEnabled ? 'Asistente de voz activado' : 'Asistente de voz desactivado'
                    );
                  },
                  icon: Icons.record_voice_over_rounded,
                  activeColor: voiceAssistantProvider.isEnabled ? Theme.of(context).colorScheme.primary : null,
                ),
                const SizedBox(height: 8),
                _buildOptionButton(
                  heroTag: 'text_to_speech',
                  onPressed: () => handlePress(() => ttsProvider.toggle(widget.description), 'Describiendo página'),
                  icon: ttsProvider.isSpeaking ? Icons.voice_over_off : Icons.volume_up,
                ),
                const SizedBox(height: 8),
                _buildOptionButton(
                  heroTag: 'zoom_out',
                  onPressed: () => handlePress(() => accessibilityProvider.zoomOut(), 'Reducir zoom'),
                  icon: Icons.zoom_out,
                ),
                 const SizedBox(height: 8),
                _buildOptionButton(
                  heroTag: 'zoom_in',
                  onPressed: () => handlePress(() => accessibilityProvider.zoomIn(), 'Aumentar zoom'),
                  icon: Icons.zoom_in,
                ),
                const SizedBox(height: 8),
                 _buildOptionButton(
                  heroTag: 'red_green_deficiency',
                  onPressed: () {
                     final isNowEnabled = colorBlindnessProvider.mode != ColorBlindMode.redGreenDeficiency;
                     handlePress(
                       () => colorBlindnessProvider.setMode(ColorBlindMode.redGreenDeficiency), 
                       isNowEnabled ? 'Modo para daltonismo rojo-verde activado' : 'Modo de color normal'
                    );
                  },
                  icon: Icons.color_lens,
                  activeColor: colorBlindnessProvider.mode == ColorBlindMode.redGreenDeficiency ? Theme.of(context).colorScheme.primary : null,
                ),
                const SizedBox(height: 8),
                 _buildOptionButton(
                  heroTag: 'achromatopsia',
                  onPressed: () {
                    final isNowEnabled = colorBlindnessProvider.mode != ColorBlindMode.achromatopsia;
                    handlePress(
                      () => colorBlindnessProvider.setMode(ColorBlindMode.achromatopsia), 
                      isNowEnabled ? 'Modo de escala de grises activado' : 'Modo de color normal'
                    );
                  },
                  icon: Icons.tonality,
                   activeColor: colorBlindnessProvider.mode == ColorBlindMode.achromatopsia ? Theme.of(context).colorScheme.secondary : null,
                ),
                const SizedBox(height: 8),
                _buildOptionButton(
                  heroTag: 'dyslexia_friendly',
                  onPressed: () {
                    final isNowEnabled = !dyslexiaFriendlyProvider.isDyslexiaFriendly;
                     handlePress(
                       () => dyslexiaFriendlyProvider.toggleDyslexiaFriendly(), 
                       isNowEnabled ? 'Fuente para dislexia activada' : 'Fuente normal activada'
                    );
                  },
                  icon: Icons.font_download,
                  activeColor: dyslexiaFriendlyProvider.isDyslexiaFriendly ? Theme.of(context).colorScheme.secondary : null,
                ),
                const SizedBox(height: 8),
                _buildOptionButton(
                  heroTag: 'theme_mode',
                  onPressed: () {
                     final isNowEnabled = themeNotifier.themeMode == ThemeMode.light;
                     handlePress(
                       () => themeNotifier.toggleTheme(), 
                       isNowEnabled ? 'Modo oscuro activado' : 'Modo claro activado'
                    );
                  },
                  icon: themeNotifier.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
                ),
                 const SizedBox(height: 16),
              ],
            ),
          ),
          FloatingActionButton(
            heroTag: 'main_accessibility_button',
            onPressed: _toggleMenu,
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _animation,
            ),
          ),
        ],
      ),
    );
  }
}
