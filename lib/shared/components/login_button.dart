import 'package:flutter/material.dart';
import 'package:tads/shared/theme/colors.dart';

class LoginButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const LoginButton({super.key, required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: TADSColors.alt10,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          elevation: 0.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        child: child,
      ),
    );
  }
}