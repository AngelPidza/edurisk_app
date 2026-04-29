import 'package:equatable/equatable.dart';

class StatEntity extends Equatable {
  final String label;
  final int value;
  final String? percentage;
  final String variant; // default | high | medium | safe
  const StatEntity({
    required this.label,
    required this.value,
    this.percentage,
    required this.variant,
  });
  @override
  List<Object?> get props => [label, value, percentage, variant];
}
