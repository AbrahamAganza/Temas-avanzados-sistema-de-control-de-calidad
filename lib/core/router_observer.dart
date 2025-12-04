import 'package:flutter/material.dart';
import 'package:tads/providers/route_notifier.dart';

class MyRouterObserver extends NavigatorObserver {
  final RouteNotifier routeNotifier;
  MyRouterObserver(this.routeNotifier);

  @override
  void didPush(Route route, Route? previousRoute) {
    routeNotifier.updateRoute(
      route.settings.name ?? route.settings.arguments?.toString() ?? '/',
    );
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    routeNotifier.updateRoute(previousRoute?.settings.name ?? '/');
    super.didPop(route, previousRoute);
  }
}
