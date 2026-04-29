import 'package:equatable/equatable.dart';

class StudentGradeEntity extends Equatable {
  final int id;
  final String name;
  final String course;
  final double? parcial1;
  final double? parcial2;
  final int? asistencia;
  final String observacion;
  const StudentGradeEntity({
    required this.id,
    required this.name,
    required this.course,
    this.parcial1,
    this.parcial2,
    this.asistencia,
    this.observacion = '',
  });
  StudentGradeEntity copyWith({
    double? parcial1,
    double? parcial2,
    int? asistencia,
    String? observacion,
  }) => StudentGradeEntity(
    id: id,
    name: name,
    course: course,
    parcial1: parcial1 ?? this.parcial1,
    parcial2: parcial2 ?? this.parcial2,
    asistencia: asistencia ?? this.asistencia,
    observacion: observacion ?? this.observacion,
  );
  @override
  List<Object?> get props => [id];
}
