import 'package:flutter_bloc/flutter_bloc.dart';
import 'feedback_state.dart';
import '../domain/repositories/i_feedback_repository.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  FeedbackCubit(this._repository) : super(const FeedbackInitial());

  final IFeedbackRepository _repository;

  Future<void> submitFeedback(String message) async {
    if (state is FeedbackSubmitting) return;

    emit(const FeedbackSubmitting());
    final (_, failure) = await _repository.submitFeedback(message);

    if (failure != null) {
      emit(FeedbackSubmitError(failure.message));
      return;
    }

    emit(const FeedbackSubmitSuccess());
  }
}
