import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/guidance.dart';
import '../../domain/entities/student_grade_entity.dart';
import '../providers/registro_provider.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart'
    show AppTopBar;

class RegistroPage extends ConsumerWidget {
  const RegistroPage({super.key});

  static const _materias = [
    'Matemáticas',
    'Lenguaje',
    'Ciencias',
    'Historia',
    'Inglés',
  ];
  static const _courses = [
    '7mo A',
    '7mo B',
    '8vo A',
    '8vo B',
    '9no A',
    '9no B',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materia = ref.watch(selectedMateriaProvider);
    final course = ref.watch(selectedCourseRegistroProvider);
    final saved = ref.watch(gradeSavedProvider);
    final dirty = ref.watch(gradesDirtyProvider);

    // Carga las filas del curso elegido. Se compara con el curso ya cargado
    // para que, al volver a un curso visto antes (o llegar desde Cursos con
    // uno elegido), la tabla no quede con las filas de otro curso.
    if (course != null) {
      ref.watch(gradesProvider(course)).whenData((grades) {
        final notifier = ref.read(gradesNotifierProvider.notifier);
        if (notifier.loadedCourse != course) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => notifier.load(course, grades),
          );
        }
      });
    }

    final rows = ref.watch(gradesNotifierProvider);
    final rowsReady =
        course != null &&
        ref.read(gradesNotifierProvider.notifier).loadedCourse == course;

    return Scaffold(
      backgroundColor: AppTheme.bgBase,
      body: Column(
        children: [
          const AppTopBar(
            title: 'Registro Académico',
            description:
                'Carga las notas parciales, la asistencia y las observaciones de un curso.',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const HelpBanner(
                    id: 'registro',
                    steps: [
                      'Elige la materia y el curso. La tabla aparece cuando eliges los dos.',
                      'Escribe las notas de cada parcial (de 0 a 10) y la asistencia (de 0 a 100 %). Si un valor está fuera de rango, la casilla se pone en rojo.',
                      'Los cambios no se guardan solos: al terminar, presiona «Guardar Cambios».',
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Filter card
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: AppTheme.bgCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.borderSubtle),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Registro de Calificaciones',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        StepIndicator(
                          steps: [
                            GuideStep('Materia', done: materia != null),
                            GuideStep('Curso', done: course != null),
                            GuideStep('Calificaciones', done: dirty || saved),
                            GuideStep('Guardar', done: saved),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: _SelectField(
                                label: 'Seleccionar Materia',
                                icon: Icons.menu_book_outlined,
                                value: materia,
                                items: _materias,
                                hint: '-- Seleccione una materia --',
                                onChanged: (v) {
                                  ref
                                          .read(
                                            selectedMateriaProvider.notifier,
                                          )
                                          .state =
                                      v;
                                  ref.read(gradeSavedProvider.notifier).state =
                                      false;
                                  ref.read(gradesDirtyProvider.notifier).state =
                                      false;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _SelectField(
                                label: 'Seleccionar Curso',
                                icon: Icons.people_outline,
                                value: course,
                                items: _courses,
                                hint: '-- Seleccione un curso --',
                                onChanged: (v) {
                                  ref
                                          .read(
                                            selectedCourseRegistroProvider
                                                .notifier,
                                          )
                                          .state =
                                      v;
                                  ref.read(gradeSavedProvider.notifier).state =
                                      false;
                                  ref.read(gradesDirtyProvider.notifier).state =
                                      false;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Table card
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.bgCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.borderSubtle),
                    ),
                    child: (materia == null || course == null)
                        ? EmptyState(
                            icon: Icons.menu_book_outlined,
                            title: materia == null && course == null
                                ? 'Elige una materia y un curso'
                                : materia == null
                                ? 'Falta elegir la materia'
                                : 'Falta elegir el curso',
                            message:
                                'Usa las listas de arriba. Cuando elijas las dos, aquí aparecerá la lista de estudiantes para cargar sus notas.',
                          )
                        : !rowsReady
                        ? const Padding(
                            padding: EdgeInsets.all(40),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  22,
                                  16,
                                  22,
                                  14,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '$materia - $course',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                    const Spacer(),
                                    _SaveStatus(dirty: dirty, saved: saved),
                                    const SizedBox(width: 12),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        ref
                                                .read(
                                                  gradeSavedProvider.notifier,
                                                )
                                                .state =
                                            true;
                                        ref
                                                .read(
                                                  gradesDirtyProvider.notifier,
                                                )
                                                .state =
                                            false;
                                      },
                                      icon: Icon(
                                        saved
                                            ? Icons.check_rounded
                                            : Icons.save_outlined,
                                        size: 15,
                                      ),
                                      label: Text(
                                        saved ? 'Guardado' : 'Guardar Cambios',
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.accentBlue,
                                        foregroundColor: Colors.white,
                                        textStyle: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            9,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                color: AppTheme.borderSubtle,
                                height: 1,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 180,
                                      child: Text(
                                        'Estudiante',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.textMuted,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        'Parcial 1 (0–10)',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.textMuted,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        'Parcial 2 (0–10)',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.textMuted,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 140,
                                      child: Text(
                                        'Asistencia (0–100 %)',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.textMuted,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Observación',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.textMuted,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                color: AppTheme.borderSubtle,
                                height: 1,
                              ),
                              ...rows.asMap().entries.map(
                                (e) => _GradeRow(
                                  // La clave por estudiante evita que, al
                                  // cambiar de curso, una fila conserve lo
                                  // escrito para otro estudiante.
                                  key: ValueKey('$course-${e.value.id}'),
                                  index: e.key,
                                  row: e.value,
                                  onChanged: (i, updated) {
                                    ref
                                        .read(gradesNotifierProvider.notifier)
                                        .updateRow(i, updated);
                                    ref
                                            .read(gradesDirtyProvider.notifier)
                                            .state =
                                        true;
                                    ref
                                            .read(gradeSavedProvider.notifier)
                                            .state =
                                        false;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Text(
                                      'Total de estudiantes: ${rows.length}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.textMuted,
                                      ),
                                    ),
                                    const Spacer(),
                                    if (dirty)
                                      const Text(
                                        'Recuerda presionar «Guardar Cambios» antes de salir.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.accentYellow,
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
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectField extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? value;
  final List<String> items;
  final String hint;
  final ValueChanged<String?> onChanged;
  const _SelectField({
    required this.label,
    required this.icon,
    this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(icon, size: 13, color: AppTheme.textMuted),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
      const SizedBox(height: 7),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppTheme.bgInput,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: value != null ? AppTheme.accentBlue : AppTheme.border,
          ),
        ),
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
          ),
          isExpanded: true,
          underline: const SizedBox.shrink(),
          dropdownColor: AppTheme.bgCard,
          style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
          items: items
              .map((i) => DropdownMenuItem(value: i, child: Text(i)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    ],
  );
}

/// Dice, junto al botón de guardar, si hay cambios pendientes o si ya se
/// guardó, para que el usuario no salga creyendo que sus notas quedaron.
class _SaveStatus extends StatelessWidget {
  final bool dirty;
  final bool saved;
  const _SaveStatus({required this.dirty, required this.saved});

  @override
  Widget build(BuildContext context) {
    if (!dirty && !saved) return const SizedBox.shrink();
    final color = dirty ? AppTheme.accentYellow : AppTheme.accentGreen;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            dirty ? Icons.edit_outlined : Icons.cloud_done_outlined,
            size: 13,
            color: color,
          ),
          const SizedBox(width: 5),
          Text(
            dirty ? 'Cambios sin guardar' : 'Todo guardado',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _GradeRow extends StatefulWidget {
  final int index;
  final StudentGradeEntity row;
  final void Function(int, StudentGradeEntity) onChanged;
  const _GradeRow({
    super.key,
    required this.index,
    required this.row,
    required this.onChanged,
  });
  @override
  State<_GradeRow> createState() => _GradeRowState();
}

class _GradeRowState extends State<_GradeRow> {
  late final TextEditingController _p1, _p2, _as, _ob;

  @override
  void initState() {
    super.initState();
    _p1 = TextEditingController(text: widget.row.parcial1?.toString() ?? '');
    _p2 = TextEditingController(text: widget.row.parcial2?.toString() ?? '');
    _as = TextEditingController(text: widget.row.asistencia?.toString() ?? '');
    _ob = TextEditingController(text: widget.row.observacion);
  }

  @override
  void dispose() {
    _p1.dispose();
    _p2.dispose();
    _as.dispose();
    _ob.dispose();
    super.dispose();
  }

  void _notify() => widget.onChanged(
    widget.index,
    widget.row.copyWith(
      parcial1: double.tryParse(_p1.text),
      parcial2: double.tryParse(_p2.text),
      asistencia: int.tryParse(_as.text),
      observacion: _ob.text,
    ),
  );

  /// Un valor escrito que no es número o queda fuera de [0, max].
  bool _outOfRange(String text, double max) {
    final t = text.trim().replaceAll(',', '.');
    if (t.isEmpty) return false;
    final v = double.tryParse(t);
    return v == null || v < 0 || v > max;
  }

  Widget _numInput(TextEditingController ctrl, {required double max}) {
    final invalid = _outOfRange(ctrl.text, max);
    final edgeColor = invalid ? AppTheme.accentRed : AppTheme.border;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: SizedBox(
        height: 36,
        child: TextField(
          controller: ctrl,
          onChanged: (_) => setState(_notify),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: invalid ? AppTheme.accentRed : AppTheme.textPrimary,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: invalid
                ? AppTheme.accentRed.withOpacity(0.08)
                : AppTheme.bgInput,
            hintText: '—',
            hintStyle: const TextStyle(color: AppTheme.textMuted),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: edgeColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: edgeColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: invalid ? AppTheme.accentRed : AppTheme.accentBlue,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: AppTheme.borderSubtle)),
    ),
    child: Row(
      children: [
        SizedBox(
          width: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.row.name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              if (_outOfRange(_p1.text, 10) ||
                  _outOfRange(_p2.text, 10) ||
                  _outOfRange(_as.text, 100))
                const Text(
                  'Revisa los valores en rojo',
                  style: TextStyle(fontSize: 11, color: AppTheme.accentRed),
                )
              else
                Text(
                  widget.row.course,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(width: 100, child: _numInput(_p1, max: 10)),
        SizedBox(width: 100, child: _numInput(_p2, max: 10)),
        SizedBox(width: 140, child: _numInput(_as, max: 100)),
        Expanded(
          child: SizedBox(
            height: 36,
            child: TextField(
              controller: _ob,
              onChanged: (_) => _notify(),
              style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppTheme.bgInput,
                hintText: 'Sin observaciones',
                hintStyle: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 13,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.accentBlue),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
