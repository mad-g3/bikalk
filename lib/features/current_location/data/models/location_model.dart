import '../../domain/entities/location_entity.dart';

/// Data-format bridge: parses raw Nominatim JSON and converts to [LocationEntity].
class LocationModel {
  const LocationModel({
    required this.displayName,
    required this.latitude,
    required this.longitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      displayName: (json['display_name']?.toString() ?? '').trim(),
      latitude: double.tryParse(json['lat']?.toString() ?? ''),
      longitude: double.tryParse(json['lon']?.toString() ?? ''),
    );
  }

  final String displayName;
  final double? latitude;
  final double? longitude;

  bool get hasValidCoordinates {
    final lat = latitude;
    final lon = longitude;
    if (lat == null || lon == null) return false;
    return lat >= -90 && lat <= 90 && lon >= -180 && lon <= 180;
  }

  LocationEntity toEntity() {
    final lat = latitude!;
    final lon = longitude!;
    return LocationEntity(
      latitude: lat,
      longitude: lon,
      displayName: displayName,
    );
  }
}
