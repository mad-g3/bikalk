import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/domain/bike_mode.dart';
import '../../application/price_breakdown_cubit.dart';
import '../../application/price_breakdown_state.dart';

class BikeTypeBadge extends StatelessWidget {
  const BikeTypeBadge({super.key, required this.state});

  final PriceBreakdownLoaded state;

  @override
  Widget build(BuildContext context) {
    final isElectric = state.bikeType == BikeMode.electric;
    return GestureDetector(
      onTap: () {
        context.read<PriceBreakdownCubit>().calculate(
          bikeMode: isElectric ? BikeMode.petrol : BikeMode.electric,
          fromLat: state.fromLat,
          fromLng: state.fromLng,
          fromLabel: state.fromLabel,
          toLat: state.toLat,
          toLng: state.toLng,
          toLabel: state.toLabel,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: isElectric ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          isElectric ? 'Electric' : 'Petrol',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isElectric
                ? const Color(0xFF388E3C)
                : const Color(0xFFE65100),
          ),
        ),
      ),
    );
  }
}
