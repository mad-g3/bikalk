import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

ThemeData buildAppTheme() {
  final base = GoogleFonts.interTextTheme();

  return ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: AppColors.scaffoldBg,

    // Color scheme
    colorScheme: const ColorScheme.light(
      primary: AppColors.ctaFill,
      onPrimary: AppColors.ctaText,
      secondary: AppColors.brandRose,
      onSecondary: AppColors.ctaText,
      surface: AppColors.cardSurface,
      onSurface: AppColors.textPrimary,
    ),

    // Text theme wired to Inter
    textTheme: base.copyWith(
      displayLarge: AppTextStyles.displayLarge,
      headlineMedium: AppTextStyles.headlineMedium,
      titleLarge: AppTextStyles.titleLarge,
      titleMedium: AppTextStyles.titleMedium,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.labelLarge,
      labelSmall: AppTextStyles.labelSmall,
    ),

    // AppBar - no elevation, warm background
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.scaffoldBg,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.titleLarge,
    ),

    // Elevated button - solid black CTA
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.ctaFill,
        foregroundColor: AppColors.ctaText,
        textStyle: AppTextStyles.labelLarge,
        minimumSize: const Size.fromHeight(48),
        shape: const StadiumBorder(),
        elevation: 0,
      ),
    ),

    // Outlined button - secondary action (light grey)
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.secondaryFill,
        foregroundColor: AppColors.textPrimary,
        textStyle: AppTextStyles.labelLarge,
        minimumSize: const Size.fromHeight(48),
        shape: const StadiumBorder(),
        side: BorderSide.none,
      ),
    ),

    // Text button - inline / minimal
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        textStyle: AppTextStyles.labelLarge,
      ),
    ),

    // Input fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardSurface,
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.ctaFill, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
    ),

    // Cards - warm white, subtle shadow
    cardTheme: CardThemeData(
      color: AppColors.cardSurface,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: EdgeInsets.zero,
    ),

    // Divider
    dividerColor: AppColors.divider,
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),
  );
}
