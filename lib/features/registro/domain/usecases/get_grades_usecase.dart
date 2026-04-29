import '../entities/student_grade_entity.dart';
import '../repositories/registro_repository.dart';

class GetGradesUseCase {
  final RegistroRepository repository;
  const GetGradesUseCase(this.repository);
  Future<List<StudentGradeEntity>> call(String course) =>
      repository.getGrades(course);
}
