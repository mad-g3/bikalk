import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/fare_rate_model.dart';

class FareRateService {
  final FirebaseFirestore _db;

  FareRateService({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _db.collection('fare_rates');

  /// Fetches all fare rates from Firestore.
  Future<List<FareRate>> getAllFareRates() async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map((doc) => FareRate.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  /// Fetches a single fare rate by bike type ("Electric" or "Fuel").
  /// Returns null if no matching document is found.
  Future<FareRate?> getFareRateByBikeType(String bikeType) async {
    final snapshot = await _collection
        .where('bikeType', isEqualTo: bikeType)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    final doc = snapshot.docs.first;
    return FareRate.fromFirestore(doc.data(), doc.id);
  }

  /// Fetches a fare rate by its document ID.
  Future<FareRate?> getFareRateById(String rateId) async {
    final doc = await _collection.doc(rateId).get();
    if (!doc.exists || doc.data() == null) return null;
    return FareRate.fromFirestore(doc.data()!, doc.id);
  }

  /// Stream of all fare rates — use for real-time updates.
  Stream<List<FareRate>> watchAllFareRates() {
    return _collection.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => FareRate.fromFirestore(doc.data(), doc.id))
          .toList(),
    );
  }
}
