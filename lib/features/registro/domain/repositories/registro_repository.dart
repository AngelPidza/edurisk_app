import '../entities/student_grade_entity.dart';

abstract class RegistroRepository {
  Future<List<StudentGradeEntity>> getGrades(String course);
}
