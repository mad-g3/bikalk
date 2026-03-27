import 'package:flutter/material.dart';

// Colors from our Figma designs
abstract final class AppColors {
  // Main background colors
  static const scaffoldBg = Color(0xFFE8E3E3); // overall page background
  static const cardSurface = Color(0xFFF9F3F3); // background for cards

  // Brand and illustration colors
  static const brandRose = Color(0xFFB27676); // warm rose tone for bike body
  static const brandRoseLight = Color(0xFFF3A5A5); // lighter highlight version
  static const blobFill = Color(0xFFEBDBDB); // decorative shape background

  // Call-to-action buttons
  static const ctaFill = Color(0xFF000000); // main black button
  static const ctaText = Color(0xFFFFFFFF); // text on buttons
  static const secondaryFill = Color(
    0xFFF5F5F5,
  ); // for secondary or outlined buttons

  // Text colors
  static const textPrimary = Color(0xFF000000); // main text color
  static const textSecondary = Color(0xFF666666); // secondary text
  static const textHint = Color(0xFF8C8C8C); // hint / placeholder text

  // Miscellaneous
  static const divider = Color(0xFFD9D9D9); // line dividers
  static const transparent = Colors.transparent; // fully transparent
}
