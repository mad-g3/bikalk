import 'package:equatable/equatable.dart';

abstract class FeedbackState extends Equatable {
  const FeedbackState();

  @override
  List<Object?> get props => [];
}

class FeedbackInitial extends FeedbackState {
  const FeedbackInitial();
}

class FeedbackSubmitting extends FeedbackState {
  const FeedbackSubmitting();
}

class FeedbackSubmitSuccess extends FeedbackState {
  const FeedbackSubmitSuccess();
}

class FeedbackSubmitError extends FeedbackState {
  const FeedbackSubmitError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
