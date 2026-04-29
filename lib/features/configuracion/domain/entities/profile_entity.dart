import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String name;
  final String email;
  final String role;
  final String phone;

  const ProfileEntity({
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
  });

  ProfileEntity copyWith({
    String? name,
    String? email,
    String? role,
    String? phone,
  }) => ProfileEntity(
    name: name ?? this.name,
    email: email ?? this.email,
    role: role ?? this.role,
    phone: phone ?? this.phone,
  );

  @override
  List<Object> get props => [email];
}
