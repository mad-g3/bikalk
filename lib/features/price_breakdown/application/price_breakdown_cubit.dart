import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../features/homeScreen/domain/value_objects/bike_mode.dart';
import '../domain/repositories/i_fare_repository.dart';
import 'price_breakdown_state.dart';

class PriceBreakdownCubit extends Cubit<PriceBreakdownState> {
  PriceBreakdownCubit({required IFareRepository repository})
      : _repository = repository,
        super(const PriceBreakdownInitial());

  final IFareRepository _repository;

  Future<void> calculate({
    required BikeMode bikeMode,
    required double fromLat,
    required double fromLng,
    required String fromLabel,
    required double toLat,
    required double toLng,
    required String toLabel,
  }) async {
    emit(const PriceBreakdownLoading());
    try {
      final bikeType = bikeMode == BikeMode.electric ? 'Electric' : 'Petrol';
      final rate = await _repository.getFareRateByBikeType(bikeType);

      if (rate == null) {
        emit(const PriceBreakdownError(
          message: 'No fare data found for this bike type.',
        ));
        return;
      }

      final distanceMeters =
          Geolocator.distanceBetween(fromLat, fromLng, toLat, toLng);
      final distanceKm = distanceMeters / 1000;
      final range = rate.estimateRange(distanceKm);

      emit(PriceBreakdownLoaded(
        bikeType: bikeType,
        fromLabel: fromLabel,
        fromLat: fromLat,
        fromLng: fromLng,
        toLabel: toLabel,
        toLat: toLat,
        toLng: toLng,
        distanceKm: distanceKm,
        pricePerKm: rate.pricePerKm,
        minFare: range.min,
        maxFare: range.max,
        avgFare: range.avg,
        fuelPerKm: rate.fuelPerKm,
      ));
    } catch (_) {
      emit(const PriceBreakdownError(message: 'Failed to load fare data.'));
    }
  }
}
