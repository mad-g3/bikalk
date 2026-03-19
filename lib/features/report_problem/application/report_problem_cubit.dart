import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors/failures.dart';
import '../domain/entities/problem_report_entity.dart';
import '../domain/repositories/i_problem_report_repository.dart';
import 'report_problem_state.dart';

class ReportProblemCubit extends Cubit<ReportProblemState> {
  ReportProblemCubit({
    required IProblemReportRepository repository,
    required FirebaseAuth firebaseAuth,
  }) : _repository = repository,
       _firebaseAuth = firebaseAuth,
       super(const ReportProblemState());

  final IProblemReportRepository _repository;
  final FirebaseAuth _firebaseAuth;

  void selectCategory(String? category) {
    emit(
      state.copyWith(
        selectedCategory: category,
        errorMessage: null,
        successMessage: null,
      ),
    );
  }

  void updateDescription(String description) {
    emit(
      state.copyWith(
        description: description,
        errorMessage: null,
        successMessage: null,
      ),
    );
  }

  Future<void> submitProblem() async {
    if (state.isSubmitting) return;

    final category = state.selectedCategory;
    final description = state.description.trim();

    if (category == null || category.isEmpty) {
      emit(state.copyWith(errorMessage: 'Please choose a category first.'));
      return;
    }

    if (description.isEmpty) {
      emit(state.copyWith(errorMessage: 'Please describe your problem.'));
      return;
    }

    final user = _firebaseAuth.currentUser;
    if (user == null) {
      emit(state.copyWith(errorMessage: 'Please sign in before reporting.'));
      return;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        errorMessage: null,
        successMessage: null,
      ),
    );

    try {
      await _repository.submitProblem(
        ProblemReportEntity(
          userId: user.uid,
          category: category,
          description: description,
        ),
      );

      emit(
        state.copyWith(
          selectedCategory: null,
          description: '',
          isSubmitting: false,
          successMessage: 'Report sent successfully.',
        ),
      );
    } on Failure catch (failure) {
      emit(state.copyWith(isSubmitting: false, errorMessage: failure.message));
    }
  }

  void clearMessages() {
    emit(state.copyWith(errorMessage: null, successMessage: null));
  }
}
