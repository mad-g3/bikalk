import 'package:flutter/material.dart';

// Colors extracted from Figma design screens
abstract final class AppColors {
  // Backgrounds
  static const scaffoldBg = Color(0xFFE8E3E3); // warm beige-grey
  static const cardSurface = Color(0xFFF9F3F3); // warm white for cards

  // Brand / illustration tones
  static const brandRose = Color(0xFFB27676); // bike body warm rose
  static const brandRoseLight = Color(0xFFF3A5A5); // highlight detail
  static const blobFill = Color(0xFFEBDBDB); // decorative blob shape

  // CTA buttons
  static const ctaFill = Color(0xFF000000); // primary black button
  static const ctaText = Color(0xFFFFFFFF); // button label
  static const secondaryFill = Color(0xFFF5F5F5); // outlined/secondary button

  // Text
  static const textPrimary = Color(0xFF000000);
  static const textSecondary = Color(0xFF666666);
  static const textHint = Color(0xFF8C8C8C);

  // Misc
  static const divider = Color(0xFFD9D9D9);
  static const transparent = Colors.transparent;
}
