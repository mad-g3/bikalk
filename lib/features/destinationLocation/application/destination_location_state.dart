import 'package:equatable/equatable.dart';

abstract class DestinationLocationState extends Equatable {
  const DestinationLocationState();

  @override
  List<Object?> get props => [];
}

/// Nothing has been selected yet
class DestinationLocationInitial extends DestinationLocationState {
  const DestinationLocationInitial();
}

/// The user has chosen a destination
class DestinationLocationSelected extends DestinationLocationState {
  const DestinationLocationSelected(
    this.destination, {
    this.lat,
    this.lng,
  });

  final String destination;
  final double? lat;
  final double? lng;

  @override
  List<Object?> get props => [destination, lat, lng];
}
