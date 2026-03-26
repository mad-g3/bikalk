import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/screen_heading.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

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
              const ScreenHeading(title: 'Terms & Conditions'),
              const SizedBox(height: 24),
              const Text(
                'The fare estimates provided by Bikak are intended as a neutral, data-driven reference to assist in price transparency and are not legally binding on either the rider or the passenger. While we use real-time distance calculations and current energy costs for petrol and electric motorcycles to generate our suggested ranges, the final fare remains subject to the mutual agreement of both parties. Bikak acts solely as an informational tool and does not assume responsibility for the final outcome of any negotiation or the behavior of individuals during the transport process.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.75,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'By using this application, users acknowledge that Bikak is a fare estimation utility and not a ride-hailing or booking platform. We do not provide transportation services, and our suggested rates are based on standardized economic variables that may fluctuate due to external factors such as road closures or extreme weather conditions. Users are responsible for their own safety and financial decisions, and the application cannot be held liable for discrepancies between the suggested fare and real-world market outcomes.',
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
                  onPressed: () => context.pop(),
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
                    'Agree',
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
