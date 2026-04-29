import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/usecases/get_dashboard_usecase.dart';
import '../../domain/entities/stat_entity.dart';
import '../../domain/entities/activity_entity.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>(
  (_) => DashboardRepositoryImpl(),
);

final dashboardUseCaseProvider = Provider<GetDashboardUseCase>(
  (ref) => GetDashboardUseCase(ref.read(dashboardRepositoryProvider)),
);

final statsProvider = FutureProvider<List<StatEntity>>((ref) {
  return ref.read(dashboardUseCaseProvider).getStats();
});

final activityProvider = FutureProvider<List<ActivityEntity>>((ref) {
  return ref.read(dashboardUseCaseProvider).getActivity();
});

final riskTrendProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.read(dashboardUseCaseProvider).getRiskTrend();
});
