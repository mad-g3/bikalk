import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/problem_report_entity.dart';

class ProblemReportModel extends ProblemReportEntity {
  const ProblemReportModel({
    required super.userId,
    required super.category,
    required super.description,
  });

  factory ProblemReportModel.fromEntity(ProblemReportEntity entity) {
    return ProblemReportModel(
      userId: entity.userId,
      category: entity.category,
      description: entity.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'category': category,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
