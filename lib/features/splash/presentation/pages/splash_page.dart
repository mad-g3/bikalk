import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di.dart';
import '../../../../app/routes.dart';
import '../../../../app/theme/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  FirebaseAuth get _auth => sl<FirebaseAuth>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _navigate());
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 1400));

    final user = _auth.currentUser;
    final destination = user == null ? AppRoutes.signIn : AppRoutes.home;

    if (mounted) {
      GoRouter.of(context).go(destination);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Decorative background blobs.
            Positioned(
              top: 100,
              left: 22,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  color: AppColors.blobFill,
                  borderRadius: BorderRadius.circular(200),
                ),
              ),
            ),
            Positioned(
              bottom: 120,
              right: 40,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: AppColors.blobFill.withOpacity(0.78),
                  borderRadius: BorderRadius.circular(180),
                ),
              ),
            ),

            // Main content.
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.cardSurface,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/logo.png',
                    width: 96,
                    height: 96,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Bikalk',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.brandRose,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Transparent pricing is peace of mind.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),

            // Secondary tagline at the bottom.
            Positioned(
              bottom: 28,
              left: 24,
              right: 24,
              child: Text(
                'Quick setup — ready in seconds.',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
