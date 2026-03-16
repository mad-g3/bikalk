import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/di.dart';
import '../../../../app/routes.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../application/auth_cubit.dart';
import '../../application/auth_state.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    // Poll every 2s to check if Firebase has recorded verification
    _pollTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      context.read<AuthCubit>().checkEmailVerified();
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          _pollTimer?.cancel();
          context.go(AppRoutes.home);
        } else if (state is AuthError) {
          AppSnackBar.error(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Verify your email')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Check your inbox',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  'We sent a verification link to your email address. '
                  'Click it to activate your account.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Waiting for verification…',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () =>
                      context.read<AuthCubit>().resendVerificationEmail(),
                  child: const Text('Resend email'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () async {
                    await context.read<AuthCubit>().signOut();
                    if (context.mounted) context.go(AppRoutes.signIn);
                  },
                  child: const Text('Sign out'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VerifyOtpPageWrapper extends StatelessWidget {
  const VerifyOtpPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<AuthCubit>(),
      child: const VerifyOtpPage(),
    );
  }
}
