import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/cubits/app_localization/app_localization_cubit.dart';
import '../../../../core/cubits/app_theme/app_theme_cubit.dart';
import '../../../../core/cubits/app_user/app_user_cubit.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../widgets/settings_profile_header.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkSurfaceContainer
          : AppColors.surfaceContainer,
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 2,
      ),
      body: BlocBuilder<AppUserCubit, AppUserState>(
        builder: (context, userState) {
          if (userState is! AppUserLoggedIn) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = userState.userModel;

          return ListView(
            children: [
              SettingsProfileHeader(
                user: user,
                onEditProfile: () {
                  // TODO: Navigate to edit profile
                  CustomSnackbar.info(context, 'Edit Profile clicked');
                },
              ),
              SettingsSection(
                title: 'Account',
                children: [
                  SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy',
                    subtitle: 'Last seen, profile photo, about',
                    onTap: () {
                      // TODO: Navigate to privacy settings
                    },
                  ),
                  SettingsTile(
                    icon: Icons.security_outlined,
                    title: 'Security',
                    subtitle: 'Two-step verification',
                    onTap: () {
                      // TODO: Navigate to security settings
                    },
                  ),
                  SettingsTile(
                    icon: Icons.delete_outline,
                    title: 'Delete Account',
                    iconColor: AppColors.error,
                    titleColor: AppColors.error,
                    showDivider: false,
                    onTap: () {
                      // TODO: Handle delete account
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: 'Appearance',
                children: [
                  BlocBuilder<AppThemeCubit, AppThemeState>(
                    builder: (context, themeState) {
                      String themeName = 'System';
                      if (themeState is LightThemeMode) themeName = 'Light';
                      if (themeState is DarkThemeMode) themeName = 'Dark';

                      return SettingsTile(
                        icon: Icons.brightness_6_outlined,
                        title: 'Theme',
                        subtitle: themeName,
                        onTap: () => _showThemeSelector(context, themeState),
                      );
                    },
                  ),
                  BlocBuilder<AppLocalizationCubit, AppLocalizationState>(
                    builder: (context, localeState) {
                      return SettingsTile(
                        icon: Icons.language_outlined,
                        title: 'App Language',
                        subtitle: _getLanguageName(
                          localeState.locale.languageCode,
                        ),
                        showDivider: false,
                        onTap: () {
                          // Currently only English is supported
                          CustomSnackbar.info(
                            context,
                            'Only English is currently supported',
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: 'Notifications',
                children: [
                  SettingsTile(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Message, group & call tones',
                    onTap: () {
                      // TODO: Navigate to notification settings
                    },
                  ),
                  SettingsTile(
                    icon: Icons.data_usage_outlined,
                    title: 'Storage and Data',
                    subtitle: 'Network usage, auto-download',
                    showDivider: false,
                    onTap: () {
                      // TODO: Navigate to storage settings
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: 'Help',
                children: [
                  SettingsTile(
                    icon: Icons.help_outline,
                    title: 'Help Center',
                    onTap: () {},
                  ),
                  SettingsTile(
                    icon: Icons.info_outline,
                    title: 'App Info',
                    showDivider: false,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await context.read<AppUserCubit>().removeAppUser();
                    if (context.mounted) {
                      context.go('/enter-number');
                    }
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Log Out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Calling App',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isDark
                            ? AppColors.darkOnSurfaceVariant
                            : AppColors.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'Version 1.0.0',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.darkOnSurfaceVariant
                            : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      default:
        return 'English';
    }
  }

  void _showThemeSelector(BuildContext context, AppThemeState currentState) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Choose Theme',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.brightness_auto),
                title: const Text('System Default'),
                trailing: currentState is AppThemeInitial
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  context.read<AppThemeCubit>().updateThemeMode(
                    ThemeMode.system,
                  );
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.light_mode),
                title: const Text('Light'),
                trailing: currentState is LightThemeMode
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  context.read<AppThemeCubit>().updateThemeMode(
                    ThemeMode.light,
                  );
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text('Dark'),
                trailing: currentState is DarkThemeMode
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  context.read<AppThemeCubit>().updateThemeMode(ThemeMode.dark);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
