import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _feedbackController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSubmitting = true);

    // TODO: wire up to actual feedback submission (e.g. Firestore)
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Thank you for your feedback!',
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.brandRose,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    _feedbackController.clear();
  }

  void _later() {
    if (context.canPop()) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 48),

                  // Title
                  Text(
                    'Feedback',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.headlineMedium.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                    'Your feedback helps us stop overcharging\nand stabilize motorcycle rates.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Text input — fixed tall height
                  Container(
                    height: screenHeight * 0.42,
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.divider, width: 1),
                    ),
                    child: TextField(
                      controller: _feedbackController,
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      textAlignVertical: TextAlignVertical.top,
                      style: AppTextStyles.bodyLarge,
                      decoration: InputDecoration(
                        hintText: 'Your feedback goes here!',
                        hintStyle: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textHint,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),

                  const Spacer(),
                  const SizedBox(height: 24),

                  // Submit button
                  _FullWidthButton(
                    label: 'Submit',
                    onPressed: _isSubmitting ? null : _submit,
                    filled: true,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),

                  const SizedBox(height: 12),

                  // Later button
                  _FullWidthButton(
                    label: 'Later',
                    onPressed: _later,
                    filled: false,
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FullWidthButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool filled;
  final Widget? child;

  const _FullWidthButton({
    required this.label,
    required this.onPressed,
    required this.filled,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(50);

    if (filled) {
      return SizedBox(
        height: 56,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.ctaFill,
            foregroundColor: AppColors.ctaText,
            disabledBackgroundColor: AppColors.ctaFill.withOpacity(0.6),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          child: child ??
              Text(
                label,
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.ctaText,
                  fontWeight: FontWeight.w600,
                ),
              ),
        ),
      );
    }

    return SizedBox(
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.secondaryFill,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}