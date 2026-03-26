import 'package:equatable/equatable.dart';

import '../domain/entities/location_entity.dart';

abstract class CurrentLocationState extends Equatable {
  const CurrentLocationState();

  @override
  List<Object?> get props => [];
}

// Nothing selected yet
class CurrentLocationInitial extends CurrentLocationState {
  const CurrentLocationInitial();
}

// User is typing; holds live search results and a loading flag
class CurrentLocationSearchResults extends CurrentLocationState {
  const CurrentLocationSearchResults({
    required this.results,
    this.isSearching = false,
  });

  final List<LocationEntity> results;
  final bool isSearching;

  @override
  List<Object?> get props => [results, isSearching];
}

// GPS detection is in progress
class CurrentLocationDetecting extends CurrentLocationState {
  const CurrentLocationDetecting();
}

// User confirmed a location (from suggestion, GPS, or map long-press)
class CurrentLocationSelected extends CurrentLocationState {
  const CurrentLocationSelected({
    required this.displayName,
    required this.lat,
    required this.lng,
  });

  final String displayName;
  final double lat;
  final double lng;

  @override
  List<Object?> get props => [displayName, lat, lng];
}

// An error occurred that the UI should surface
class CurrentLocationError extends CurrentLocationState {
  const CurrentLocationError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
