import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Wraps FirebaseAuth — only this class imports firebase_auth / google_sign_in
class FirebaseAuthSource {
  const FirebaseAuthSource(this._auth);

  final FirebaseAuth _auth;

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signUpWithEmail(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    final googleUser = await GoogleSignIn.instance.authenticate();
    final idToken = googleUser.authentication.idToken;
    final credential = GoogleAuthProvider.credential(idToken: idToken);
    return _auth.signInWithCredential(credential);
  }

  Future<void> updateDisplayName(String name) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'Cannot update display name: no signed-in user',
      );
    }
    await user.updateDisplayName(name);
  }

  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'Cannot send email verification: no signed-in user',
      );
    }
    await user.sendEmailVerification();
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await Future.wait([_auth.signOut(), GoogleSignIn.instance.signOut()]);
  }

  Future<void> reloadUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'Cannot reload user: no signed-in user',
      );
    }
    await user.reload();
  }
}
