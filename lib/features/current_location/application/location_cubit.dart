import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors/failures.dart';
import '../domain/entities/location_entity.dart';
import '../domain/repositories/i_location_repository.dart';
import 'current_location_state.dart';

class LocationCubit extends Cubit<CurrentLocationState> {
  LocationCubit({required ILocationRepository repository})
    : _repository = repository,
      super(const CurrentLocationInitial());

  final ILocationRepository _repository;
  Timer? _searchDebounce;
  int _latestSearchToken = 0;

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  // Debounces Nominatim search; clears to initial if query is too short
  void scheduleSearch(String query) {
    _searchDebounce?.cancel();

    if (query.trim().length < 2) {
      emit(const CurrentLocationInitial());
      return;
    }

    emit(const CurrentLocationSearchResults(results: [], isSearching: true));
    _latestSearchToken++;
    final token = _latestSearchToken;
    _searchDebounce = Timer(
      const Duration(milliseconds: 400),
      () => _runSearch(query, token),
    );
  }

  Future<void> _runSearch(String query, int token) async {
    try {
      final results = await _repository.searchLocations(query);
      if (token != _latestSearchToken) return;
      emit(CurrentLocationSearchResults(results: results));
    } on Failure catch (f) {
      if (token != _latestSearchToken) return;
      emit(CurrentLocationError(message: f.message));
    }
  }

  // Asks for device GPS position and emits CurrentLocationSelected on success
  Future<void> detectLocation() async {
    emit(const CurrentLocationDetecting());
    try {
      final location = await _repository.detectCurrentLocation();
      emit(
        CurrentLocationSelected(
          displayName: location.displayName,
          lat: location.latitude,
          lng: location.longitude,
        ),
      );
    } on Failure catch (f) {
      emit(CurrentLocationError(message: f.message));
    }
  }

  // Confirms a location chosen from the search results dropdown
  void selectLocation(LocationEntity location) {
    _searchDebounce?.cancel();
    emit(
      CurrentLocationSelected(
        displayName: location.displayName,
        lat: location.latitude,
        lng: location.longitude,
      ),
    );
  }

  // Sets a location from a map long-press
  void pinLocation(double lat, double lng) {
    _searchDebounce?.cancel();
    emit(
      CurrentLocationSelected(
        displayName: '${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}',
        lat: lat,
        lng: lng,
      ),
    );
  }

  // Clears search results when focus is lost without a selection
  void clearSearchResults() {
    if (state is CurrentLocationSearchResults) {
      emit(const CurrentLocationInitial());
    }
  }

  // Transitions away from LocationError back to initial
  void clearError() {
    if (state is CurrentLocationError) {
      emit(const CurrentLocationInitial());
    }
  }
}
