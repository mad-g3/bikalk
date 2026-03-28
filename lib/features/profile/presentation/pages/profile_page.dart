import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/di.dart';
import '../../../../app/routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/domain/bike_mode.dart';
import '../../../../core/services/preferences_service.dart';
import '../../../../features/homeScreen/application/bike_selection_cubit.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/screen_heading.dart';
import '../../../../features/auth/application/auth_cubit.dart';
import '../../../../features/auth/domain/entities/user_entity.dart';
import '../../../../features/auth/presentation/widgets/auth_form_field.dart';
import '../../application/profile_cubit.dart';
import '../../application/profile_state.dart';
import '../widgets/home_location_picker_sheet.dart';
import '../widgets/profile_action_row.dart';
import '../widgets/profile_preference_row.dart';
import '../widgets/profile_section_label.dart';
import '../widgets/profile_toggle_row.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameCtrl = TextEditingController();
  String _bikeMode = 'electric';
  String _distanceUnit = 'km';
  ({double lat, double lng, String label})? _homeLocation;

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile();
    _loadPreferences();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _loadPreferences() {
    final svc = sl<PreferencesService>();
    if (!mounted) return;
    setState(() {
      _bikeMode = svc.getBikeMode() == BikeMode.petrol ? 'petrol' : 'electric';
      _distanceUnit = svc.getDistanceUnit();
      _homeLocation = svc.getHomeLocation();
    });
  }

  void _onEditHomeLocation() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => HomeLocationPickerSheet(
        onSaved: (lat, lng, label) {
          setState(() => _homeLocation = (lat: lat, lng: lng, label: label));
        },
      ),
    );
  }

  Future<void> _saveBikeMode(String value) async {
    final mode = value == 'petrol' ? BikeMode.petrol : BikeMode.electric;
    await sl<PreferencesService>().saveBikeMode(mode);
    // selectMode persists via PreferencesService internally, so no double-write
    sl<BikeSelectionCubit>().selectMode(mode);
    setState(() => _bikeMode = value);
  }

  Future<void> _saveDistanceUnit(String value) async {
    await sl<PreferencesService>().saveDistanceUnit(value);
    if (!mounted) return;
    setState(() => _distanceUnit = value);
  }

  void _onSaveName() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    context.read<ProfileCubit>().updateName(name);
  }

  void _onResetPassword(UserEntity user) {
    context.read<AuthCubit>().sendPasswordReset(user.email);
    AppSnackBar.info(context, 'Password reset email sent');
  }

  void _onDeleteAccount() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete account'),
        content: const Text(
          'This will permanently delete your account and all associated data. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<ProfileCubit>().deleteAccount();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          _nameCtrl.text = state.user.name;
        } else if (state is ProfileSuccess) {
          AppSnackBar.success(context, state.message);
          _nameCtrl.text = state.user.name;
        } else if (state is ProfileError) {
          AppSnackBar.error(context, state.message);
        } else if (state is ProfileDeleted) {
          context.go(AppRoutes.signIn);
        }
      },
      builder: (context, state) {
        final user = switch (state) {
          ProfileLoaded s => s.user,
          ProfileUpdating s => s.user,
          ProfileSuccess s => s.user,
          _ => null,
        };
        final isLoading = state is ProfileLoading;
        final isSaving = state is ProfileUpdating;

        return Scaffold(
          backgroundColor: AppColors.scaffoldBg,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ScreenHeading(title: 'Profile'),
                  const SizedBox(height: 32),
                  if (isLoading)
                    const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else if (user != null) ...[
                    Center(
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: AppColors.ctaFill,
                        child: Text(
                          user.name.isNotEmpty
                              ? user.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(user.name, style: AppTextStyles.titleMedium),
                    ),
                    Center(
                      child: Text(user.email, style: AppTextStyles.bodySmall),
                    ),
                    const SizedBox(height: 32),
                    Text('Display name', style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 8),
                    AuthFormField(
                      label: '',
                      hint: user.name,
                      controller: _nameCtrl,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _onSaveName(),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: isSaving ? null : _onSaveName,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.ctaFill,
                        foregroundColor: AppColors.ctaText,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: isSaving
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Save name'),
                    ),
                    const SizedBox(height: 32),
                    const Divider(),
                    const SizedBox(height: 8),
                    const ProfileSectionLabel('Settings'),
                    const SizedBox(height: 8),
                    ProfileActionRow(
                      icon: Icons.home_outlined,
                      label: 'Home location',
                      onTap: _onEditHomeLocation,
                      subtitle: _homeLocation?.label ?? 'Not set',
                    ),
                    ProfilePreferenceRow(
                      icon: Icons.electric_bolt,
                      label: 'Preferred bike mode',
                      trailing: ProfileToggleRow(
                        options: const ['electric', 'petrol'],
                        labels: const ['Electric', 'Petrol'],
                        selected: _bikeMode,
                        onChanged: _saveBikeMode,
                      ),
                    ),
                    ProfilePreferenceRow(
                      icon: Icons.straighten,
                      label: 'Distance unit',
                      trailing: ProfileToggleRow(
                        options: const ['km', 'mi'],
                        labels: const ['km', 'mi'],
                        selected: _distanceUnit,
                        onChanged: _saveDistanceUnit,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    const ProfileSectionLabel('Account'),
                    const SizedBox(height: 8),
                    ProfileActionRow(
                      icon: Icons.lock_reset,
                      label: 'Reset password',
                      onTap: () => _onResetPassword(user),
                    ),
                    ProfileActionRow(
                      icon: Icons.delete_outline,
                      label: 'Delete account',
                      color: Colors.red.shade700,
                      onTap: _onDeleteAccount,
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    const ProfileSectionLabel('Legal'),
                    const SizedBox(height: 8),
                    ProfileActionRow(
                      icon: Icons.description_outlined,
                      label: 'Terms & Conditions',
                      onTap: () => context.push(AppRoutes.termsConditions),
                    ),
                    ProfileActionRow(
                      icon: Icons.privacy_tip_outlined,
                      label: 'Privacy Policy',
                      onTap: () => context.push(AppRoutes.privacyPolicy),
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton(
                      onPressed: () => sl<AuthCubit>().signOut(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(
                          color: AppColors.divider,
                          width: 1.5,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Sign out'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProfilePageWrapper extends StatelessWidget {
  const ProfilePageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileCubit>(),
      child: const ProfilePage(),
    );
  }
}
