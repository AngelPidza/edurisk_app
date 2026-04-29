import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ActivityEntity extends Equatable {
  final String text;
  final String time;
  final Color color;
  const ActivityEntity({
    required this.text,
    required this.time,
    required this.color,
  });
  @override
  List<Object?> get props => [text, time];
}
