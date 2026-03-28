import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/bike_mode.dart';

class PreferencesService {
  const PreferencesService(this._prefs);

  final SharedPreferences _prefs;

  static const _keyHomeLocation = 'home_location';
  static const _keyBikeMode = 'preferred_bike_mode';
  static const _keyDistanceUnit = 'distance_unit';

  // Home location

  Future<void> saveHomeLocation({
    required double lat,
    required double lng,
    required String label,
  }) async {
    await _prefs.setString(
      _keyHomeLocation,
      jsonEncode({'lat': lat, 'lng': lng, 'label': label}),
    );
  }

  ({double lat, double lng, String label})? getHomeLocation() {
    final raw = _prefs.getString(_keyHomeLocation);
    if (raw == null) return null;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return (
      lat: map['lat'] as double,
      lng: map['lng'] as double,
      label: map['label'] as String,
    );
  }

  // Preferred bike mode

  Future<void> saveBikeMode(BikeMode mode) async {
    await _prefs.setString(
      _keyBikeMode,
      mode == BikeMode.electric ? 'electric' : 'petrol',
    );
  }

  BikeMode? getBikeMode() {
    final raw = _prefs.getString(_keyBikeMode);
    if (raw == null) return null;
    return raw == 'electric' ? BikeMode.electric : BikeMode.petrol;
  }

  // Distance unit (km or mi)

  Future<void> saveDistanceUnit(String unit) async {
    await _prefs.setString(_keyDistanceUnit, unit);
  }

  String getDistanceUnit() => _prefs.getString(_keyDistanceUnit) ?? 'km';
}
