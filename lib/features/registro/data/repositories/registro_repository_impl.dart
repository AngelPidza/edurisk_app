import '../../domain/entities/student_grade_entity.dart';
import '../../domain/repositories/registro_repository.dart';
import '../models/student_grade_model.dart';

class RegistroRepositoryImpl implements RegistroRepository {
  static const _data = {
    '7mo A': [
      StudentGradeModel(
        id: 1,
        name: 'Juan Pérez López',
        course: '7mo A',
        parcial1: 5,
        parcial2: 6,
        asistencia: 65,
        observacion: 'Necesita mejorar',
      ),
      StudentGradeModel(
        id: 2,
        name: 'María Sánchez Gómez',
        course: '7mo A',
        parcial1: 5,
        parcial2: 5,
        asistencia: 78,
        observacion: 'Excelente',
      ),
    ],
    '7mo B': [
      StudentGradeModel(
        id: 3,
        name: 'Laura Fernández Torres',
        course: '7mo B',
        parcial1: 4,
        parcial2: 3,
        asistencia: 55,
        observacion: 'Ausentismo crítico',
      ),
      StudentGradeModel(
        id: 4,
        name: 'Andrés Molina Vega',
        course: '7mo B',
        parcial1: 8,
        parcial2: 9,
        asistencia: 95,
        observacion: 'Destacado',
      ),
    ],
  };

  @override
  Future<List<StudentGradeEntity>> getGrades(String course) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_data[course] ?? []);
  }
}
