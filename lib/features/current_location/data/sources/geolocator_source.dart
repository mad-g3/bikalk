import 'package:geolocator/geolocator.dart';
import '../../../../core/errors/failures.dart';

/// Talks directly to the Geolocator SDK.
/// Returns raw [Position] objects; throws standard [Exception] on failure.
/// The repository is responsible for converting exceptions to domain Failures.
class GeolocatorSource {
  /// Requests permissions if needed, then returns the current device position.
  ///
  /// Throws a [PermissionFailure] (with message `'permission_denied'`) when
   /// the user refuses location access so the repository can map that to a
   /// [PermissionFailure]. Throws an [Exception] for any other error (service
   /// disabled, timeout, etc.).
  Future<Position> getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw const PermissionFailure('Location permission is required.');
    }

    return Geolocator.getCurrentPosition();
  }
}
