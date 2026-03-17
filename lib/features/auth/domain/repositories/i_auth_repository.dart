import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

// Contract the application layer depends on
abstract class IAuthRepository {
  Future<(UserEntity?, Failure?)> signInWithEmail(
    String email,
    String password,
  );

  Future<(UserEntity?, Failure?)> signUpWithEmail({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  });

  Future<(bool, Failure?)> sendPasswordResetEmail(String email);

  Future<(bool, Failure?)> sendEmailVerification();

  Future<(UserEntity?, Failure?)> getCurrentUser();

  Future<(bool, Failure?)> signOut();
}
