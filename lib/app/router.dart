import 'dart:async';
import 'package:bikalk/features/price_breakdown/presentation/pages/price_breakdown_screen.dart' show PriceBreakdownScreen;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/application/auth_cubit.dart';
import '../features/auth/application/auth_state.dart';
import '../features/auth/presentation/pages/new_password_page.dart';
import '../features/auth/presentation/pages/password_reset_page.dart';
import '../features/auth/presentation/pages/sign_in_page.dart';
import '../features/auth/presentation/pages/sign_up_page.dart';
import '../features/splash/presentation/pages/splash_page.dart';
import '../features/auth/presentation/pages/verify_email_page.dart';
import '../features/feedback/presentation/pages/feedback_page.dart';
import '../features/terms_conditions/presentation/pages/terms_conditions_screen.dart';
import 'di.dart';
import 'routes.dart';

// Bridges a Stream into a Listenable so GoRouter re-evaluates redirect on state changes
class _StreamRefresh extends ChangeNotifier {
  _StreamRefresh(Stream<dynamic> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: _StreamRefresh(sl<AuthCubit>().stream),
    redirect: _redirect,
    routes: [
      // Auth
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SplashPageWrapper()),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SignInPageWrapper()),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SignUpPageWrapper()),
      ),
      GoRoute(
        path: AppRoutes.verifyEmail,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: VerifyEmailPageWrapper()),
      ),
      GoRoute(
        path: AppRoutes.passwordReset,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: PasswordResetPageWrapper()),
      ),
      GoRoute(
        path: AppRoutes.newPassword,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: NewPasswordPage()),
      ),

      // Legal
      GoRoute(
        path: AppRoutes.privacyPolicy,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: PriceBreakdownScreen()),
      ),
      GoRoute(
        path: AppRoutes.termsConditions,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: TermsConditionsScreen()),
      ),

      // Core flow
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: Placeholder()),
      ),
      GoRoute(
        path: AppRoutes.currentLocation,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: Placeholder()),
      ),
      GoRoute(
        path: AppRoutes.destinationLocation,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: Placeholder()),
      ),
      GoRoute(
        path: AppRoutes.priceBreakdown,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: PriceBreakdownScreen()),
      ),

      // Post-result
      GoRoute(
        path: AppRoutes.reportProblem,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: Placeholder()),
      ),
      GoRoute(
        path: AppRoutes.feedback,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: FeedbackPage()),
      ),
    ],
  );
}

const _protectedRoutes = [
  AppRoutes.home,
  AppRoutes.currentLocation,
  AppRoutes.destinationLocation,
  AppRoutes.priceBreakdown,
  AppRoutes.reportProblem,
  AppRoutes.feedback,
];

const _authRoutes = [
  AppRoutes.signIn,
  AppRoutes.signUp,
  AppRoutes.passwordReset,
  AppRoutes.newPassword,
  AppRoutes.verifyEmail,
];

String? _redirect(BuildContext context, GoRouterState state) {
  final authState = sl<AuthCubit>().state;
  final location = state.matchedLocation;

  if (authState is Authenticated) {
    // Push authenticated users away from auth/splash screens
    if (_authRoutes.contains(location) || location == AppRoutes.splash) {
      return AppRoutes.home;
    }
    return null;
  }

  if (authState is AwaitingEmailVerification) {
    if (location != AppRoutes.verifyEmail) return AppRoutes.verifyEmail;
    return null;
  }

  if (authState is Unauthenticated || authState is AuthError) {
    if (_protectedRoutes.contains(location)) return AppRoutes.signIn;
    return null;
  }

  if (authState is AuthLoading) {
    return null;
  }

  // AuthInitial — keep on splash while session is being checked
  if (location != AppRoutes.splash) return AppRoutes.splash;
  return null;
}
