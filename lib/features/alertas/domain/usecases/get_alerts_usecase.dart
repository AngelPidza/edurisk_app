import '../entities/alert_entity.dart';
import '../repositories/alerts_repository.dart';

class GetAlertsUseCase {
  final AlertsRepository repository;
  const GetAlertsUseCase(this.repository);
  Future<List<AlertEntity>> call() => repository.getAlerts();
}
