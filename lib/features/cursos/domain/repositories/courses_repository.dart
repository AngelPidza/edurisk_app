import '../entities/course_entity.dart';

abstract class CoursesRepository {
  Future<List<CourseEntity>> getCourses();
}
