import 'package:equatable/equatable.dart';

import '../../../core/domain/bike_mode.dart';

abstract class PriceBreakdownState extends Equatable {
  const PriceBreakdownState();

  @override
  List<Object?> get props => [];
}

class PriceBreakdownInitial extends PriceBreakdownState {
  const PriceBreakdownInitial();
}

class PriceBreakdownLoading extends PriceBreakdownState {
  const PriceBreakdownLoading();
}

class PriceBreakdownLoaded extends PriceBreakdownState {
  const PriceBreakdownLoaded({
    required this.bikeType,
    required this.fromLabel,
    required this.fromLat,
    required this.fromLng,
    required this.toLabel,
    required this.toLat,
    required this.toLng,
    required this.distanceKm,
    required this.pricePerKm,
    required this.minFare,
    required this.maxFare,
    required this.avgFare,
    this.fuelPerKm,
  });

  final BikeMode bikeType;
  final String fromLabel;
  final double fromLat;
  final double fromLng;
  final String toLabel;
  final double toLat;
  final double toLng;
  final double distanceKm;
  final double pricePerKm;
  final double minFare;
  final double maxFare;
  final double avgFare;
  final double? fuelPerKm;

  @override
  List<Object?> get props => [
        bikeType,
        fromLabel,
        fromLat,
        fromLng,
        toLabel,
        toLat,
        toLng,
        distanceKm,
        pricePerKm,
        minFare,
        maxFare,
        avgFare,
        fuelPerKm,
      ];
}

class PriceBreakdownError extends PriceBreakdownState {
  const PriceBreakdownError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
