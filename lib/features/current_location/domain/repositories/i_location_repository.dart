import '../entities/location_entity.dart';

/// Stable data contract for location operations.
/// The application layer depends on this; the data layer implements it.
abstract class ILocationRepository {
  /// Returns the device's current GPS position as a [LocationEntity].
  ///
  /// Throws [PermissionFailure] if location permission is not granted.
  /// Throws [ServerFailure] if the position cannot be determined.
  Future<LocationEntity> detectCurrentLocation();

  /// Searches for places matching [query] using the Nominatim geocoding API.
  ///
  /// Throws [ServerFailure] on network or parse error.
  Future<List<LocationEntity>> searchLocations(String query);
}
