import '../entities/stat_entity.dart';
import '../entities/activity_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardUseCase {
  final DashboardRepository repository;
  const GetDashboardUseCase(this.repository);

  Future<List<StatEntity>> getStats() => repository.getStats();
  Future<List<ActivityEntity>> getActivity() => repository.getRecentActivity();
  Future<List<Map<String, dynamic>>> getRiskTrend() =>
      repository.getRiskTrend();
}
