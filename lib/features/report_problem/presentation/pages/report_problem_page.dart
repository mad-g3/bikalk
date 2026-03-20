import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../application/report_problem_cubit.dart';
import '../../application/report_problem_state.dart';

class ReportProblemPage extends StatelessWidget {
  const ReportProblemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ReportProblemCubit>(),
      child: const _ReportProblemView(),
    );
  }
}

class _ReportProblemView extends StatefulWidget {
  const _ReportProblemView();

  @override
  State<_ReportProblemView> createState() => _ReportProblemViewState();
}

class _ReportProblemViewState extends State<_ReportProblemView> {
  static const _categories = <String>[
    'Driver behavior',
    'App issue',
    'Payment issue',
    'Safety concern',
    'Other',
  ];

  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReportProblemCubit, ReportProblemState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.successMessage != current.successMessage ||
          previous.description != current.description,
      listener: (context, state) {
        if (_descriptionController.text != state.description) {
          _descriptionController.value = TextEditingValue(
            text: state.description,
            selection: TextSelection.collapsed(
              offset: state.description.length,
            ),
          );
        }

        final message = state.errorMessage ?? state.successMessage;
        if (message != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
          context.read<ReportProblemCubit>().clearMessages();
        }
      },
      builder: (context, state) {
        final cubit = context.read<ReportProblemCubit>();

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back, size: 30),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Report a Problem',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.titleLarge.copyWith(fontSize: 38),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tell us what went wrong so you can travel with confidence next time.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 28),
                  DropdownButtonFormField<String>(
                    key: ValueKey(state.selectedCategory),
                    initialValue: state.selectedCategory,
                    hint: const Text('Category'),
                    items: _categories
                        .map(
                          (category) => DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: state.isSubmitting ? null : cubit.selectCategory,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    decoration: const InputDecoration(),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _descriptionController,
                    minLines: 12,
                    maxLines: 12,
                    enabled: !state.isSubmitting,
                    onChanged: cubit.updateDescription,
                    decoration: const InputDecoration(
                      hintText: 'Please describe your problem here!',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: state.canSubmit ? cubit.submitProblem : null,
                    child: state.isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.ctaText,
                            ),
                          )
                        : const Text('Report'),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton(
                    onPressed: state.isSubmitting
                        ? null
                        : () => Navigator.of(context).maybePop(),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
