import 'package:flutter/material.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_text_styles.dart';

class ProfileActionRow extends StatelessWidget {
  const ProfileActionRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    this.subtitle,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.textPrimary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: effectiveColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: effectiveColor,
                    ),
                  ),
                  if (subtitle != null)
                    Text(subtitle!, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 20, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
