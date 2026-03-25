import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/problem_report_model.dart';

class ProblemReportFirestoreSource {
  const ProblemReportFirestoreSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _reports {
    return _firestore.collection('problem_reports');
  }

  Future<void> addProblem(ProblemReportModel report) {
    return _reports.add(report.toMap());
  }
}
