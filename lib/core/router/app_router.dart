import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/cursos/presentation/pages/courses_page.dart';
import '../../features/alertas/presentation/pages/alerts_page.dart';
import '../../features/registro/presentation/pages/registro_page.dart';
import '../../features/configuracion/presentation/pages/config_page.dart';
import '../../shared/widgets/app_scaffold.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      ShellRoute(
        builder: (_, __, child) => AppScaffold(child: child),
        routes: [
          GoRoute(path: '/', builder: (_, __) => const DashboardPage()),
          GoRoute(path: '/cursos', builder: (_, __) => const CoursesPage()),
          GoRoute(path: '/alertas', builder: (_, __) => const AlertsPage()),
          GoRoute(path: '/registro', builder: (_, __) => const RegistroPage()),
          GoRoute(
            path: '/configuracion',
            builder: (_, __) => const ConfigPage(),
          ),
        ],
      ),
    ],
  );
}
