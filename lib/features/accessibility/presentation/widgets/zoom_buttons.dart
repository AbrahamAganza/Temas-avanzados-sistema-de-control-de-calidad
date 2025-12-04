import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tads/features/accessibility/presentation/providers/accessibility_provider.dart';

class ZoomButtons extends StatelessWidget {
  const ZoomButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final accessibilityProvider = Provider.of<AccessibilityProvider>(context);
    return Positioned(
      bottom: 20,
      right: 20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'zoom_in',
            mini: true,
            onPressed: () => accessibilityProvider.zoomIn(),
            child: const Icon(Icons.zoom_in),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'zoom_out',
            mini: true,
            onPressed: () => accessibilityProvider.zoomOut(),
            child: const Icon(Icons.zoom_out),
          ),
        ],
      ),
    );
  }
}
