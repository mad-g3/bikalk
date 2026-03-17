import 'package:equatable/equatable.dart';
import '../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// Checking if a session exists on app start
class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Authenticated extends AuthState {
  const Authenticated(this.user);

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

// Sign-up done but email not yet verified — user sits on verify-otp screen
class AwaitingEmailVerification extends AuthState {
  const AwaitingEmailVerification(this.user);

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

// Password reset email was sent successfully
class PasswordResetSent extends AuthState {
  const PasswordResetSent();
}
