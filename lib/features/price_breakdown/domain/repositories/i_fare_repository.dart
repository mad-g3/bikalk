import '../../../../../core/domain/bike_mode.dart';
import '../entities/fare_rate_entity.dart';

abstract class IFareRepository {
  Future<FareRateEntity?> getFareRateByBikeType(BikeMode bikeType);
}
