import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../features/current_location/application/location_cubit.dart';
import '../features/current_location/data/repositories/location_repository.dart';
import '../features/current_location/data/sources/geolocator_source.dart';
import '../features/current_location/data/sources/nominatim_source.dart';
import '../features/current_location/domain/repositories/i_location_repository.dart';

final GetIt sl = GetIt.instance;

Future<void> setupDi() async {
  // Firebase SDKs
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // --- current_location feature ---

  // Sources (stateless — singleton is fine)
  sl.registerLazySingleton<GeolocatorSource>(() => GeolocatorSource());
  sl.registerLazySingleton<NominatimSource>(() => NominatimSource());

  // Repository
  sl.registerLazySingleton<ILocationRepository>(
    () => LocationRepository(
      geolocatorSource: sl<GeolocatorSource>(),
      nominatimSource: sl<NominatimSource>(),
    ),
  );

  // Cubit — factory so each navigation creates a fresh instance
  sl.registerFactory<LocationCubit>(
    () => LocationCubit(repository: sl<ILocationRepository>()),
  );
}
