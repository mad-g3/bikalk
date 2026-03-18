import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  const FeedbackModel({
    required this.description,
    required this.userId,
    required this.category,
  });

  final String description;
  final String? userId;
  final String category;

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'category': category,
      'description': description,
      'reportedAt': FieldValue.serverTimestamp(),
    };
  }
}
