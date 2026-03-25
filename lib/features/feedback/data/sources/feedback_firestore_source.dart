import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/feedback_model.dart';

// Wraps Firebase SDKs for feedback persistence.
class FeedbackFirestoreSource {
  const FeedbackFirestoreSource(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _feedbacks =>
      _firestore.collection('reports');

  String? get currentUserId => _auth.currentUser?.uid;

  String? get currentUserEmail => _auth.currentUser?.email;

  Future<void> saveFeedback(FeedbackModel model) {
    return _feedbacks.add(model.toMap());
  }
}
