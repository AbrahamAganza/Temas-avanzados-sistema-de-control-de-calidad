import 'package:provider/provider.dart';
import 'package:tads/core/network/json_service.dart';
import 'package:tads/core/routes.dart';
import 'package:tads/features/auth/data_sources/auth_local_data_source.dart';
import 'package:tads/features/auth/data_sources/auth_remote_data_source.dart';
import 'package:tads/features/auth/repositories/auth_repository_impl.dart';
import 'package:tads/providers/accessibility_text_provider.dart';
import 'package:tads/providers/auth_provider.dart';
import 'package:tads/providers/theme_notifier.dart';
import 'package:tads/shared/theme/colors.dart';
import 'package:tads/features/auth/models/user_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  static const String routeName = Routes.settingsPage;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  AuthRepositoryImpl authRepository = AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSourceImpl(JsonService()),
    localDataSource: AuthLocalDataSourceImpl(),
  );

  User? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    user = await authRepository.localDataSource.getUserData();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> handleLogOut() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.logout();
    if (!mounted) return;
    context.go(Routes.loginPage);
  }

  @override
  Widget build(BuildContext context) {
    // Establece la descripción de accesibilidad para esta página.
    final accessibilityTextProvider = Provider.of<AccessibilityTextProvider>(context, listen: false);
    accessibilityTextProvider.setDescription(
      'Página de ajustes. Aquí puedes ver tu información de perfil, activar o desactivar el modo oscuro, y cerrar tu sesión en la aplicación.'
    );

    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TADSColors.highlight,
        title: const Text('Ajustes'),
        centerTitle: false,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: buildMainBody(themeNotifier),
            ),
    );
  }

  Widget buildMainBody(ThemeNotifier themeNotifier) {
    return Column(
      children: [
        // Perfil del usuario
        if (user != null) ...[
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(user!.avatar),
                  onBackgroundImageError: (_, _) => {},
                  child: user!.avatar.isEmpty
                      ? Icon(Icons.person, size: 30)
                      : null,
                ),
                SizedBox(width: 16),
                // Información del usuario
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user!.fullName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      SizedBox(height: 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
        SwitchListTile(
          title: const Text('Modo Oscuro'),
          value: themeNotifier.themeMode == ThemeMode.dark,
          onChanged: (value) {
            themeNotifier.toggleTheme();
          },
        ),

        if (kDebugMode) SizedBox(height: 20),

        SizedBox(height: 20),

        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Cerrar Sesión'),
                  content: Text('¿Estás seguro de que quieres cerrar sesión?'),
                  actions: [
                    TextButton(
                      child: Text('Cancelar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Cerrar Sesión'),
                      onPressed: () async {
                        await handleLogOut();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: TADSColors.alt9,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'Cerrar Sesión',
                style: TextStyle(
                  color: TADSColors.highlight,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: 50),
        Text(
          'TADS v1.0',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodySmall?.color,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
