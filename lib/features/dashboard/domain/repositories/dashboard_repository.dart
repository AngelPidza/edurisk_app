import '../entities/stat_entity.dart';
import '../entities/activity_entity.dart';

abstract class DashboardRepository {
  Future<List<StatEntity>> getStats();
  Future<List<ActivityEntity>> getRecentActivity();
  Future<List<Map<String, dynamic>>> getRiskTrend();
}
