import 'package:flutter_test/flutter_test.dart';
import 'package:bikalk/features/price_breakdown/domain/entities/fare_rate_entity.dart';
import 'package:bikalk/core/domain/bike_mode.dart';

void main() {
  group('FareRateEntity.estimateRange', () {
    const rate = FareRateEntity(
      bikeType: BikeMode.electric,
      pricePerKm: 200,
      minPrice: 500,
      maxPrice: 5000,
    );

    test('returns correct avg as midpoint of min and max', () {
      final result = rate.estimateRange(10); // base = 2000, ±15% = 1700–2300
      expect(result.avg, (result.min + result.max) / 2);
    });

    test('returns minPrice when distance is zero', () {
      final result = rate.estimateRange(0);
      expect(result.min, 500);
    });

    test('applies ±15% variance to base price', () {
      final result = rate.estimateRange(10); // base = 2000
      expect(result.min, closeTo(1700, 1));
      expect(result.max, closeTo(2300, 1));
    });

    test('clamps min to minPrice on very short trip', () {
      final result = rate.estimateRange(1); // base = 200, rawMin = 170 < 500
      expect(result.min, 500);
    });

    test('clamps max to maxPrice on very long trip', () {
      final result = rate.estimateRange(
        30,
      ); // base = 6000, rawMax = 6900 > 5000
      expect(result.max, 5000);
    });

    test('avg stays within min and max bounds', () {
      final result = rate.estimateRange(10);
      expect(result.avg >= result.min, true);
      expect(result.avg <= result.max, true);
    });

    test('petrol rate entity uses same formula', () {
      const petrolRate = FareRateEntity(
        bikeType: BikeMode.petrol,
        pricePerKm: 300,
        minPrice: 500,
        maxPrice: 8000,
      );
      final result = petrolRate.estimateRange(10); // base = 3000
      expect(result.min, closeTo(2550, 1));
      expect(result.max, closeTo(3450, 1));
    });
  });
}
