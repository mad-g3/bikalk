import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

// Wraps Firestore for the users collection
class FirestoreUserSource {
  const FirestoreUserSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference get _users => _firestore.collection('users');

  Future<void> saveUser(UserModel user) {
    return _users.doc(user.userId).set(user.toMap());
  }

  Future<UserModel?> getUser(String userId) async {
    final doc = await _users.doc(userId).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  Future<void> updateEmailVerified(String userId, {required bool verified}) {
    return _users.doc(userId).update({'isEmailVerified': verified});
  }

  Future<void> updateName(String userId, String name) {
    return _users.doc(userId).update({'name': name});
  }

  Future<void> deleteUser(String userId) {
    return _users.doc(userId).delete();
  }
}
