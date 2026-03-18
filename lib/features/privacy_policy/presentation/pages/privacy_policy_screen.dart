import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 18, 6),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'privacy-policy s...',
                    style: TextStyle(
                      color: AppColors.textHint,
                      fontSize: 13,
                      fontFamily: 'monospace',
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),

            // Cream card
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Scrollable text
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Privacy Policy',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Bikak collects only the data necessary to provide accurate fare estimates, specifically your current location, destination, and choice of motorcycle type. This information is processed in real-time to calculate distance and energy efficiency offsets, ensuring you have a factual basis for negotiation. We do not use this data to build personal movement profiles, and location access is only active while the app is being used to generate a price breakdown.',
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.75,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Your privacy and trust are central to our mission, so we never sell or share your journey details with third-party advertisers. Any feedback or problem reports you submit are anonymized and used exclusively to improve the accuracy of our pricing algorithms and support Kigali\'s transition to e-mobility. By keeping our data requirements minimal, we provide a secure, neutral utility that empowers you without compromising your personal information.',
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.75,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Next button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/terms'),
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
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
