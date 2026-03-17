import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di.dart';
import '../../../../app/routes.dart';
import '../../../auth/application/auth_cubit.dart';
import '../../../auth/application/auth_state.dart';
import '../../../../app/theme/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().checkSession();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.go(AppRoutes.home);
        } else if (state is AwaitingEmailVerification) {
          context.go(AppRoutes.verifyEmail);
        } else if (state is Unauthenticated) {
          context.go(AppRoutes.signIn);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background blobs
              Positioned(
                top: 96,
                left: 16,
                child: Container(
                  width: 252,
                  height: 252,
                  decoration: BoxDecoration(
                    color: AppColors.blobFill,
                    borderRadius: BorderRadius.circular(200),
                  ),
                ),
              ),
              Positioned(
                bottom: 108,
                right: 28,
                child: Container(
                  width: 190,
                  height: 190,
                  decoration: BoxDecoration(
                    color: AppColors.blobFill.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(190),
                  ),
                ),
              ),
              // Content
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
                  const SizedBox(height: 22),
                  Text(
                    'Bikalk',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppColors.brandRose,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Transparent pricing is peace of mind.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ],
              ),
              Positioned(
                bottom: 28,
                left: 24,
                right: 24,
                child: Text(
                  'Quick setup — ready in seconds.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
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

// Provides AuthCubit from the DI container for this page
class SplashPageWrapper extends StatelessWidget {
  const SplashPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<AuthCubit>(),
      child: const SplashPage(),
    );
  }
}
