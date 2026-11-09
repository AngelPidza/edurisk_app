import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/guidance.dart';
import '../../domain/entities/activity_entity.dart';
import '../../domain/entities/stat_entity.dart';
import '../providers/dashboard_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsProvider);
    final activity = ref.watch(activityProvider);
    final trend = ref.watch(riskTrendProvider);

    return Scaffold(
      backgroundColor: AppTheme.bgBase,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppTopBar(
            title: 'Dashboard',
            description:
                'Resumen del colegio: cuántos estudiantes están en riesgo y qué pasó últimamente.',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const HelpBanner(
                    id: 'dashboard',
                    steps: [
                      'Mira las tarjetas de arriba: dicen cuántos estudiantes hay en cada nivel de riesgo. Deja el puntero (o mantén presionada) una tarjeta para ver qué significa.',
                      'Revisa la tendencia para saber si el riesgo sube o baja con las semanas.',
                      'Usa «Qué hacer ahora» para ir directo a las tareas pendientes.',
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Stats grid
                  stats.when(
                    loading: () => const SizedBox(
                      height: 100,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => Text(
                      'Error: $e',
                      style: const TextStyle(color: AppTheme.accentRed),
                    ),
                    data: (data) => GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 1.6,
                      children: data.map((s) => StatCard(stat: s)).toList(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Chart + Activity
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: trend.when(
                          loading: () => const SizedBox(
                            height: 240,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          error: (e, _) => Text('Error: $e'),
                          data: (data) => RiskChartCard(trend: data),
                        ),
                      ),
                      const SizedBox(width: 14),
                      SizedBox(
                        width: 260,
                        child: Column(
                          children: [
                            const NextStepsPanel(),
                            const SizedBox(height: 14),
                            activity.when(
                              loading: () => const SizedBox(
                                height: 240,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              error: (e, _) => Text('Error: $e'),
                              data: (data) => ActivityPanel(items: data),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Reusable widgets (también usados por otras páginas) ──────────────────────

class AppTopBar extends StatelessWidget {
  final String title;

  /// Una frase que dice para qué sirve la pantalla, para que el usuario sepa
  /// dónde está y qué puede hacer en ella.
  final String? description;
  const AppTopBar({super.key, required this.title, this.description});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekdays = [
      'lunes',
      'martes',
      'miércoles',
      'jueves',
      'viernes',
      'sábado',
      'domingo',
    ];
    final months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    final dateStr =
        '${weekdays[now.weekday - 1]}, ${now.day} de ${months[now.month - 1]}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    description!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: 2),
                Text(
                  dateStr,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // La campana lleva a Alertas; antes era solo decorativa.
          Tooltip(
            message: 'Ver alertas',
            child: InkWell(
              borderRadius: BorderRadius.circular(9),
              onTap: () => context.go('/alertas'),
              child: Stack(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppTheme.bgCard,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: AppTheme.borderSubtle),
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      size: 18,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  Positioned(
                    top: 7,
                    right: 8,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: AppTheme.accentRed,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.bgBase, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final StatEntity stat;
  const StatCard({super.key, required this.stat});

  Color get _color => switch (stat.variant) {
    'high' => AppTheme.accentRed,
    'medium' => AppTheme.accentYellow,
    'safe' => AppTheme.accentGreen,
    _ => AppTheme.accentBlue,
  };

  IconData get _icon => switch (stat.variant) {
    'high' => Icons.warning_amber_rounded,
    'medium' => Icons.trending_down_rounded,
    'safe' => Icons.check_circle_outline_rounded,
    _ => Icons.people_outline_rounded,
  };

  /// Qué significa cada tarjeta, en palabras simples.
  String get _meaning => switch (stat.variant) {
    'high' => 'Necesitan seguimiento cuanto antes. Revisa sus alertas.',
    'medium' => 'Muestran señales de alerta. Conviene vigilarlos.',
    'safe' => 'Su rendimiento está dentro de lo esperado.',
    _ => 'Total de estudiantes que se están siguiendo.',
  };

  @override
  Widget build(BuildContext context) => Tooltip(
    message: _meaning,
    waitDuration: const Duration(milliseconds: 400),
    child: _card(),
  );

  Widget _card() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppTheme.bgCard,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppTheme.borderSubtle),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: _color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(_icon, size: 16, color: _color),
            ),
            const Spacer(),
            if (stat.percentage != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: _color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  stat.percentage!,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _color,
                  ),
                ),
              ),
          ],
        ),
        const Spacer(),
        Text(
          '${stat.value}',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
            letterSpacing: -1,
          ),
        ),
        Text(
          stat.label,
          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
      ],
    ),
  );
}

class RiskChartCard extends StatelessWidget {
  final List<Map<String, dynamic>> trend;
  const RiskChartCard({super.key, required this.trend});

  @override
  Widget build(BuildContext context) {
    final spots = trend
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value['value'] as double))
        .toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tendencia de Riesgo',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const Text(
            'Evolución semanal de estudiantes en riesgo',
            style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => const FlLine(
                    color: AppTheme.borderSubtle,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (v, _) => Text(
                        '${v.toInt()}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: 1,
                      getTitlesWidget: (v, _) {
                        final i = v.toInt();
                        if (v == i.toDouble() && i >= 0 && i < trend.length)
                          return Text(
                            trend[i]['label'],
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppTheme.textMuted,
                            ),
                          );
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppTheme.accentBlue,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppTheme.accentBlue.withOpacity(0.3),
                          AppTheme.accentBlue.withOpacity(0.02),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Accesos a las tareas más comunes, para que el usuario no tenga que adivinar
/// en qué menú están.
class NextStepsPanel extends StatelessWidget {
  const NextStepsPanel({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
    decoration: BoxDecoration(
      color: AppTheme.bgCard,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppTheme.borderSubtle),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Qué hacer ahora',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 6),
        NextStepTile(
          icon: Icons.notifications_active_outlined,
          color: AppTheme.accentRed,
          title: 'Atender alertas',
          subtitle: 'Empieza por las pendientes',
          onTap: () => context.go('/alertas'),
        ),
        NextStepTile(
          icon: Icons.edit_note_rounded,
          color: AppTheme.accentBlue,
          title: 'Registrar calificaciones',
          subtitle: 'Notas, asistencia y observaciones',
          onTap: () => context.go('/registro'),
        ),
        NextStepTile(
          icon: Icons.menu_book_rounded,
          color: AppTheme.accentPurple,
          title: 'Revisar cursos',
          subtitle: 'Riesgo promedio de cada curso',
          onTap: () => context.go('/cursos'),
        ),
      ],
    ),
  );
}

class ActivityPanel extends StatelessWidget {
  final List<ActivityEntity> items;
  const ActivityPanel({super.key, required this.items});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppTheme.bgCard,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppTheme.borderSubtle),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.monitor_heart_outlined,
              size: 14,
              color: AppTheme.textSecondary,
            ),
            SizedBox(width: 8),
            Text(
              'Actividad Reciente',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...items.map(
          (a) => Container(
            padding: const EdgeInsets.symmetric(vertical: 11),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.borderSubtle)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: a.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a.text,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        a.time,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
