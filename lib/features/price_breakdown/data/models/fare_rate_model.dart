import '../../domain/entities/fare_rate_entity.dart';

// Maps a Firestore document to FareRateEntity
class FareRateModel {
  static FareRateEntity fromFirestore(Map<String, dynamic> data) {
    return FareRateEntity(
      bikeType: data['bikeType'] as String? ?? '',
      pricePerKm: (data['pricePerKm'] as num?)?.toDouble() ?? 0.0,
      minPrice: (data['minPrice'] as num?)?.toDouble() ?? 0.0,
      maxPrice: (data['maxPrice'] as num?)?.toDouble() ?? 0.0,
      fuelPerKm: (data['fuelPerKm'] as num?)?.toDouble(),
    );
  }
}
