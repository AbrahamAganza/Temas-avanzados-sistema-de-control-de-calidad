import 'package:flutter/material.dart';

class NavigationTabs {
  const NavigationTabs({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

const navigationTabs = [
  NavigationTabs(label: 'Panel de control', icon: Icons.space_dashboard_rounded),
  NavigationTabs(label: 'Estadísticas', icon: Icons.query_stats_rounded),
  NavigationTabs(label: 'Ajustes', icon: Icons.settings),
];
