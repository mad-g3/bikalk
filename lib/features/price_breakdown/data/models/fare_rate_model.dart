import '../../../../core/domain/bike_mode.dart';
import '../../domain/entities/fare_rate_entity.dart';

// Maps a Firestore document to FareRateEntity
class FareRateModel {
  static FareRateEntity fromFirestore(Map<String, dynamic> data) {
    final raw = data['bikeType'] as String? ?? '';
    return FareRateEntity(
      bikeType: raw == 'Electric' ? BikeMode.electric : BikeMode.petrol,
      pricePerKm: (data['pricePerKm'] as num?)?.toDouble() ?? 0.0,
      minPrice: (data['minPrice'] as num?)?.toDouble() ?? 0.0,
      maxPrice: (data['maxPrice'] as num?)?.toDouble() ?? 0.0,
      fuelPerKm: (data['fuelPerKm'] as num?)?.toDouble(),
    );
  }
}
