import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../models/user_model.dart';
import '../sources/firebase_auth_source.dart';
import '../sources/firestore_user_source.dart';

// Implements the domain contract — the only place try/catch around Firebase lives
class AuthRepository implements IAuthRepository {
  const AuthRepository({required this.authSource, required this.userSource});

  final FirebaseAuthSource authSource;
  final FirestoreUserSource userSource;

  @override
  Future<(UserEntity?, Failure?)> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      final credential = await authSource.signInWithEmail(email, password);
      final firebase = credential.user!;
      await authSource.reloadUser();

      final stored = await userSource.getUser(firebase.uid);
      final model = stored ?? UserModel.fromFirebaseUser(firebase);
      return (model.toEntity(), null);
    } on FirebaseAuthException catch (e) {
      return (null, AuthFailure(_authMessage(e.code)));
    } catch (_) {
      return (null, const AuthFailure());
    }
  }

  @override
  Future<(UserEntity?, Failure?)> signUpWithEmail({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      final credential = await authSource.signUpWithEmail(email, password);
      final firebase = credential.user!;
      await authSource.updateDisplayName(name);

      final model = UserModel(
        userId: firebase.uid,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        isEmailVerified: false,
      );
      await userSource.saveUser(model);
      await authSource.sendEmailVerification();

      return (model.toEntity(), null);
    } on FirebaseAuthException catch (e) {
      return (null, AuthFailure(_authMessage(e.code)));
    } catch (_) {
      return (null, const AuthFailure());
    }
  }

  @override
  Future<(bool, Failure?)> sendPasswordResetEmail(String email) async {
    try {
      await authSource.sendPasswordResetEmail(email);
      return (true, null);
    } on FirebaseAuthException catch (e) {
      return (false, AuthFailure(_authMessage(e.code)));
    } catch (_) {
      return (false, const AuthFailure());
    }
  }

  @override
  Future<(bool, Failure?)> sendEmailVerification() async {
    try {
      await authSource.sendEmailVerification();
      return (true, null);
    } on FirebaseAuthException catch (e) {
      return (false, AuthFailure(_authMessage(e.code)));
    } catch (_) {
      return (false, const AuthFailure());
    }
  }

  @override
  Future<(UserEntity?, Failure?)> getCurrentUser() async {
    try {
      final firebase = authSource.currentUser;
      if (firebase == null) return (null, null);
      await authSource.reloadUser();

      final stored = await userSource.getUser(firebase.uid);
      final model = stored ?? UserModel.fromFirebaseUser(firebase);

      // sync email-verified flag in Firestore
      if (firebase.emailVerified && !model.isEmailVerified) {
        await userSource.updateEmailVerified(firebase.uid, verified: true);
      }

      return (model.toEntity(), null);
    } catch (_) {
      return (null, const ServerFailure());
    }
  }

  @override
  Future<(bool, Failure?)> signOut() async {
    try {
      await authSource.signOut();
      return (true, null);
    } catch (_) {
      return (false, const ServerFailure());
    }
  }

  // Maps Firebase error codes to friendly messages
  String _authMessage(String code) {
    return switch (code) {
      'user-not-found' => 'No account found for that email.',
      'wrong-password' ||
      'invalid-credential' => 'Incorrect email or password.',
      'email-already-in-use' => 'An account with that email already exists.',
      'weak-password' => 'Password must be at least 6 characters.',
      'invalid-email' => 'Enter a valid email address.',
      'too-many-requests' => 'Too many attempts. Try again later.',
      'network-request-failed' => 'Check your internet connection.',
      _ => 'An authentication error occurred.',
    };
  }
}
