import 'package:equatable/equatable.dart';

class ProblemReportEntity extends Equatable {
  const ProblemReportEntity({
    required this.userId,
    required this.category,
    required this.description,
  });

  final String userId;
  final String category;
  final String description;

  @override
  List<Object?> get props => [userId, category, description];
}
