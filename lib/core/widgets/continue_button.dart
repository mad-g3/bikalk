import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class ContinueButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  const ContinueButton({
    super.key,
    required this.onPressed,
    this.label = 'Continue',
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.ctaFill,
        foregroundColor: AppColors.ctaText,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 0,
      ),
      child: Text(
        label,
        style: AppTextStyles.labelLarge.copyWith(color: AppColors.ctaText),
      ),
    );
  }
}
