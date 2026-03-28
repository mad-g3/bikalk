import 'package:flutter/material.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_text_styles.dart';

class ProfileToggleRow extends StatelessWidget {
  const ProfileToggleRow({
    super.key,
    required this.options,
    required this.labels,
    required this.selected,
    required this.onChanged,
  });

  final List<String> options;
  final List<String> labels;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(options.length, (i) {
        final isSelected = options[i] == selected;
        return GestureDetector(
          onTap: () => onChanged(options[i]),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.ctaFill : AppColors.secondaryFill,
              borderRadius: BorderRadius.horizontal(
                left: i == 0 ? const Radius.circular(20) : Radius.zero,
                right: i == options.length - 1
                    ? const Radius.circular(20)
                    : Radius.zero,
              ),
              border: Border.all(color: AppColors.divider),
            ),
            child: Text(
              labels[i],
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? AppColors.ctaText : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        );
      }),
    );
  }
}
