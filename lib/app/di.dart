import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import '../features/auth/application/auth_cubit.dart';
import '../features/auth/data/repositories/auth_repository.dart';
import '../features/auth/data/sources/firebase_auth_source.dart';
import '../features/auth/data/sources/firestore_user_source.dart';

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
}
