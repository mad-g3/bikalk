import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/domain/bike_mode.dart';
import '../../domain/entities/fare_rate_entity.dart';
import '../../domain/repositories/i_fare_repository.dart';
import '../models/fare_rate_model.dart';

class FareRateRepository implements IFareRepository {
  FareRateRepository(this._db);

  final FirebaseFirestore _db;

  @override
  Future<FareRateEntity?> getFareRateByBikeType(BikeMode bikeType) async {
    // Convert enum to the Firestore string value used in the fare_rates collection
    final firestoreLabel =
        bikeType == BikeMode.electric ? 'Electric' : 'Petrol';
    final snapshot = await _db
        .collection('fare_rates')
        .where('bikeType', isEqualTo: firestoreLabel)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return FareRateModel.fromFirestore(snapshot.docs.first.data());
  }
}
