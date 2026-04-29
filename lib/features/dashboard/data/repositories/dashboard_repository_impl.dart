import 'package:flutter/material.dart';
import '../../domain/entities/activity_entity.dart';
import '../../domain/entities/stat_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  @override
  Future<List<StatEntity>> getStats() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const [
      StatEntity(label: 'Estudiantes activos', value: 10, variant: 'default'),
      StatEntity(
        label: 'Riesgo alto',
        value: 4,
        percentage: '40%',
        variant: 'high',
      ),
      StatEntity(
        label: 'Riesgo medio',
        value: 3,
        percentage: '30%',
        variant: 'medium',
      ),
      StatEntity(
        label: 'Sin riesgo',
        value: 3,
        percentage: '30%',
        variant: 'safe',
      ),
    ];
  }

  @override
  Future<List<ActivityEntity>> getRecentActivity() async {
    return [
      ActivityEntity(
        text: 'Nueva alerta para Juan Pérez López',
        time: '2h',
        color: const Color(0xFFF25C54),
      ),
      ActivityEntity(
        text: 'Alerta de María Sánchez resuelta',
        time: '3h',
        color: const Color(0xFF4ADE80),
      ),
      ActivityEntity(
        text: 'Calificaciones actualizadas - 8vo A',
        time: '5h',
        color: const Color(0xFF4F8EF7),
      ),
      ActivityEntity(
        text: 'Predicción ML ejecutada - 7mo B',
        time: '1d',
        color: const Color(0xFFA78BFA),
      ),
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> getRiskTrend() async {
    return [
      {'label': 'Sem 1', 'value': 27.0},
      {'label': 'Sem 2', 'value': 28.0},
      {'label': 'Sem 3', 'value': 34.0},
      {'label': 'Sem 4', 'value': 31.0},
      {'label': 'Actual', 'value': 33.0},
    ];
  }
}
