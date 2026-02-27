import 'package:flutter/material.dart';
import 'router.dart';
import 'theme/theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _router = buildRouter();

  @override
  void initState() {
    super.initState();
    // AuthBloc DI entry point
  }

  @override
  void dispose() {
    // AuthBloc DI exit point
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bikalk',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      routerConfig: _router,
    );
  }
}
