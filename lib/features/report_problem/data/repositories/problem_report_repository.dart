import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/problem_report_entity.dart';
import '../../domain/repositories/i_problem_report_repository.dart';
import '../models/problem_report_model.dart';
import '../sources/problem_report_firestore_source.dart';

class ProblemReportRepository implements IProblemReportRepository {
  const ProblemReportRepository({required ProblemReportFirestoreSource source})
    : _source = source;

  final ProblemReportFirestoreSource _source;

  @override
  Future<void> submitProblem(ProblemReportEntity report) async {
    try {
      await _source.addProblem(ProblemReportModel.fromEntity(report));
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw const PermissionFailure(
          'You are not allowed to report problems right now.',
        );
      }
      throw const ServerFailure(
        'Failed to send your report. Please try again.',
      );
    } on Exception {
      throw const ServerFailure(
        'Failed to send your report. Please try again.',
      );
    }
  }
}
