import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
        listener: (context, state) => resetStates(context),
        child: const CallingApp(),
      ),
    ),
  );
}

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

void resetStates(BuildContext context) {
  context.read<AuthBloc>().add(AuthResetEvent());
}
