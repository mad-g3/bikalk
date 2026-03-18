import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  const FeedbackModel({
    required this.message,
    required this.userId,
    required this.userEmail,
  });

  final String message;
  final String? userId;
  final String? userEmail;

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'userId': userId,
      'userEmail': userEmail,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
