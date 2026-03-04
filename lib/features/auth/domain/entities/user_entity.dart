import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.userId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.isEmailVerified,
  });

  final String userId;
  final String name;
  final String email;
  final String phoneNumber;
  final bool isEmailVerified;

  @override
  List<Object?> get props => [
    userId,
    name,
    email,
    phoneNumber,
    isEmailVerified,
  ];
}
