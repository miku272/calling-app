part of 'app_theme_cubit.dart';

@immutable
sealed class AppThemeState {
  final ThemeMode themeMode;

  const AppThemeState({this.themeMode = ThemeMode.system});
}

final class AppThemeInitial extends AppThemeState {
  const AppThemeInitial({super.themeMode = ThemeMode.system});
}

final class LightThemeMode extends AppThemeState {
  const LightThemeMode() : super(themeMode: ThemeMode.light);
}

final class DarkThemeMode extends AppThemeState {
  const DarkThemeMode() : super(themeMode: ThemeMode.dark);
}
