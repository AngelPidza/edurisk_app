import 'package:equatable/equatable.dart';

class CourseEntity extends Equatable {
  final String id;
  final String name;
  final int students;
  final int riskScore;
  final String riskColor; // green | yellow | orange
  const CourseEntity({
    required this.id,
    required this.name,
    required this.students,
    required this.riskScore,
    required this.riskColor,
  });
  @override
  List<Object> get props => [id];
}
