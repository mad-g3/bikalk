import '../entities/problem_report_entity.dart';

abstract class IProblemReportRepository {
  Future<void> submitProblem(ProblemReportEntity report);
}
