/// Pure Dart — no Flutter, no Firebase, no packages.
class LocationEntity {
  const LocationEntity({
    required this.latitude,
    required this.longitude,
    required this.displayName,
  });

  final double latitude;
  final double longitude;

  /// Full human-readable address returned by the geocoding source.
  final String displayName;

  /// Short first part of the address (before the first comma).
  String get primaryLabel {
    if (displayName.isEmpty) return 'Unknown place';
    return displayName.split(',').first.trim();
  }

  /// Everything after the first comma, used as subtitle.
  String get secondaryLabel {
    if (!displayName.contains(',')) return '';
    return displayName.split(',').skip(1).join(',').trim();
  }

  @override
  String toString() => 'LocationEntity($latitude, $longitude, "$displayName")';
}
