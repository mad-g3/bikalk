class FareRateEntity {
  const FareRateEntity({
    required this.bikeType,
    required this.pricePerKm,
    required this.minPrice,
    required this.maxPrice,
    this.fuelPerKm,
  });

  final String bikeType;
  final double pricePerKm;
  final double minPrice;
  final double maxPrice;
  final double? fuelPerKm;

  bool get isElectric => bikeType.toLowerCase() == 'electric';

  // Returns a min/avg/max range estimate for the given distance.
  // Applies a ±15% variance then clamps to the business min/max.
  ({double min, double avg, double max}) estimateRange(double distanceKm) {
    final base = pricePerKm * distanceKm;
    final rawMin = base * 0.85;
    final rawMax = base * 1.15;
    final min = rawMin.clamp(minPrice, maxPrice);
    final max = rawMax.clamp(minPrice, maxPrice);
    final avg = (min + max) / 2;
    return (min: min, avg: avg, max: max);
  }
}
