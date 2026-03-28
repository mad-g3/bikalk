import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../app/di.dart';
import '../../../../app/routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/domain/bike_mode.dart';
import '../../../../core/widgets/continue_button.dart';
import '../../../../core/widgets/screen_heading.dart';
import '../../../../features/auth/application/auth_cubit.dart';
import '../../../../features/auth/application/auth_state.dart';
import '../../application/bike_selection_cubit.dart';
import '../../application/bike_selection_state.dart';
import '../widgets/bike_selection_card.dart';
import '../widgets/safety_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _applyPreferredBikeMode();
  }

  Future<void> _applyPreferredBikeMode() async {
    // Only apply the preference if the user hasn't made a selection yet
    if (sl<BikeSelectionCubit>().state is BikeSelectionUpdated) return;
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('preferred_bike_mode') ?? 'electric';
    final mode = saved == 'petrol' ? BikeMode.petrol : BikeMode.electric;
    sl<BikeSelectionCubit>().selectMode(mode);
  }

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
                final selectedMode = state is BikeSelectionUpdated
                    ? state.selectedMode
                    : null;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      ScreenHeading(
                        title: 'Choose your Bike',
                        showBackButton: false,
                        trailing: GestureDetector(
                          onTap: () => context.push(AppRoutes.profile),
                          child: BlocBuilder<AuthCubit, AuthState>(
                            bloc: sl<AuthCubit>(),
                            builder: (context, state) {
                              final initial =
                                  state is Authenticated &&
                                      state.user.name.isNotEmpty
                                  ? state.user.name[0].toUpperCase()
                                  : '?';
                              return CircleAvatar(
                                radius: 14,
                                backgroundColor: AppColors.ctaFill,
                                child: Text(
                                  initial,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                      BikeSelectionCard(
                        icon: Icons.bolt,
                        label: 'Electric',
                        selected: selectedMode == BikeMode.electric,
                        onTap: () => context
                            .read<BikeSelectionCubit>()
                            .selectMode(BikeMode.electric),
                      ),
                      const SizedBox(height: 20),
                      BikeSelectionCard(
                        icon: Icons.local_gas_station,
                        label: 'Petrol',
                        selected: selectedMode == BikeMode.petrol,
                        onTap: () => context
                            .read<BikeSelectionCubit>()
                            .selectMode(BikeMode.petrol),
                      ),
                      const SizedBox(height: 60),
                      const SafetySection(),
                      const SizedBox(height: 40),
                      ContinueButton(
                        onPressed: selectedMode != null
                            ? () => context.push(AppRoutes.destinationLocation)
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
