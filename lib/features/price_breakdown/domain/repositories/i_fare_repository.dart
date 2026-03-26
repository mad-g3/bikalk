import '../entities/fare_rate_entity.dart';

abstract class IFareRepository {
  Future<FareRateEntity?> getFareRateByBikeType(String bikeType);
}
