import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/config_repository_impl.dart';
import '../../domain/repositories/config_repository.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/entities/profile_entity.dart';

final configRepositoryProvider = Provider<ConfigRepository>(
  (_) => ConfigRepositoryImpl(),
);

final getProfileUseCaseProvider = Provider<GetProfileUseCase>(
  (ref) => GetProfileUseCase(ref.read(configRepositoryProvider)),
);

final profileProvider = FutureProvider<ProfileEntity>((ref) {
  return ref.read(getProfileUseCaseProvider)();
});

// Active config tab
final configTabProvider = StateProvider<String>((_) => 'perfil');

// Editable profile fields
class ProfileFormNotifier extends StateNotifier<ProfileEntity?> {
  ProfileFormNotifier() : super(null);

  void init(ProfileEntity p) => state = p;

  void updateName(String v) => state = state?.copyWith(name: v);
  void updateEmail(String v) => state = state?.copyWith(email: v);
  void updatePhone(String v) => state = state?.copyWith(phone: v);
}

final profileFormProvider =
    StateNotifierProvider<ProfileFormNotifier, ProfileEntity?>(
      (_) => ProfileFormNotifier(),
    );

final profileSavedProvider = StateProvider<bool>((_) => false);
