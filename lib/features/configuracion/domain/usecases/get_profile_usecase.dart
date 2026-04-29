import '../entities/profile_entity.dart';
import '../repositories/config_repository.dart';

class GetProfileUseCase {
  final ConfigRepository repository;
  const GetProfileUseCase(this.repository);
  Future<ProfileEntity> call() => repository.getProfile();
}
