import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/repositories/i_auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthInitial());

  final IAuthRepository _repository;

  // Called on app start to restore an existing session
  Future<void> checkSession() async {
    emit(const AuthLoading());
    final (user, failure) = await _repository.getCurrentUser();
    if (failure != null) {
      emit(const Unauthenticated());
      return;
    }
    if (user == null) {
      emit(const Unauthenticated());
      return;
    }
    if (!user.isEmailVerified) {
      emit(AwaitingEmailVerification(user));
      return;
    }
    emit(Authenticated(user));
  }

  Future<void> signIn(String email, String password) async {
    emit(const AuthLoading());
    final (user, failure) = await _repository.signInWithEmail(email, password);
    if (failure != null) {
      emit(AuthError(failure.message));
      return;
    }
    if (user!.isEmailVerified) {
      emit(Authenticated(user));
    } else {
      emit(AwaitingEmailVerification(user));
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    emit(const AuthLoading());
    final (user, failure) = await _repository.signUpWithEmail(
      name: name,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
    );
    if (failure != null) {
      emit(AuthError(failure.message));
      return;
    }
    emit(AwaitingEmailVerification(user!));
  }

  // Polls Firebase to see if user has verified their email
  Future<void> checkEmailVerified() async {
    final (user, failure) = await _repository.getCurrentUser();
    if (failure != null || user == null) return;
    if (user.isEmailVerified) {
      emit(Authenticated(user));
    }
  }

  Future<void> resendVerificationEmail() async {
    final (_, failure) = await _repository.sendEmailVerification();
    if (failure != null) emit(AuthError(failure.message));
  }

  Future<void> sendPasswordReset(String email) async {
    emit(const AuthLoading());
    final (_, failure) = await _repository.sendPasswordResetEmail(email);
    if (failure != null) {
      emit(AuthError(failure.message));
      return;
    }
    emit(const PasswordResetSent());
  }

  Future<void> signOut() async {
    await _repository.signOut();
    emit(const Unauthenticated());
  }
}
