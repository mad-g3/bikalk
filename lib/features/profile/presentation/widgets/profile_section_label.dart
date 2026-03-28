import 'package:flutter/material.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_text_styles.dart';

class ProfileSectionLabel extends StatelessWidget {
  const ProfileSectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textHint,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
