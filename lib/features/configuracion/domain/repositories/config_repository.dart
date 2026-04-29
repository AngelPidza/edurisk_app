import '../entities/profile_entity.dart';

abstract class ConfigRepository {
  Future<ProfileEntity> getProfile();
  Future<void> saveProfile(ProfileEntity profile);
}
