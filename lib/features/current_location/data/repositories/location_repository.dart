import '../../../../core/errors/failures.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/i_location_repository.dart';
import '../models/location_model.dart';
import '../sources/geolocator_source.dart';
import '../sources/nominatim_source.dart';

/// Implements [ILocationRepository].
/// The only class in the feature that knows about SDK-level exceptions.
class LocationRepository implements ILocationRepository {
  const LocationRepository({
    required GeolocatorSource geolocatorSource,
    required NominatimSource nominatimSource,
  }) : _geolocatorSource = geolocatorSource,
       _nominatimSource = nominatimSource;

  final GeolocatorSource _geolocatorSource;
  final NominatimSource _nominatimSource;

  @override
  Future<LocationEntity> detectCurrentLocation() async {
    try {
      final position = await _geolocatorSource.getCurrentPosition();
      return LocationEntity(
        latitude: position.latitude,
        longitude: position.longitude,
        displayName:
            '${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}',
      );
    } on PermissionFailure {
      rethrow;
    } on Exception {
      throw const ServerFailure(
        'Location permission is required to detect your current position.',
      );
    }
  }

  @override
  Future<List<LocationEntity>> searchLocations(String query) async {
    try {
      final rawList = await _nominatimSource.search(query);
      return rawList
          .map(LocationModel.fromJson)
          .where((m) => m.hasValidCoordinates)
          .map((m) => m.toEntity())
          .toList(growable: false);
    } on Exception {
      throw const ServerFailure('Location search failed. Please try again.');
    }
  }
}
