import 'dart:ui';
import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  final Widget? child;

  const LoginBackground({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final gradientColors = isDarkMode
        ? [
            const Color(0xFF232323),
            const Color(0xFF121212),
          ]
        : [
            const Color(0xFFE0EAFC),
            const Color(0xFFCFDEF3),
          ];

    final radialColor1 = isDarkMode ? const Color(0x88000000) : const Color(0x88FFFFFF);
    final radialColor2 = isDarkMode ? const Color(0x660D47A1) : const Color(0x664CB8FF);
    final radialColor3 = isDarkMode ? const Color(0x33000000) : const Color(0x3323455A);
    final blurColor = isDarkMode ? Colors.black.withOpacity(0.05) : Colors.white.withOpacity(0.05);


    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors,
            ),
          ),
        ),

        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(-0.8, -0.8),
              radius: 0.8,
              colors: [
                radialColor1,
                Colors.transparent,
              ],
              stops: const [0.0, 1.0],
            ),
          ),
        ),

        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(1.0, -0.6),
              radius: 1.0,
              colors: [
                radialColor2,
                Colors.transparent,
              ],
            ),
          ),
        ),

        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(1.1, 1.0),
              radius: 0.7,
              colors: [
                radialColor3,
                Colors.transparent,
              ],
            ),
          ),
        ),

        // Blur suave tipo glass
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            color: blurColor,
          ),
        ),

        if (child != null) child!,
      ],
    );
  }
}
