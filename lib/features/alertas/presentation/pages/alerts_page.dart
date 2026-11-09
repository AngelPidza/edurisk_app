import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/guidance.dart';
import '../../domain/entities/alert_entity.dart';
import '../providers/alerts_provider.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart'
    show AppTopBar;

class AlertsPage extends ConsumerWidget {
  const AlertsPage({super.key});

  Color _statusColor(String s) => switch (s) {
    'Pendiente' => AppTheme.accentRed,
    'En Atención' => AppTheme.accentYellow,
    _ => AppTheme.accentGreen,
  };

  Color _priorityColor(String p) => p.contains('Alta')
      ? AppTheme.accentOrange
      : p.contains('Media')
      ? AppTheme.accentYellow
      : AppTheme.accentGreen;

  /// Tocar una tarjeta filtra por su estado; tocarla de nuevo quita el filtro.
  void _toggleFilter(WidgetRef ref, String status) {
    final filter = ref.read(alertsFilterProvider.notifier);
    filter.state = filter.state == status ? 'Todos' : status;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allAlerts = ref.watch(alertsProvider);
    final filtered = ref.watch(filteredAlertsProvider);
    final currentFilter = ref.watch(alertsFilterProvider);

    return Scaffold(
      backgroundColor: AppTheme.bgBase,
      body: Column(
        children: [
          const AppTopBar(
            title: 'Alertas',
            description:
                'Estudiantes que necesitan seguimiento. Atiende primero las pendientes de prioridad alta.',
          ),
          Expanded(
            child: allAlerts.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text(
                  'Error: $e',
                  style: const TextStyle(color: AppTheme.accentRed),
                ),
              ),
              data: (all) {
                final pending = all
                    .where((a) => a.status == 'Pendiente')
                    .length;
                final inCare = all
                    .where((a) => a.status == 'En Atención')
                    .length;
                final resolved = all
                    .where((a) => a.status == 'Resuelta')
                    .length;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const HelpBanner(
                        id: 'alertas',
                        steps: [
                          'Cada alerta avisa que un estudiante necesita seguimiento. Su estado dice en qué va: «Pendiente» (nadie la atiende aún), «En Atención» (alguien hace el seguimiento) o «Resuelta» (cerrada).',
                          'Toca una de las tres tarjetas de arriba para ver solo las alertas de ese estado. Tócala otra vez para ver todas.',
                          'Empieza por las pendientes de prioridad alta.',
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _SummaryCard(
                              label: 'Pendientes',
                              value: pending,
                              color: AppTheme.accentRed,
                              icon: Icons.warning_amber_rounded,
                              selected: currentFilter == 'Pendiente',
                              onTap: () => _toggleFilter(ref, 'Pendiente'),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _SummaryCard(
                              label: 'En Atención',
                              value: inCare,
                              color: AppTheme.accentYellow,
                              icon: Icons.access_time_rounded,
                              selected: currentFilter == 'En Atención',
                              onTap: () => _toggleFilter(ref, 'En Atención'),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _SummaryCard(
                              label: 'Resueltas',
                              value: resolved,
                              color: AppTheme.accentGreen,
                              icon: Icons.check_circle_outline_rounded,
                              selected: currentFilter == 'Resuelta',
                              onTap: () => _toggleFilter(ref, 'Resuelta'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.bgCard,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.borderSubtle),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                24,
                                18,
                                24,
                                14,
                              ),
                              child: Row(
                                children: [
                                  const Text(
                                    'Todas las Alertas',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Text(
                                    'Filtrar por estado: ',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppTheme.textMuted,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.bgInput,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppTheme.border,
                                      ),
                                    ),
                                    child: DropdownButton<String>(
                                      value: currentFilter,
                                      underline: const SizedBox.shrink(),
                                      dropdownColor: AppTheme.bgCard,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppTheme.textPrimary,
                                      ),
                                      isDense: true,
                                      items:
                                          [
                                                'Todos',
                                                'Pendiente',
                                                'En Atención',
                                                'Resuelta',
                                              ]
                                              .map(
                                                (v) => DropdownMenuItem(
                                                  value: v,
                                                  child: Text(v),
                                                ),
                                              )
                                              .toList(),
                                      onChanged: (v) =>
                                          ref
                                                  .read(
                                                    alertsFilterProvider
                                                        .notifier,
                                                  )
                                                  .state =
                                              v!,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              color: AppTheme.borderSubtle,
                              height: 1,
                            ),
                            filtered.when(
                              loading: () => const Padding(
                                padding: EdgeInsets.all(24),
                                child: CircularProgressIndicator(),
                              ),
                              error: (e, _) => Text('$e'),
                              data: (list) => list.isEmpty
                                  ? EmptyState(
                                      icon: Icons.inbox_outlined,
                                      title: 'No hay alertas con este estado',
                                      message: currentFilter == 'Pendiente'
                                          ? 'Bien: no queda ninguna alerta sin atender.'
                                          : 'Prueba con otro estado o muestra todas.',
                                      actionLabel: 'Ver todas las alertas',
                                      onAction: () =>
                                          ref
                                                  .read(
                                                    alertsFilterProvider
                                                        .notifier,
                                                  )
                                                  .state =
                                              'Todos',
                                    )
                                  : Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            24,
                                            12,
                                            24,
                                            0,
                                          ),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              currentFilter == 'Todos'
                                                  ? 'Mostrando las ${all.length} alertas'
                                                  : 'Mostrando ${list.length} de ${all.length} alertas · estado «$currentFilter»',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: AppTheme.textMuted,
                                              ),
                                            ),
                                          ),
                                        ),
                                        ...list.map(
                                          (a) => _AlertRow(
                                            alert: a,
                                            statusColor: _statusColor(a.status),
                                            priorityColor: _priorityColor(
                                              a.priority,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: selected ? color.withOpacity(0.08) : AppTheme.bgCard,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: BorderSide(
        color: selected ? color : AppTheme.borderSubtle,
        width: selected ? 1.5 : 1,
      ),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: _content(),
    ),
  );

  Widget _content() => Padding(
    padding: const EdgeInsets.all(18),
    child: Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 4),
            Text(
              '$value',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: -1,
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
      ],
    ),
  );
}

class _AlertRow extends StatelessWidget {
  final AlertEntity alert;
  final Color statusColor;
  final Color priorityColor;
  const _AlertRow({
    required this.alert,
    required this.statusColor,
    required this.priorityColor,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: AppTheme.borderSubtle)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              alert.title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                alert.status,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ),
            Text(
              alert.priority,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: priorityColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          alert.student,
          style: const TextStyle(
            fontSize: 13,
            color: AppTheme.accentBlue,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          alert.description,
          style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Text(
              alert.date,
              style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
            ),
            if (alert.comments != null) ...[
              const SizedBox(width: 14),
              const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 12,
                color: AppTheme.textMuted,
              ),
              const SizedBox(width: 4),
              Text(
                alert.comments == 1
                    ? '1 comentario'
                    : '${alert.comments} comentarios',
                style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
              ),
            ],
          ],
        ),
      ],
    ),
  );
}
