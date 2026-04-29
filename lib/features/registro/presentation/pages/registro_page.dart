import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
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

    // Load grades when course changes
    if (course != null) {
      ref.listen(gradesProvider(course), (_, next) {
        next.whenData(
          (grades) =>
              ref.read(gradesNotifierProvider.notifier).setGrades(grades),
        );
      });
    }

    final rows = ref.watch(gradesNotifierProvider);

    return Scaffold(
      backgroundColor: AppTheme.bgBase,
      body: Column(
        children: [
          const AppTopBar(title: 'Registro Académico'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
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
                        ? const Padding(
                            padding: EdgeInsets.all(52),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.menu_book_outlined,
                                    size: 48,
                                    color: AppTheme.textMuted,
                                  ),
                                  SizedBox(height: 14),
                                  Text(
                                    'Selecciona una materia y un curso para comenzar',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppTheme.textMuted,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
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
                                    ElevatedButton.icon(
                                      onPressed: () =>
                                          ref
                                                  .read(
                                                    gradeSavedProvider.notifier,
                                                  )
                                                  .state =
                                              true,
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
                                        'Parcial 1',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.textMuted,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        'Parcial 2',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.textMuted,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        'Asistencia (%)',
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
                                  index: e.key,
                                  row: e.value,
                                  onChanged: (i, updated) => ref
                                      .read(gradesNotifierProvider.notifier)
                                      .updateRow(i, updated),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  'Total de estudiantes: ${rows.length}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textMuted,
                                  ),
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

class _GradeRow extends StatefulWidget {
  final int index;
  final StudentGradeEntity row;
  final void Function(int, StudentGradeEntity) onChanged;
  const _GradeRow({
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

  Widget _numInput(TextEditingController ctrl) => Padding(
    padding: const EdgeInsets.only(right: 10),
    child: SizedBox(
      height: 36,
      child: TextField(
        controller: ctrl,
        onChanged: (_) => _notify(),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppTheme.bgInput,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
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
  );

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
              Text(
                widget.row.course,
                style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
              ),
            ],
          ),
        ),
        SizedBox(width: 100, child: _numInput(_p1)),
        SizedBox(width: 100, child: _numInput(_p2)),
        SizedBox(width: 120, child: _numInput(_as)),
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
