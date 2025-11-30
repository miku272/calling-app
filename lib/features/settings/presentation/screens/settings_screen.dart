import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';

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

  Future<bool> _showLogoutConfirmation(BuildContext context) async {
    final appLocalizations = AppLocalizations.of(context)!;

    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(appLocalizations.confirmLogout),
              content: Text(appLocalizations.logoutSubtitle),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(appLocalizations.cancel),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(appLocalizations.logOut),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkSurfaceContainer
          : AppColors.surfaceContainer,
      appBar: AppBar(
        title: Text(appLocalizations.settings),
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
                title: appLocalizations.account,
                children: [
                  SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: appLocalizations.privacy,
                    subtitle: appLocalizations.privacySubtitle,
                    onTap: () {
                      // TODO: Navigate to privacy settings
                    },
                  ),
                  SettingsTile(
                    icon: Icons.security_outlined,
                    title: appLocalizations.security,
                    subtitle: appLocalizations.securitySubtitle,
                    onTap: () {
                      // TODO: Navigate to security settings
                    },
                  ),
                  SettingsTile(
                    icon: Icons.delete_outline,
                    title: appLocalizations.deleteAccount,
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
                title: appLocalizations.appearance,
                children: [
                  BlocBuilder<AppThemeCubit, AppThemeState>(
                    builder: (context, themeState) {
                      String themeName = appLocalizations.system;
                      if (themeState is LightThemeMode) {
                        themeName = appLocalizations.light;
                      }
                      if (themeState is DarkThemeMode) {
                        themeName = appLocalizations.dark;
                      }

                      return SettingsTile(
                        icon: Icons.brightness_6_outlined,
                        title: appLocalizations.theme,
                        subtitle: themeName,
                        onTap: () => _showThemeSelector(context, themeState),
                      );
                    },
                  ),
                  BlocBuilder<AppLocalizationCubit, AppLocalizationState>(
                    builder: (context, localeState) {
                      return SettingsTile(
                        icon: Icons.language_outlined,
                        title: appLocalizations.appLanguage,
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
                title: appLocalizations.notifcations,
                children: [
                  SettingsTile(
                    icon: Icons.notifications_outlined,
                    title: appLocalizations.notifcations,
                    subtitle: appLocalizations.notificationsSubtitle,
                    onTap: () {
                      // TODO: Navigate to notification settings
                    },
                  ),
                  SettingsTile(
                    icon: Icons.data_usage_outlined,
                    title: appLocalizations.storageAndData,
                    subtitle: appLocalizations.storageAndDataSubtitle,
                    showDivider: false,
                    onTap: () {
                      // TODO: Navigate to storage settings
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: appLocalizations.help,
                children: [
                  SettingsTile(
                    icon: Icons.help_outline,
                    title: appLocalizations.helpCenter,
                    onTap: () {},
                  ),
                  SettingsTile(
                    icon: Icons.info_outline,
                    title: appLocalizations.appInfo,
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
                    final shouldLogout = await _showLogoutConfirmation(context);

                    if (shouldLogout == true && context.mounted) {
                      await context.read<AppUserCubit>().removeAppUser();
                      if (context.mounted) {
                        context.go('/enter-number');
                      }
                    }
                  },
                  icon: const Icon(Icons.logout),
                  label: Text(appLocalizations.logOut),
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
                      appLocalizations.appName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isDark
                            ? AppColors.darkOnSurfaceVariant
                            : AppColors.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      appLocalizations.version('1.0.0'),
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
