import '../../domain/entities/alert_entity.dart';
import '../../domain/repositories/alerts_repository.dart';
import '../models/alert_model.dart';

class AlertsRepositoryImpl implements AlertsRepository {
  @override
  Future<List<AlertEntity>> getAlerts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      AlertModel(
        id: 1,
        title: 'Riesgo Académico Alto',
        status: 'Pendiente',
        priority: 'Prioridad Alta',
        student: 'Juan Pérez López',
        description:
            'Estudiante con tendencia descendente en calificaciones y ausentismo creciente',
        date: '20 de abril de 2026, 10:30',
      ),
      AlertModel(
        id: 2,
        title: 'Ausentismo Crítico',
        status: 'En Atención',
        priority: 'Prioridad Alta',
        student: 'Laura Fernández Torres',
        description: 'Asistencia menor al 60% en las últimas 4 semanas',
        date: '18 de abril de 2026, 14:20',
        comments: 1,
      ),
      AlertModel(
        id: 3,
        title: 'Rendimiento Bajo',
        status: 'Pendiente',
        priority: 'Prioridad Alta',
        student: 'Roberto Jiménez Castro',
        description:
            'Promedio general por debajo de 5.0 en dos periodos consecutivos',
        date: '22 de abril de 2026, 08:45',
      ),
      AlertModel(
        id: 4,
        title: 'Riesgo Moderado',
        status: 'Resuelta',
        priority: 'Prioridad Media',
        student: 'María Sánchez Gómez',
        description: 'Descenso gradual en calificaciones de matemáticas',
        date: '15 de abril de 2026, 09:00',
      ),
    ];
  }
}
