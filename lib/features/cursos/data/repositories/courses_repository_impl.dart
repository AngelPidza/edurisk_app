import '../../domain/entities/course_entity.dart';
import '../../domain/repositories/courses_repository.dart';
import '../models/course_model.dart';

class CoursesRepositoryImpl implements CoursesRepository {
  @override
  Future<List<CourseEntity>> getCourses() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      CourseModel(
        id: '7a',
        name: '7mo A',
        students: 28,
        riskScore: 35,
        riskColor: 'yellow',
      ),
      CourseModel(
        id: '7b',
        name: '7mo B',
        students: 30,
        riskScore: 22,
        riskColor: 'green',
      ),
      CourseModel(
        id: '8a',
        name: '8vo A',
        students: 25,
        riskScore: 48,
        riskColor: 'orange',
      ),
      CourseModel(
        id: '8b',
        name: '8vo B',
        students: 27,
        riskScore: 18,
        riskColor: 'green',
      ),
      CourseModel(
        id: '9a',
        name: '9no A',
        students: 26,
        riskScore: 52,
        riskColor: 'yellow',
      ),
      CourseModel(
        id: '9b',
        name: '9no B',
        students: 29,
        riskScore: 31,
        riskColor: 'yellow',
      ),
    ];
  }
}
