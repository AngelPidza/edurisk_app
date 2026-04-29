import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<UserEntity> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Mock: accept any @donbosco.edu email
    if (!email.contains('@donbosco.edu'))
      throw Exception('Credenciales inválidas');
    return UserModel(name: 'María González', email: email, role: 'Director');
  }
}
