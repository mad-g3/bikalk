import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/screen_heading.dart';
import '../widgets/bike_selection_card.dart';
import '../widgets/safety_section.dart';
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

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40),
                      const ScreenHeading(
                        title: 'Choose your Bike',
                        showBackButton: false,
                      ),
                      const SizedBox(height: 60),
                      BikeSelectionCard(
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
                      BikeSelectionCard(
                        icon: Icons.local_gas_station,
                        label: 'Petrol',
                        selected: selectedMode == BikeMode.petrol,
                        onTap: () {
                          context
                              .read<BikeSelectionCubit>()
                              .selectMode(BikeMode.petrol);
                        },
                      ),
                      const SizedBox(height: 60),
                      const SafetySection(),
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
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}


