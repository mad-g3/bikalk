import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/di.dart';
import '../../../../app/routes.dart';
import '../../application/auth_cubit.dart';
import '../../application/auth_state.dart';

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
          context.go(AppRoutes.verifyOtp);
        } else if (state is Unauthenticated) {
          context.go(AppRoutes.signIn);
        }
      },
      child: const Scaffold(
        body: Center(
          // TODO: replace with branded logo asset
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
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
