import 'dart:convert';

import 'package:http/http.dart' as http;

/// Talks directly to the Nominatim OpenStreetMap geocoding API.
/// Returns raw JSON maps; throws [Exception] on HTTP or parse error.
class NominatimSource {
  static const _userAgent =
      'bikalk-location-screen/1.0 (contact: dev@bikalk.app)';

  /// Queries Nominatim for [query] and returns up to 6 raw result maps.
  Future<List<Map<String, dynamic>>> search(String query) async {
    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'q': query.trim(),
      'format': 'jsonv2',
      'addressdetails': '1',
      'limit': '6',
      'countrycodes': 'rw',
      'dedupe': '1',
      // Rwanda bounds: left,top,right,bottom (lon/lat order).
      'viewbox': '28.86,-1.04,30.90,-2.85',
      'bounded': '1',
    });

    final response = await http.get(
      uri,
      headers: const {'User-Agent': _userAgent},
    );

    if (response.statusCode != 200) {
      throw Exception('Nominatim returned status ${response.statusCode}.');
    }

    return (jsonDecode(response.body) as List<dynamic>)
        .cast<Map<String, dynamic>>();
  }
}
