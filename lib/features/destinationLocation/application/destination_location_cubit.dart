import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../current_location/domain/entities/location_entity.dart';
import '../../current_location/domain/repositories/i_location_repository.dart';
import 'destination_location_state.dart';

class DestinationLocationCubit extends Cubit<DestinationLocationState> {
  DestinationLocationCubit({required ILocationRepository repository})
      : _repository = repository,
        super(const DestinationLocationInitial());

  final ILocationRepository _repository;
  Timer? _searchDebounce;
  int _latestSearchToken = 0;

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  // Debounces Nominatim search; clears results if query is too short
  void scheduleSearch(String query) {
    _searchDebounce?.cancel();

    if (query.trim().length < 2) {
      emit(const DestinationLocationInitial());
      return;
    }

    emit(const DestinationLocationSearchResults(results: [], isSearching: true));
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
      emit(DestinationLocationSearchResults(results: results));
    } catch (_) {
      if (token != _latestSearchToken) return;
      emit(const DestinationLocationSearchResults(results: []));
    }
  }

  // Called when the user taps a suggestion from the dropdown
  void selectFromSuggestion(LocationEntity location) {
    _searchDebounce?.cancel();
    emit(DestinationLocationSelected(
      displayName: location.displayName,
      lat: location.latitude,
      lng: location.longitude,
    ));
  }

  // Called when the user long-presses the map
  void selectFromMapPin(double lat, double lng) {
    _searchDebounce?.cancel();
    emit(DestinationLocationSelected(
      displayName: '${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}',
      lat: lat,
      lng: lng,
    ));
  }

  // Clears search results without touching a confirmed selection
  void clearSearchResults() {
    if (state is DestinationLocationSearchResults) {
      emit(const DestinationLocationInitial());
    }
  }

  // Resets everything back to initial
  void clearDestination() {
    _searchDebounce?.cancel();
    emit(const DestinationLocationInitial());
  }
}
