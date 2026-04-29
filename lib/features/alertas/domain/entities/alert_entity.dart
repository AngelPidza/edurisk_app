import 'package:equatable/equatable.dart';

class AlertEntity extends Equatable {
  final int id;
  final String title;
  final String status; // Pendiente | En Atención | Resuelta
  final String priority; // Prioridad Alta | Media | Baja
  final String student;
  final String description;
  final String date;
  final int? comments;
  const AlertEntity({
    required this.id,
    required this.title,
    required this.status,
    required this.priority,
    required this.student,
    required this.description,
    required this.date,
    this.comments,
  });
  @override
  List<Object?> get props => [id];
}
