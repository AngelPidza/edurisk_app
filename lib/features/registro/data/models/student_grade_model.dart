import '../../domain/entities/student_grade_entity.dart';

class StudentGradeModel extends StudentGradeEntity {
  const StudentGradeModel({
    required super.id,
    required super.name,
    required super.course,
    super.parcial1,
    super.parcial2,
    super.asistencia,
    super.observacion,
  });
}
