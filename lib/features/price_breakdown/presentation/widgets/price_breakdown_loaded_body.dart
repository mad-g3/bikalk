import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../app/di.dart';
import '../../../../../app/routes.dart';
import '../../../../../core/services/preferences_service.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../../../../core/domain/bike_mode.dart';
import '../../../../core/widgets/continue_button.dart';
import '../../application/price_breakdown_state.dart';
import 'bike_type_badge.dart';
import 'detail_row.dart';

class PriceBreakdownLoadedBody extends StatefulWidget {
  const PriceBreakdownLoadedBody({super.key, required this.state});

  final PriceBreakdownLoaded state;

  @override
  State<PriceBreakdownLoadedBody> createState() =>
      _PriceBreakdownLoadedBodyState();
}

class _PriceBreakdownLoadedBodyState extends State<PriceBreakdownLoadedBody> {
  bool _useMiles = false;

  @override
  void initState() {
    super.initState();
    _useMiles = sl<PreferencesService>().getDistanceUnit() == 'mi';
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.state;
    final unitLabel = _useMiles ? 'mi' : 'km';

    // Display-only conversions (raw data always stored in km)
    final distanceDisplay = _useMiles ? s.distanceKm * 0.621371 : s.distanceKm;
    final rateDisplay = _useMiles ? s.pricePerKm * 1.60934 : s.pricePerKm;
    final fuelPerUnitDisplay = s.fuelPerKm != null
        ? (s.fuelPerKm! * (_useMiles ? 1.60934 : 1))
        : null;
    // Total consumption is a physical quantity — unchanged by unit display
    final totalFuel = s.fuelPerKm != null ? s.fuelPerKm! * s.distanceKm : null;

    final midLat = (s.fromLat + s.toLat) / 2;
    final midLng = (s.fromLng + s.toLng) / 2;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 200,
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
                    position: LatLng(s.fromLat, s.fromLng),
                    infoWindow: const InfoWindow(title: 'From'),
                  ),
                  Marker(
                    markerId: const MarkerId('to'),
                    position: LatLng(s.toLat, s.toLng),
                    infoWindow: const InfoWindow(title: 'To'),
                  ),
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          Align(
            alignment: Alignment.centerLeft,
            child: BikeTypeBadge(state: s),
          ),

          const SizedBox(height: 8),

          Text(
            '${s.avgFare.toStringAsFixed(0)} Rwf',
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

          DetailRow(
            leftLabel: 'from',
            leftValue: s.fromLabel,
            rightLabel: 'to',
            rightValue: s.toLabel,
          ),
          const SizedBox(height: 16),
          DetailRow(
            leftLabel: 'distance',
            leftValue: '${distanceDisplay.toStringAsFixed(1)} $unitLabel',
            rightLabel: 'rate per $unitLabel',
            rightValue: '${rateDisplay.toStringAsFixed(0)} Rwf',
          ),
          const SizedBox(height: 16),
          DetailRow(
            leftLabel: 'min price',
            leftValue: '${s.minFare.toStringAsFixed(0)} Rwf',
            rightLabel: 'max price',
            rightValue: '${s.maxFare.toStringAsFixed(0)} Rwf',
          ),
          if (fuelPerUnitDisplay != null && totalFuel != null) ...[
            const SizedBox(height: 16),
            if (s.bikeType == BikeMode.electric)
              DetailRow(
                leftLabel: 'charge per $unitLabel',
                leftValue: '${fuelPerUnitDisplay.toStringAsFixed(2)} kWh',
                rightLabel: 'total charge',
                rightValue: '${totalFuel.toStringAsFixed(2)} kWh',
              )
            else
              DetailRow(
                leftLabel: 'fuel per $unitLabel',
                leftValue: '${fuelPerUnitDisplay.toStringAsFixed(2)} L',
                rightLabel: 'total fuel',
                rightValue: '${totalFuel.toStringAsFixed(2)} L',
              ),
          ],

          const SizedBox(height: 24),

          ContinueButton(
            onPressed: () => context.go(AppRoutes.feedback),
            label: 'All Good',
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
