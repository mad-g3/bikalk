import 'package:flutter/material.dart';

// Convenience helpers for showing consistent SnackBars across the app.
abstract final class AppSnackBar {
  static void error(BuildContext context, String message) {
    _show(context, message, backgroundColor: const Color(0xFFB00020));
  }

  static void success(BuildContext context, String message) {
    _show(context, message, backgroundColor: const Color(0xFF2E7D32));
  }

  static void info(BuildContext context, String message) {
    _show(context, message, backgroundColor: const Color(0xFF1565C0));
  }

  static void _show(
    BuildContext context,
    String message, {
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          duration: const Duration(seconds: 3),
        ),
      );
  }
}
