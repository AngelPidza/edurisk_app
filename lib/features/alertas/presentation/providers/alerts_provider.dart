import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/alerts_repository_impl.dart';
import '../../domain/repositories/alerts_repository.dart';
import '../../domain/usecases/get_alerts_usecase.dart';
import '../../domain/entities/alert_entity.dart';

final alertsRepositoryProvider = Provider<AlertsRepository>(
  (_) => AlertsRepositoryImpl(),
);

final alertsUseCaseProvider = Provider<GetAlertsUseCase>(
  (ref) => GetAlertsUseCase(ref.read(alertsRepositoryProvider)),
);

final alertsProvider = FutureProvider<List<AlertEntity>>((ref) {
  return ref.read(alertsUseCaseProvider)();
});

final alertsFilterProvider = StateProvider<String>((_) => 'Todos');

final filteredAlertsProvider = Provider<AsyncValue<List<AlertEntity>>>((ref) {
  final filter = ref.watch(alertsFilterProvider);
  final alerts = ref.watch(alertsProvider);
  return alerts.whenData(
    (list) => filter == 'Todos'
        ? list
        : list.where((a) => a.status == filter).toList(),
  );
});
