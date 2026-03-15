import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: _redirect,
    routes: [
      // Auth
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) => const NoTransitionPage(child: SplashPage()),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        pageBuilder: (context, state) => const NoTransitionPage(child: Placeholder()),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        pageBuilder: (context, state) => const NoTransitionPage(child: Placeholder()),
      ),
      GoRoute(
        path: AppRoutes.verifyOtp,
        pageBuilder: (context, state) => const NoTransitionPage(child: Placeholder()),
      ),
      GoRoute(
        path: AppRoutes.passwordReset,
        pageBuilder: (context, state) => const NoTransitionPage(child: Placeholder()),
      ),
      GoRoute(
        path: AppRoutes.newPassword,
        pageBuilder: (context, state) => const NoTransitionPage(child: Placeholder()),
      ),

      // Legal
      GoRoute(
        path: AppRoutes.privacyPolicy,
        pageBuilder: (context, state) => const NoTransitionPage(child: Placeholder()),
      ),
      GoRoute(
        path: AppRoutes.termsConditions,
        pageBuilder: (context, state) => const NoTransitionPage(child: Placeholder()),
      ),

      // Core flow
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (context, state) => const NoTransitionPage(child: Placeholder()),
      ),
      GoRoute(
        path: AppRoutes.currentLocation,
        pageBuilder: (context, state) => const NoTransitionPage(child: Placeholder()),
      ),
      GoRoute(
        path: AppRoutes.destinationLocation,
        pageBuilder: (context, state) => const NoTransitionPage(child: Placeholder()),
      ),
      GoRoute(
        path: AppRoutes.priceBreakdown,
        pageBuilder: (context, state) => const NoTransitionPage(child: Placeholder()),
      ),

      // Post-result
      GoRoute(
        path: AppRoutes.reportProblem,
        pageBuilder: (context, state) => const NoTransitionPage(child: Placeholder()),
      ),
      GoRoute(
        path: AppRoutes.feedback,
        pageBuilder: (context, state) => const NoTransitionPage(child: FeedbackPage()),
      ),
    ],
  );
}

// TODO: replace with real auth-gate logic once AuthBloc is wired up
import '../features/splash/presentation/pages/splash_page.dart';
import '../features/feedback/presentation/pages/feedback_page.dart';
String? _redirect(BuildContext context, GoRouterState state) {
  return null;
}



