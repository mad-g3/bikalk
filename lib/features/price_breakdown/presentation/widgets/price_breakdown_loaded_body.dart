import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../app/routes.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../application/price_breakdown_state.dart';
import 'detail_row.dart';

class PriceBreakdownLoadedBody extends StatelessWidget {
  const PriceBreakdownLoadedBody({super.key, required this.state});

  final PriceBreakdownLoaded state;

  @override
  Widget build(BuildContext context) {
    final midLat = (state.fromLat + state.toLat) / 2;
    final midLng = (state.fromLng + state.toLng) / 2;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Map with from + to markers
          SizedBox(
            height: 180,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(midLat, midLng),
                  zoom: 13,
                ),
                myLocationButtonEnabled: false,
                mapToolbarEnabled: false,
                zoomControlsEnabled: false,
                markers: {
                  Marker(
                    markerId: const MarkerId('from'),
                    position: LatLng(state.fromLat, state.fromLng),
                    infoWindow: const InfoWindow(title: 'From'),
                  ),
                  Marker(
                    markerId: const MarkerId('to'),
                    position: LatLng(state.toLat, state.toLng),
                    infoWindow: const InfoWindow(title: 'To'),
                  ),
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Bike type badge
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: state.bikeType.toLowerCase() == 'electric'
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                state.bikeType.toLowerCase() == 'electric'
                    ? 'Electric'
                    : 'Petrol',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: state.bikeType.toLowerCase() == 'electric'
                      ? const Color(0xFF388E3C)
                      : const Color(0xFFE65100),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Avg price
          Text(
            '${state.avgFare.toStringAsFixed(0)} Rwf',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            'avg estimated fare',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
          ),

          const SizedBox(height: 20),

          // Flat detail rows
          DetailRow(
            leftLabel: 'from',
            leftValue: state.fromLabel,
            rightLabel: 'to',
            rightValue: state.toLabel,
          ),
          const SizedBox(height: 16),
          DetailRow(
            leftLabel: 'distance',
            leftValue: '${state.distanceKm.toStringAsFixed(1)} km',
            rightLabel: 'rate per km',
            rightValue: '${state.pricePerKm.toStringAsFixed(0)} Rwf',
          ),
          const SizedBox(height: 16),
          DetailRow(
            leftLabel: 'min price',
            leftValue: '${state.minFare.toStringAsFixed(0)} Rwf',
            rightLabel: 'max price',
            rightValue: '${state.maxFare.toStringAsFixed(0)} Rwf',
          ),
          if (state.fuelPerKm != null) ...[
            const SizedBox(height: 16),
            DetailRow(
              leftLabel: 'fuel per km',
              leftValue: '${state.fuelPerKm!.toStringAsFixed(2)} L',
              rightLabel: 'total fuel',
              rightValue:
                  '${(state.fuelPerKm! * state.distanceKm).toStringAsFixed(2)} L',
            ),
          ],

          const SizedBox(height: 24),

          // Actions
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.feedback),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.ctaFill,
              foregroundColor: AppColors.ctaText,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: const Text(
              'All Good',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => context.push(AppRoutes.reportProblem),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              backgroundColor: AppColors.secondaryFill,
              padding: const EdgeInsets.symmetric(vertical: 15),
              side: const BorderSide(color: AppColors.divider, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Report a Problem',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
