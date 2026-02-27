import 'package:flutter/material.dart';

// Shared centered loading indicator
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.black),
    );
  }
}

// Shared centered loading overlay
class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Colors.white54,
      child: AppLoadingIndicator(),
    );
  }
}
