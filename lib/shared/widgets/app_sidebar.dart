import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class _NavItem {
  final String label;
  final String path;
  final IconData icon;

  /// Qué se hace en esa pantalla; se muestra al pasar el puntero.
  final String hint;
  final int? badge;
  const _NavItem({
    required this.label,
    required this.path,
    required this.icon,
    required this.hint,
    this.badge,
  });
}

const _navItems = [
  _NavItem(
    label: 'Dashboard',
    path: '/',
    icon: Icons.grid_view_rounded,
    hint: 'Resumen del riesgo en el colegio',
  ),
  _NavItem(
    label: 'Cursos',
    path: '/cursos',
    icon: Icons.menu_book_rounded,
    hint: 'Riesgo promedio de cada curso',
  ),
  _NavItem(
    label: 'Alertas',
    path: '/alertas',
    icon: Icons.notifications_outlined,
    hint: 'Estudiantes que necesitan seguimiento',
    badge: 3,
  ),
  _NavItem(
    label: 'Registro Académico',
    path: '/registro',
    icon: Icons.description_outlined,
    hint: 'Cargar notas, asistencia y observaciones',
  ),
  _NavItem(
    label: 'Configuración',
    path: '/configuracion',
    icon: Icons.settings_outlined,
    hint: 'Tu perfil y preferencias',
  ),
];

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return Container(
      width: 210,
      color: AppTheme.bgSidebar,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.borderSubtle)),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.accentBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'DB',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EduRisk',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      'Don Bosco',
                      style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Nav
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: _navItems.map((item) {
                  final isActive =
                      location == item.path ||
                      (item.path != '/' && location.startsWith(item.path));
                  return _SidebarItem(item: item, isActive: isActive);
                }).toList(),
              ),
            ),
          ),

          // User
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppTheme.borderSubtle)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppTheme.accentPurple,
                        child: const Text(
                          'MG',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 9),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'María González',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            'Director',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                InkWell(
                  borderRadius: BorderRadius.circular(7),
                  onTap: () => context.go('/login'),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          size: 14,
                          color: AppTheme.textMuted,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Cerrar sesión',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  const _SidebarItem({required this.item, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: item.hint,
      waitDuration: const Duration(milliseconds: 500),
      preferBelow: false,
      child: _tile(context),
    );
  }

  Widget _tile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: isActive ? AppTheme.bgCard : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => context.go(item.path),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 10, 8),
            child: Row(
              children: [
                // Barra azul a la izquierda: marca la pantalla actual.
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 3,
                  height: 16,
                  margin: const EdgeInsets.only(right: 7),
                  decoration: BoxDecoration(
                    color: isActive ? AppTheme.accentBlue : Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Icon(
                  item.icon,
                  size: 16,
                  color: isActive
                      ? AppTheme.accentBlue
                      : AppTheme.textSecondary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive
                          ? AppTheme.textPrimary
                          : AppTheme.textSecondary,
                    ),
                  ),
                ),
                if (item.badge != null)
                  Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: AppTheme.accentRed,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${item.badge}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
