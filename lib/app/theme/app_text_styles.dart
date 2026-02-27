import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

// All text styles using Inter, matching the Figma design
abstract final class AppTextStyles {
  static final _base = GoogleFonts.inter(color: AppColors.textPrimary);

  // Display - large hero text (e.g. splash tagline)
  static final displayLarge = _base.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  // Headings
  static final headlineMedium = _base.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // Section titles / card headers
  static final titleLarge = _base.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static final titleMedium = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  // Body
  static final bodyLarge = _base.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static final bodyMedium = _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static final bodySmall = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // Labels (buttons, chips, captions)
  static final labelLarge = _base.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.2,
  );

  static final labelSmall = _base.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
    height: 1.3,
    letterSpacing: 0.4,
  );
}
