import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import '../features/auth/application/auth_cubit.dart';
import '../features/auth/data/repositories/auth_repository.dart';
import '../features/auth/data/sources/firebase_auth_source.dart';
import '../features/auth/data/sources/firestore_user_source.dart';
import '../features/destinationLocation/application/destination_location_cubit.dart';
import '../features/homeScreen/application/bike_selection_cubit.dart';
import '../features/current_location/application/location_cubit.dart';
import '../features/current_location/data/repositories/location_repository.dart';
import '../features/current_location/data/sources/geolocator_source.dart';
import '../features/current_location/data/sources/nominatim_source.dart';
import '../features/current_location/domain/repositories/i_location_repository.dart';
import '../features/report_problem/application/report_problem_cubit.dart';
import '../features/report_problem/data/repositories/problem_report_repository.dart';
import '../features/report_problem/data/sources/problem_report_firestore_source.dart';
import '../features/report_problem/domain/repositories/i_problem_report_repository.dart';

final GetIt sl = GetIt.instance;

Future<void> setupDi() async {
  // Firebase SDKs
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Auth sources
  sl.registerLazySingleton(() => FirebaseAuthSource(sl()));
  sl.registerLazySingleton(() => FirestoreUserSource(sl()));

  // Auth repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(authSource: sl(), userSource: sl()),
  );

  // Auth cubit — singleton so splash + other pages share the same state
  sl.registerLazySingleton(() => AuthCubit(sl<AuthRepository>()));

  // Current location sources (stateless — singleton is fine)
  sl.registerLazySingleton<GeolocatorSource>(() => GeolocatorSource());
  sl.registerLazySingleton<NominatimSource>(() => NominatimSource());

  // Current location repository
  sl.registerLazySingleton<ILocationRepository>(
    () => LocationRepository(
      geolocatorSource: sl<GeolocatorSource>(),
      nominatimSource: sl<NominatimSource>(),
    ),
  );

  // Current location cubit — factory so each navigation creates a fresh instance
  sl.registerFactory<LocationCubit>(
    () => LocationCubit(repository: sl<ILocationRepository>()),
  );

  // Report problem source + repository
  sl.registerLazySingleton<ProblemReportFirestoreSource>(
    () => ProblemReportFirestoreSource(sl<FirebaseFirestore>()),
  );
  sl.registerLazySingleton<IProblemReportRepository>(
    () => ProblemReportRepository(source: sl<ProblemReportFirestoreSource>()),
  );

  // Report problem cubit — factory so each navigation gets a clean form state
  sl.registerFactory<ReportProblemCubit>(
    () => ReportProblemCubit(
      repository: sl<IProblemReportRepository>(),
      firebaseAuth: sl<FirebaseAuth>(),
    ),
  );

  // Destination location cubit — singleton so destination + downstream screens share state
  sl.registerLazySingleton(
    () => DestinationLocationCubit(repository: sl<ILocationRepository>()),
  );

  // Bike selection cubit
  sl.registerLazySingleton(() => BikeSelectionCubit());
}
