import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/screen_heading.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ScreenHeading(title: 'Privacy Policy'),
              const SizedBox(height: 24),
              const Text(
                'Bikak collects only the data necessary to provide accurate fare estimates, specifically your current location, destination, and choice of motorcycle type. This information is processed in real-time to calculate distance and energy efficiency offsets, ensuring you have a factual basis for negotiation. We do not use this data to build personal movement profiles, and location access is only active while the app is being used to generate a price breakdown.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.75,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Your privacy and trust are central to our mission, so we never sell or share your journey details with third-party advertisers. Any feedback or problem reports you submit are anonymized and used exclusively to improve the accuracy of our pricing algorithms and support Kigali's transition to e-mobility. By keeping our data requirements minimal, we provide a secure, neutral utility that empowers you without compromising your personal information.",
                style: TextStyle(
                  fontSize: 14,
                  height: 1.75,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.push(AppRoutes.termsConditions),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.ctaFill,
                    foregroundColor: AppColors.ctaText,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
