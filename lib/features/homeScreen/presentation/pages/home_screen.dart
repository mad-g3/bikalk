import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/continue_button.dart';
import '../../../../app/di.dart';
import '../../../../app/routes.dart';
import 'package:go_router/go_router.dart';
import '../../application/bike_selection_cubit.dart';
import '../../application/bike_selection_state.dart';
import '../../domain/value_objects/bike_mode.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<BikeSelectionCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: BlocBuilder<BikeSelectionCubit, BikeSelectionState>(
              builder: (context, state) {
                final selectedMode =
                    state is BikeSelectionUpdated ? state.selectedMode : null;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    Center(
                      child: Text(
                        'Choose your Bike',
                        style: AppTextStyles.headlineMedium,
                      ),
                    ),
                    const SizedBox(height: 60),
                    _BikeSelectionCard(
                      icon: Icons.bolt,
                      label: 'Electric',
                      selected: selectedMode == BikeMode.electric,
                      onTap: () {
                        context
                            .read<BikeSelectionCubit>()
                            .selectMode(BikeMode.electric);
                      },
                    ),
                    const SizedBox(height: 20),
                    _BikeSelectionCard(
                      icon: Icons.local_gas_station,
                      label: 'Petrol',
                      selected: selectedMode == BikeMode.petrol,
                      onTap: () {
                        context
                            .read<BikeSelectionCubit>()
                            .selectMode(BikeMode.petrol);
                      },
                    ),
                    const Spacer(),
                    const _SafetySection(),
                    const SizedBox(height: 40),
                    ContinueButton(
                      onPressed: selectedMode != null
                          ? () {
                              context.push(AppRoutes.destinationLocation);
                            }
                          : null,
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _BikeSelectionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _BikeSelectionCard({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(20),
          border: selected
              ? Border.all(color: AppColors.brandRose, width: 2)
              : Border.all(color: Colors.transparent, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: AppColors.textPrimary),
            const SizedBox(height: 12),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SafetySection extends StatelessWidget {
  const _SafetySection();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Safety:',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        _SafetyListItem(text: 'Wear and secure your helmet'),
        _SafetyListItem(text: 'Drive at a safe speed'),
      ],
    );
  }
}

class _SafetyListItem extends StatelessWidget {
  final String text;

  const _SafetyListItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0, left: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 14)),
          Expanded(child: Text(text, style: AppTextStyles.bodySmall)),
        ],
      ),
    );
  }
}
