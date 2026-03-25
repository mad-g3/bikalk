import 'package:equatable/equatable.dart';

const _notSet = Object();

class ReportProblemState extends Equatable {
  const ReportProblemState({
    this.selectedCategory,
    this.description = '',
    this.isSubmitting = false,
    this.errorMessage,
    this.successMessage,
  });

  final String? selectedCategory;
  final String description;
  final bool isSubmitting;
  final String? errorMessage;
  final String? successMessage;

  bool get canSubmit {
    return !isSubmitting &&
        selectedCategory != null &&
        description.trim().isNotEmpty;
  }

  ReportProblemState copyWith({
    Object? selectedCategory = _notSet,
    String? description,
    bool? isSubmitting,
    Object? errorMessage = _notSet,
    Object? successMessage = _notSet,
  }) {
    return ReportProblemState(
      selectedCategory: selectedCategory == _notSet
          ? this.selectedCategory
          : selectedCategory as String?,
      description: description ?? this.description,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage == _notSet
          ? this.errorMessage
          : errorMessage as String?,
      successMessage: successMessage == _notSet
          ? this.successMessage
          : successMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    selectedCategory,
    description,
    isSubmitting,
    errorMessage,
    successMessage,
  ];
}
