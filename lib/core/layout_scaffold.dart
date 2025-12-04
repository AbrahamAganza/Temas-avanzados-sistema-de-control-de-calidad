import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tads/models/navigation_tabs.dart';
import 'package:tads/shared/theme/colors.dart';

class LayoutScaffold extends StatefulWidget {
  const LayoutScaffold({required this.navigationShell, Key? key})
    : super(key: key ?? const ValueKey<String>('LayoutScaffold'));
  
  final StatefulNavigationShell navigationShell;

  @override
  State<LayoutScaffold> createState() => _LayoutScaffoldState();
}

class _LayoutScaffoldState extends State<LayoutScaffold>
    with WidgetsBindingObserver {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: widget.navigationShell,
    bottomNavigationBar: ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
      child: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: (index) {
          widget.navigationShell.goBranch(index);
        },
        indicatorShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        indicatorColor:
            TADSColors.accent, // Color del indicador del botón seleccionado
        backgroundColor:
            TADSColors.highlight, // Color de fondo de toda la navbar
        surfaceTintColor: Colors.transparent, // Quita el tinte de superficie
        shadowColor: TADSColors.surface, // Color de la sombra
        elevation: 8, // Elevación/sombra
        height: 70, // Altura de la navbar
        labelBehavior: NavigationDestinationLabelBehavior
            .alwaysShow, // Mostrar labels siempre
        destinations: navigationTabs
            .map(
              (destination) => NavigationDestination(
                icon: Icon(
                  destination.icon,
                  color:
                      TADSColors.surface, // Color de iconos no seleccionados
                ),
                label: destination.label,
                selectedIcon: Icon(
                  destination.icon,
                  color: TADSColors.highlight, // Color de icono seleccionado
                ),
              ),
            )
            .toList(),
      ),
    ),
  );
}
