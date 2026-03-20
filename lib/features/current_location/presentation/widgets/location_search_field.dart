import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_text_styles.dart';

/// Search input with a detect-location icon button in the suffix.
/// This widget is purely presentational — all callbacks come from the caller.
class LocationSearchField extends StatelessWidget {
  const LocationSearchField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onDetectLocation,
    required this.isSearching,
    required this.isDetecting,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onDetectLocation;
  final bool isSearching;
  final bool isDetecting;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardSurface,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(12),
      child: TextField(
        autofocus: autofocus,
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        style: AppTextStyles.bodyLarge,
        decoration: InputDecoration(
          hintText: 'Search your location',
          filled: true,
          fillColor: AppColors.cardSurface,
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
            borderSide: const BorderSide(color: AppColors.ctaFill, width: 1.2),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSearching)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              IconButton(
                tooltip: 'Detect my location',
                onPressed: isDetecting ? null : onDetectLocation,
                icon: isDetecting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(
                        Icons.my_location,
                        color: AppColors.textPrimary,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
