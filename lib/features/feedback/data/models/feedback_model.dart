import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  const FeedbackModel({
    required this.description,
    required this.userId,
    required this.type,
  });

  final String description;
  final String? userId;
  final String type;

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
