import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/courses_repository_impl.dart';
import '../../domain/repositories/courses_repository.dart';
import '../../domain/usecases/get_courses_usecase.dart';
import '../../domain/entities/course_entity.dart';

final coursesRepositoryProvider = Provider<CoursesRepository>(
  (_) => CoursesRepositoryImpl(),
);

final coursesUseCaseProvider = Provider<GetCoursesUseCase>(
  (ref) => GetCoursesUseCase(ref.read(coursesRepositoryProvider)),
);

final coursesProvider = FutureProvider<List<CourseEntity>>((ref) {
  return ref.read(coursesUseCaseProvider)();
});

final selectedCourseProvider = StateProvider<CourseEntity?>((_) => null);
