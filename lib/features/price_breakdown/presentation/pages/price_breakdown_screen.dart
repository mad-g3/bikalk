import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/screen_heading.dart';
import '../../../homeScreen/application/bike_selection_cubit.dart';
import '../../../homeScreen/application/bike_selection_state.dart';
import '../../../current_location/application/location_cubit.dart';
import '../../../current_location/application/current_location_state.dart';
import '../../../destinationLocation/application/destination_location_cubit.dart';
import '../../../destinationLocation/application/destination_location_state.dart';
import '../../application/price_breakdown_cubit.dart';
import '../../application/price_breakdown_state.dart';
import '../widgets/price_breakdown_error_body.dart';
import '../widgets/price_breakdown_loaded_body.dart';

class PriceBreakdownScreen extends StatefulWidget {
  const PriceBreakdownScreen({super.key});

  @override
  State<PriceBreakdownScreen> createState() => _PriceBreakdownScreenState();
}

class _PriceBreakdownScreenState extends State<PriceBreakdownScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _triggerCalculation();
    });
  }

  void _triggerCalculation() {
    final bikeState = sl<BikeSelectionCubit>().state;
    final locationState = sl<LocationCubit>().state;
    final destinationState = sl<DestinationLocationCubit>().state;

    if (bikeState is BikeSelectionUpdated &&
        locationState is CurrentLocationSelected &&
        destinationState is DestinationLocationSelected) {
      context.read<PriceBreakdownCubit>().calculate(
            bikeMode: bikeState.selectedMode,
            fromLat: locationState.lat,
            fromLng: locationState.lng,
            fromLabel: locationState.displayName,
            toLat: destinationState.lat,
            toLng: destinationState.lng,
            toLabel: destinationState.displayName,
          );
    } else {
      context.read<PriceBreakdownCubit>().calculate(
            bikeMode: (bikeState is BikeSelectionUpdated)
                ? bikeState.selectedMode
                : throw StateError('No bike selected'),
            fromLat: 0,
            fromLng: 0,
            fromLabel: '',
            toLat: 0,
            toLng: 0,
            toLabel: '',
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PriceBreakdownCubit, PriceBreakdownState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.scaffoldBg,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ScreenHeading(
                    title: 'Breakdown',
                    subtitle: 'Your fare estimate',
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: switch (state) {
                      PriceBreakdownLoading() => const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.ctaFill,
                          ),
                        ),
                      PriceBreakdownError(:final message) =>
                        PriceBreakdownErrorBody(
                          message: message,
                          onRetry: _triggerCalculation,
                        ),
                      PriceBreakdownLoaded() =>
                        PriceBreakdownLoadedBody(state: state),
                      _ => const SizedBox.shrink(),
                    },
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

// Provides PriceBreakdownCubit from DI for this screen
class PriceBreakdownScreenWrapper extends StatelessWidget {
  const PriceBreakdownScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PriceBreakdownCubit>(),
      child: const PriceBreakdownScreen(),
    );
  }
}
