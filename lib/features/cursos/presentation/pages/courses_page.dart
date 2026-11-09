import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/guidance.dart';
import '../../../registro/presentation/providers/registro_provider.dart';
import '../../domain/entities/course_entity.dart';
import '../providers/courses_provider.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart'
    show AppTopBar;

class CoursesPage extends ConsumerWidget {
  const CoursesPage({super.key});

  Color _color(String c) => switch (c) {
    'green' => AppTheme.accentGreen,
    'orange' => AppTheme.accentOrange,
    _ => AppTheme.accentYellow,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesProvider);
    final selected = ref.watch(selectedCourseProvider);

    return Scaffold(
      backgroundColor: AppTheme.bgBase,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppTopBar(
            title: 'Cursos',
            description:
                'Compara el nivel de riesgo de cada curso y entra al que necesites.',
          ),
          Expanded(
            child: coursesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text(
                  'Error: $e',
                  style: const TextStyle(color: AppTheme.accentRed),
                ),
              ),
              data: (courses) => SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HelpBanner(
                      id: 'cursos',
                      steps: [
                        'Cada tarjeta es un curso. El número de la derecha es su riesgo promedio (de 0 a 100): mientras más alto, más estudiantes necesitan apoyo.',
                        'Toca un curso para ver su detalle abajo.',
                        'Desde el detalle puedes ir a registrar sus calificaciones o a revisar sus alertas.',
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Cursos Disponibles',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const ColorLegend(
                      entries: [
                        LegendEntry(
                          AppTheme.accentGreen,
                          'Verde',
                          'riesgo bajo',
                        ),
                        LegendEntry(
                          AppTheme.accentYellow,
                          'Amarillo',
                          'conviene vigilar',
                        ),
                        LegendEntry(
                          AppTheme.accentOrange,
                          'Naranja',
                          'requiere atención',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 2.2,
                      children: courses
                          .map(
                            (c) => _CourseCard(
                              course: c,
                              isSelected: selected?.id == c.id,
                              color: _color(c.riskColor),
                              onTap: () =>
                                  ref
                                      .read(selectedCourseProvider.notifier)
                                      .state = selected?.id == c.id
                                  ? null
                                  : c,
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    _DetailPanel(course: selected),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final CourseEntity course;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;
  const _CourseCard({
    required this.course,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(onTap: onTap, child: _body()),
  );

  Widget _body() => AnimatedContainer(
    duration: const Duration(milliseconds: 150),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isSelected
          ? AppTheme.accentBlue.withOpacity(0.06)
          : AppTheme.bgCard,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: isSelected ? AppTheme.accentBlue : AppTheme.borderSubtle,
        width: isSelected ? 1.5 : 1,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        course.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 15,
                          color: AppTheme.accentBlue,
                        ),
                      ],
                    ],
                  ),
                  Text(
                    '${course.students} estudiantes',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // Riesgo promedio del curso, de 0 a 100.
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                '${course.riskScore}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: course.riskScore / 100,
                  backgroundColor: AppTheme.bgBase,
                  valueColor: AlwaysStoppedAnimation(color),
                  minHeight: 5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Riesgo',
              style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
            ),
          ],
        ),
      ],
    ),
  );
}

class _DetailPanel extends ConsumerWidget {
  final CourseEntity? course;
  const _DetailPanel({this.course});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: AppTheme.bgCard,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppTheme.borderSubtle),
    ),
    child: course == null
        ? const EmptyState(
            icon: Icons.touch_app_outlined,
            title: 'Ningún curso seleccionado',
            message:
                'Toca una de las tarjetas de arriba para ver aquí el detalle del curso.',
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${course!.name} — ${course!.students} estudiantes',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Puntuación de riesgo promedio: ${course!.riskScore} de 100',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                '¿Qué quieres hacer con este curso?',
                style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  SizedBox(
                    width: 300,
                    child: NextStepTile(
                      icon: Icons.edit_note_rounded,
                      color: AppTheme.accentBlue,
                      title: 'Registrar calificaciones',
                      subtitle: 'Abre el registro con ${course!.name} elegido',
                      onTap: () {
                        ref
                                .read(selectedCourseRegistroProvider.notifier)
                                .state =
                            course!.name;
                        context.go('/registro');
                      },
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: NextStepTile(
                      icon: Icons.notifications_active_outlined,
                      color: AppTheme.accentRed,
                      title: 'Revisar alertas',
                      subtitle: 'Estudiantes que necesitan seguimiento',
                      onTap: () => context.go('/alertas'),
                    ),
                  ),
                ],
              ),
            ],
          ),
  );
}
