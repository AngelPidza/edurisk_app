import '../../domain/entities/course_entity.dart';

class CourseModel extends CourseEntity {
  const CourseModel({
    required super.id,
    required super.name,
    required super.students,
    required super.riskScore,
    required super.riskColor,
  });
}
