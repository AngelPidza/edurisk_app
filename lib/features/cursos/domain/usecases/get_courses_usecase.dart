import '../entities/course_entity.dart';
import '../repositories/courses_repository.dart';

class GetCoursesUseCase {
  final CoursesRepository repository;
  const GetCoursesUseCase(this.repository);
  Future<List<CourseEntity>> call() => repository.getCourses();
}
