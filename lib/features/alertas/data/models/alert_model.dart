import '../../domain/entities/alert_entity.dart';

class AlertModel extends AlertEntity {
  const AlertModel({
    required super.id,
    required super.title,
    required super.status,
    required super.priority,
    required super.student,
    required super.description,
    required super.date,
    super.comments,
  });
}
