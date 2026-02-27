import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    // AuthBLoc DI entry point
  }

  @override
  void dispose() {
    // AuthBLoc DI exit point
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder(child: Text('The app goes here'));
  }
}
