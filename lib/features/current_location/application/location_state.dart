import 'package:equatable/equatable.dart';

import '../domain/entities/location_entity.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

// Nothing selected yet
class LocationInitial extends LocationState {
  const LocationInitial();
}

// User is typing; holds live search results and a loading flag
class LocationSearchResults extends LocationState {
  const LocationSearchResults({
    required this.results,
    this.isSearching = false,
  });

  final List<LocationEntity> results;
  final bool isSearching;

  @override
  List<Object?> get props => [results, isSearching];
}

// GPS detection is in progress
class LocationDetecting extends LocationState {
  const LocationDetecting();
}

// User confirmed a location (from suggestion, GPS, or map long-press)
class LocationSelected extends LocationState {
  const LocationSelected({
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
class LocationError extends LocationState {
  const LocationError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
