import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/config_repository.dart';
import '../models/profile_model.dart';

class ConfigRepositoryImpl implements ConfigRepository {
  @override
  Future<ProfileEntity> getProfile() async => const ProfileModel(
    name: 'María González',
    email: 'director@donbosco.edu',
    role: 'Director',
    phone: '+503 7777-7777',
  );
  @override
  Future<void> saveProfile(ProfileEntity profile) async =>
      Future.delayed(const Duration(milliseconds: 400));
}
