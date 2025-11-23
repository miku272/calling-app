import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import './l10n/app_localizations.dart';
import './firebase_options.dart';
import './dependencies.dart';
import './app_router.dart';

import './core/themes/light_theme.dart';
import './core/themes/dark_theme.dart';
import './core/cubits/app_localization/app_localization_cubit.dart';
import './core/cubits/app_theme/app_theme_cubit.dart';
import './core/cubits/app_user/app_user_cubit.dart';

import './features/auth/presentation/bloc/auth_bloc.dart';
import 'core/widgets/custom_snackbar.dart';

/// Entry point of the Calling App application.
///
/// Performs the following initialization steps:
/// 1. Initializes Flutter bindings
/// 2. Initializes Firebase with platform-specific configuration
/// 3. Sets up dependency injection container (GetIt)
/// 4. Loads user preferences (localization and theme)
/// 5. Configures BLoC providers for state management
/// 6. Sets up user session listener for automatic logout
/// 7. Launches the app
///
/// The app uses:
/// - **Firebase** for authentication and data storage
/// - **BLoC pattern** for state management
/// - **GetIt** for dependency injection
/// - **GoRouter** for navigation
/// - **ScreenUtil** for responsive design
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initDependencies();

  final appLocalizationCubit = getIt<AppLocalizationCubit>();
  appLocalizationCubit.loadLocalization();

  final appThemeCubit = getIt<AppThemeCubit>();
  appThemeCubit.loadThemeMode();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: appLocalizationCubit),
        BlocProvider.value(value: appThemeCubit),
        BlocProvider(create: (context) => getIt<AppUserCubit>()),
        BlocProvider(create: (context) => getIt<AuthBloc>()),
      ],
      child: BlocListener<AppUserCubit, AppUserState>(
        listener: (context, state) {
          if (state is AppUserInitial) {
            // User has been logged out, navigate to login screen
            context.go('/enter-number');

            // Show message if there was a previous user (not initial app load)
            if (state.appUser == null) {
              CustomSnackbar.error(
                context,
                AppLocalizations.of(context)?.loginInAgainMsg ??
                    'Please log in again.',
              );
            }
          }
        },
        child: const CallingApp(),
      ),
    ),
  );
}

/// Root widget of the Calling App.
///
/// Configures the MaterialApp with:
/// - **Localization**: Supports multiple languages (currently English)
/// - **Theming**: Light and dark theme support with user preference
/// - **Responsive design**: Uses ScreenUtil for adaptive layouts
/// - **Routing**: GoRouter for declarative navigation
///
/// The widget rebuilds when localization or theme settings change,
/// ensuring the app always reflects user preferences.
class CallingApp extends StatelessWidget {
  const CallingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppLocalizationCubit, AppLocalizationState>(
      builder: (context, appLocalizationState) {
        final appLocalizations = AppLocalizations.of(context);

        return BlocBuilder<AppThemeCubit, AppThemeState>(
          builder: (context, appThemeState) {
            return ScreenUtilInit(
              designSize: const Size(375, 812),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (context, child) => MaterialApp.router(
                title: appLocalizations?.appName ?? 'Calling App',
                debugShowCheckedModeBanner: false,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  AppLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en'), // English
                ],
                locale: appLocalizationState.locale,
                theme: LightTheme.theme,
                darkTheme: DarkTheme.theme,
                themeMode: appThemeState.themeMode,
                routerConfig: AppRouter.router,
              ),
            );
          },
        );
      },
    );
  }
}

/// Resets the authentication state to initial/logout state.
///
/// This function clears the bloc/cubit states, typically used
/// when the user logs out or when the session needs to be reset.
///
/// Note: Firebase Auth signout is handled automatically by [AppUserCubit.removeAppUser].
void resetStates(BuildContext context) {
  context.read<AuthBloc>().add(AuthResetEvent());
}
