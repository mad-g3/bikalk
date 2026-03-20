import 'package:equatable/equatable.dart';

import '../domain/entities/location_entity.dart';

/// Immutable state for [LocationCubit].
class LocationState extends Equatable {
  const LocationState({
    this.selectedLocation,
    this.searchResults = const [],
    this.isSearching = false,
    this.isDetecting = false,
    this.errorMessage,
  });

  /// The location the user has confirmed (via search selection, GPS, or map pin).
  final LocationEntity? selectedLocation;

  /// Live Nominatim suggestions shown while the user types.
  final List<LocationEntity> searchResults;

  /// True while a Nominatim search HTTP request is in flight.
  final bool isSearching;

  /// True while the device GPS position is being acquired.
  final bool isDetecting;

  /// Non-null when the last action produced an error the UI should display.
  final String? errorMessage;

  LocationState copyWith({
    LocationEntity? selectedLocation,
    List<LocationEntity>? searchResults,
    bool? isSearching,
    bool? isDetecting,
    String? errorMessage,
  }) {
    return LocationState(
      selectedLocation: selectedLocation ?? this.selectedLocation,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      isDetecting: isDetecting ?? this.isDetecting,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Returns a copy with [errorMessage] cleared to null.
  LocationState clearError() => LocationState(
    selectedLocation: selectedLocation,
    searchResults: searchResults,
    isSearching: isSearching,
    isDetecting: isDetecting,
  );

  @override
  List<Object?> get props => [
    selectedLocation,
    searchResults,
    isSearching,
    isDetecting,
    errorMessage,
  ];
}
