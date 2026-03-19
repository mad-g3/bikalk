import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors/failures.dart';
import '../domain/entities/location_entity.dart';
import '../domain/repositories/i_location_repository.dart';
import 'location_state.dart';

/// Manages all state for the current-location screen.
/// No Flutter widgets, no Firebase, no HTTP calls — only domain interfaces.
class LocationCubit extends Cubit<LocationState> {
  LocationCubit({required ILocationRepository repository})
    : _repository = repository,
      super(const LocationState());

  final ILocationRepository _repository;
  Timer? _searchDebounce;
  int _latestSearchToken = 0;

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  // ---------------------------------------------------------------------------
  // Search
  // ---------------------------------------------------------------------------

  /// Schedules a debounced Nominatim search for [query].
  /// Clears results immediately if [query] is too short.
  void scheduleSearch(String query) {
    _searchDebounce?.cancel();

    if (query.trim().length < 2) {
      emit(state.copyWith(searchResults: const [], isSearching: false));
      return;
    }

    emit(state.copyWith(isSearching: true));
    _latestSearchToken++;
    final currentToken = _latestSearchToken;
    _searchDebounce = Timer(
      const Duration(milliseconds: 400),
      () => _runSearch(query, currentToken),
    );
  }

  Future<void> _runSearch(String query, int token) async {
    try {
      final results = await _repository.searchLocations(query);
      // Ignore results from outdated searches.
      if (token != _latestSearchToken) return;
      emit(state.copyWith(searchResults: results, isSearching: false));
    } on Failure catch (f) {
      // Ignore errors from outdated searches.
      if (token != _latestSearchToken) return;
      emit(
        state
            .copyWith(searchResults: const [], isSearching: false)
            .copyWith(errorMessage: f.message),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // GPS detection
  // ---------------------------------------------------------------------------

  /// Asks for device GPS position and updates [selectedLocation].
  Future<void> detectLocation() async {
    emit(state.copyWith(isDetecting: true));
    try {
      final location = await _repository.detectCurrentLocation();
      emit(
        state.copyWith(
          selectedLocation: location,
          isDetecting: false,
          searchResults: const [],
        ),
      );
    } on Failure catch (f) {
      emit(
        state.copyWith(isDetecting: false).copyWith(errorMessage: f.message),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Selection / pinning
  // ---------------------------------------------------------------------------

  /// Confirms a [location] chosen from the search results list.
  void selectLocation(LocationEntity location) {
    emit(state.copyWith(selectedLocation: location, searchResults: const []));
  }

  /// Sets a location from a map long-press using raw [latitude] / [longitude].
  void pinLocation(double latitude, double longitude) {
    emit(
      state.copyWith(
        selectedLocation: LocationEntity(
          latitude: latitude,
          longitude: longitude,
          displayName:
              '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}',
        ),
        searchResults: const [],
      ),
    );
  }

  /// Clears the [searchResults] list (e.g. when the text field loses focus).
  void clearSearchResults() {
    emit(state.copyWith(searchResults: const []));
  }

  /// Clears the current [errorMessage] after it has been shown.
  void clearError() => emit(state.clearError());
}
