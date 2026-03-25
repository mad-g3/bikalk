import '../../../../core/errors/failures.dart';

// Contract the application layer depends on.
abstract class IFeedbackRepository {
  Future<(bool, Failure?)> submitFeedback(String message);
}
