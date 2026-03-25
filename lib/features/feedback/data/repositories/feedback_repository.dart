import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/i_feedback_repository.dart';
import '../models/feedback_model.dart';
import '../sources/feedback_firestore_source.dart';

// Implements the domain contract and maps Firebase exceptions to failures.
class FeedbackRepository implements IFeedbackRepository {
  const FeedbackRepository({required this.source});

  final FeedbackFirestoreSource source;

  @override
  Future<(bool, Failure?)> submitFeedback(String message) async {
    final trimmed = message.trim();
    if (trimmed.isEmpty) {
      return (false, const ValidationFailure('Please enter your feedback.'));
    }

    try {
      final model = FeedbackModel(
        description: trimmed,
        userId: source.currentUserId,
        category: 'feedback',
      );
      await source.saveFeedback(model);
      return (true, null);
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        return (
          false,
          const PermissionFailure(
            'You do not have permission to submit feedback.',
          ),
        );
      }
      return (false, ServerFailure(_firebaseMessage(e.code)));
    } catch (_) {
      return (false, const ServerFailure('Failed to submit feedback.'));
    }
  }

  String _firebaseMessage(String code) {
    return switch (code) {
      'permission-denied' => 'You do not have permission to submit feedback.',
      'unavailable' => 'Service is temporarily unavailable. Try again shortly.',
      _ => 'Failed to submit feedback. Please try again.',
    };
  }
}
