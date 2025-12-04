import 'package:tads/core/layout_scaffold.dart';
import 'package:tads/core/router_observer.dart';
import 'package:tads/core/routes.dart';
import 'package:tads/features/auth/presentation/login_page.dart';
import 'package:tads/features/dashboard/presentation/dashboard_page.dart';
import 'package:tads/features/analytics/presentation/analytics_page.dart';
import 'package:tads/features/settings/presentation/settings_page.dart';
import 'package:tads/features/student/presentation/student_registration_page.dart';
import 'package:tads/features/pareto/presentation/pareto_analysis_page.dart';
import 'package:tads/features/dispersion/presentation/dispersion_diagram_page.dart';
import 'package:tads/features/export/presentation/export_data_page.dart';
import 'package:tads/features/detailed_student_list/presentation/detailed_student_list_page.dart';
import 'package:tads/features/attendance/presentation/attendance_page.dart';
import 'package:tads/features/audit/presentation/audit_page.dart';
import 'package:tads/features/subject/presentation/subject_management_page.dart';
import 'package:tads/providers/auth_provider.dart';
import 'package:tads/providers/route_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:tads/main.dart'; // Importar para acceder a routeObserver

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<GoRouter> createRouter(BuildContext context) async {
  final routeNotifier = Provider.of<RouteNotifier>(context, listen: false);
  final authProvider = Provider.of<AuthProvider>(context, listen: false);

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: Routes.loginPage,
    observers: [MyRouterObserver(routeNotifier), routeObserver], // Añadir el observador aquí
    redirect: (context, state) async {
      final isLoginPage = state.matchedLocation == Routes.loginPage;
      final isLoggedIn = authProvider.isLoggedIn;
      
      if (!isLoggedIn && !isLoginPage) {
        return Routes.loginPage;
      }

      if (isLoggedIn && isLoginPage) {
        return Routes.dashboardPage;
      }

      return null;
    },
    routes: [
      GoRoute(path: Routes.loginPage, builder: (context, state) => const LoginPage()),
      GoRoute(
        path: Routes.studentRegistrationPage,
        builder: (context, state) => const StudentRegistrationPage(),
      ),
      GoRoute(
        path: Routes.paretoAnalysisPage,
        builder: (context, state) => const ParetoAnalysisPage(),
      ),
      GoRoute(
        path: Routes.dispersionDiagramPage,
        builder: (context, state) => const DispersionDiagramPage(),
      ),
      GoRoute(
        path: Routes.exportDataPage,
        builder: (context, state) => const ExportDataPage(),
      ),
       GoRoute(
        path: Routes.detailedStudentListPage,
        builder: (context, state) => const DetailedStudentListPage(),
      ),
      GoRoute(
        path: Routes.attendancePage,
        builder: (context, state) => const AttendancePage(),
      ),
      GoRoute(
        path: Routes.auditPage,
        builder: (context, state) => const AuditPage(),
      ),
      GoRoute(
        path: Routes.subjectManagementPage,
        builder: (context, state) => const SubjectManagementPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            LayoutScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.dashboardPage,
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.analyticsPage,
                builder: (context, state) => const AnalyticsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.settingsPage,
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
