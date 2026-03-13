import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/di.dart';
import 'firebase_options.dart';
import 'package:web/web.dart' as web;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupDi();

  const apiKey = String.fromEnvironment('MAPS_API_KEY');

  if (apiKey.isNotEmpty) {
    final script = web.document.createElement('script') as web.HTMLScriptElement;
    script.src = 'https://maps.googleapis.com/maps/api/js?key=$apiKey';
    script.async = true;
    web.document.head?.appendChild(script);
  }

  runApp(const App());
}
