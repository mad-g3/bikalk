import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/di.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../application/auth_cubit.dart';
import '../../application/auth_state.dart';
import '../../../../core/widgets/screen_heading.dart';
import '../widgets/auth_form_field.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({super.key});

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final error = await context.read<AuthCubit>().sendPasswordReset(_emailCtrl.text.trim());
    if (!mounted) return;
    setState(() => _isLoading = false);
    
    if (error != null) {
      AppSnackBar.error(context, error);
    } else {
      AppSnackBar.success(context, 'Reset link sent — check your email.');
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 32,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ScreenHeading(
                  title: 'Forgot your password?',
                  subtitle: "Enter your email and we'll send you a reset link.",
                ),
                const SizedBox(height: 32),
                AuthFormField(
                  label: 'Email',
                  hint: 'you@example.com',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: AppValidators.email,
                ),
                const SizedBox(height: 32),
                if (_isLoading)
                  const AppLoadingIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Send reset link'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordResetPageWrapper extends StatelessWidget {
  const PasswordResetPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<AuthCubit>(),
      child: const PasswordResetPage(),
    );
  }
}
