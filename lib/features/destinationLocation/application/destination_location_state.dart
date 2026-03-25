import 'package:equatable/equatable.dart';

import '../../current_location/domain/entities/location_entity.dart';

abstract class DestinationLocationState extends Equatable {
  const DestinationLocationState();

  @override
  List<Object?> get props => [];
}

// Nothing selected yet
class DestinationLocationInitial extends DestinationLocationState {
  const DestinationLocationInitial();
}

// User is typing and holds live search results and a loading flag
class DestinationLocationSearchResults extends DestinationLocationState {
  const DestinationLocationSearchResults({
    required this.results,
    this.isSearching = false,
  });

  final List<LocationEntity> results;
  final bool isSearching;

  @override
  List<Object?> get props => [results, isSearching];
}

// User confirmed a destination (from suggestion or map long-press)
class DestinationLocationSelected extends DestinationLocationState {
  const DestinationLocationSelected({
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
