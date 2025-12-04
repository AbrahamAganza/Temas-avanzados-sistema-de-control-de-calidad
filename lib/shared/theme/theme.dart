import 'package:flutter/material.dart';

class AppTheme {
  static final TextTheme _baseTextTheme = ThemeData.light().textTheme;

  static final TextTheme dyslexiaFriendlyTextTheme = _baseTextTheme.copyWith(
    displayLarge: _baseTextTheme.displayLarge?.copyWith(fontFamily: 'OpenDyslexic', letterSpacing: 0.5),
    displayMedium: _baseTextTheme.displayMedium?.copyWith(fontFamily: 'OpenDyslexic', letterSpacing: 0.5),
    displaySmall: _baseTextTheme.displaySmall?.copyWith(fontFamily: 'OpenDyslexic', letterSpacing: 0.5),
    headlineLarge: _baseTextTheme.headlineLarge?.copyWith(fontFamily: 'OpenDyslexic', letterSpacing: 0.5),
    headlineMedium: _baseTextTheme.headlineMedium?.copyWith(fontFamily: 'OpenDyslexic', letterSpacing: 0.5),
    headlineSmall: _baseTextTheme.headlineSmall?.copyWith(fontFamily: 'OpenDyslexic', letterSpacing: 0.5),
    titleLarge: _baseTextTheme.titleLarge?.copyWith(fontFamily: 'OpenDyslexic', letterSpacing: 0.5),
    titleMedium: _baseTextTheme.titleMedium?.copyWith(fontFamily: 'OpenDyslexic', letterSpacing: 0.5),
    titleSmall: _baseTextTheme.titleSmall?.copyWith(fontFamily: 'OpenDyslexic', letterSpacing: 0.5),
    bodyLarge: _baseTextTheme.bodyLarge?.copyWith(fontFamily: 'OpenDyslexic', letterSpacing: 0.5),
    bodyMedium: _baseTextTheme.bodyMedium?.copyWith(fontFamily: 'OpenDyslexic', letterSpacing: 0.5),
    bodySmall: _baseTextTheme.bodySmall?.copyWith(fontFamily: 'OpenDyslexic', letterSpacing: 0.5),
    labelLarge: _baseTextTheme.labelLarge?.copyWith(fontFamily: 'OpenDyslexic', letterSpacing: 0.5),
    labelMedium: _baseTextTheme.labelMedium?.copyWith(fontFamily: 'OpenDyslexic', letterSpacing: 0.5),
    labelSmall: _baseTextTheme.labelSmall?.copyWith(fontFamily: 'OpenDyslexic', letterSpacing: 0.5),
  );

  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        color: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actionsIconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        color: Color(0xFF121212),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white70,
        ),
      ),
    );
  }

  static ThemeData get dyslexiaFriendlyLightTheme {
    return lightTheme.copyWith(
      textTheme: dyslexiaFriendlyTextTheme,
    );
  }

  static ThemeData get dyslexiaFriendlyDarkTheme {
    return darkTheme.copyWith(
      textTheme: dyslexiaFriendlyTextTheme.apply(bodyColor: Colors.white, displayColor: Colors.white),
    );
  }

  static ThemeData get achromatopsiaLightTheme {
    return lightTheme.copyWith(
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: Colors.black,
        secondary: Colors.grey,
        surface: Colors.white,
        background: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.black,
        onBackground: Colors.black,
      ),
    );
  }

  static ThemeData get achromatopsiaDarkTheme {
    return darkTheme.copyWith(
      scaffoldBackgroundColor: const Color(0xFF121212),
       colorScheme: const ColorScheme.dark(
        primary: Colors.white,
        secondary: Colors.grey,
        surface: Color(0xFF121212),
        background: Color(0xFF121212),
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
      ),
    );
  }

  static ThemeData get redGreenDeficiencyLightTheme {
    return lightTheme.copyWith(
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF005ACD),
        secondary: Color(0xFFEDB900),
        surface: Colors.white,
        background: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.black,
        onBackground: Colors.black,
      ),
    );
  }

  static ThemeData get redGreenDeficiencyDarkTheme {
    return darkTheme.copyWith(
       colorScheme: const ColorScheme.dark(
        primary: Color(0xFF3C9BFF),
        secondary: Color(0xFFFFD640),
        surface: Color(0xFF121212),
        background: Color(0xFF121212),
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.white,
        onBackground: Colors.white,
      ),
    );
  }
}
