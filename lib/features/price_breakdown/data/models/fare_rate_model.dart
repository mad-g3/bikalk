class FareRate {
  final String rateId;
  final String bikeType; // "Electric" or "Fuel"
  final double pricePerKm;
  final double minPrice;
  final double maxPrice;
  final double? fuelPerKm; // nullable — only for Fuel bikes

  const FareRate({
    required this.rateId,
    required this.bikeType,
    required this.pricePerKm,
    required this.minPrice,
    required this.maxPrice,
    this.fuelPerKm,
  });

  factory FareRate.fromFirestore(Map<String, dynamic> data, String docId) {
    return FareRate(
      rateId: docId,
      bikeType: data['bikeType'] as String? ?? '',
      pricePerKm: (data['pricePerKm'] as num?)?.toDouble() ?? 0.0,
      minPrice: (data['minPrice'] as num?)?.toDouble() ?? 0.0,
      maxPrice: (data['maxPrice'] as num?)?.toDouble() ?? 0.0,
      fuelPerKm: (data['fuelPerKm'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bikeType': bikeType,
      'pricePerKm': pricePerKm,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      if (fuelPerKm != null) 'fuelPerKm': fuelPerKm,
    };
  }

  /// Calculates the estimated fare for a given distance in km.
  /// Result is clamped between [minPrice] and [maxPrice].
  double estimateFare(double distanceKm) {
    final raw = pricePerKm * distanceKm;
    return raw.clamp(minPrice, maxPrice);
  }

  /// Total fuel consumed for a trip (only meaningful for Fuel bikes).
  double? totalFuel(double distanceKm) {
    if (fuelPerKm == null) return null;
    return fuelPerKm! * distanceKm;
  }

  bool get isElectric => bikeType.toLowerCase() == 'electric';

  @override
  String toString() =>
      'FareRate(id: $rateId, type: $bikeType, pricePerKm: $pricePerKm)';
}
