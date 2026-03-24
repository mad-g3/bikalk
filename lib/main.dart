import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/di.dart';
import 'core/utils/maps_script_injector.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupDi();

  const apiKey = String.fromEnvironment('MAPS_API_KEY');
  injectMapsScript(apiKey);

  runApp(const App());
}
