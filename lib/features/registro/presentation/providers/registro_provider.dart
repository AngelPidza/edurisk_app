import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/registro_repository_impl.dart';
import '../../domain/repositories/registro_repository.dart';
import '../../domain/usecases/get_grades_usecase.dart';
import '../../domain/entities/student_grade_entity.dart';

final registroRepositoryProvider = Provider<RegistroRepository>(
  (_) => RegistroRepositoryImpl(),
);

final registroUseCaseProvider = Provider<GetGradesUseCase>(
  (ref) => GetGradesUseCase(ref.read(registroRepositoryProvider)),
);

final selectedMateriaProvider = StateProvider<String?>((_) => null);
final selectedCourseRegistroProvider = StateProvider<String?>((_) => null);

final gradesProvider = FutureProvider.family<List<StudentGradeEntity>, String>((
  ref,
  course,
) {
  return ref.read(registroUseCaseProvider)(course);
});

// Editable local copy
class GradesNotifier extends StateNotifier<List<StudentGradeEntity>> {
  GradesNotifier() : super([]);

  void setGrades(List<StudentGradeEntity> grades) => state = List.from(grades);

  void updateRow(int index, StudentGradeEntity updated) {
    final copy = List<StudentGradeEntity>.from(state);
    copy[index] = updated;
    state = copy;
  }
}

final gradesNotifierProvider =
    StateNotifierProvider<GradesNotifier, List<StudentGradeEntity>>(
      (_) => GradesNotifier(),
    );

final gradeSavedProvider = StateProvider<bool>((_) => false);
