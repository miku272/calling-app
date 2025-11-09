import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/sf_service.dart';

part 'app_theme_state.dart';

class AppThemeCubit extends Cubit<AppThemeState> {
  final SfService _sfService;

  AppThemeCubit({required SfService sfService})
    : _sfService = sfService,
      super(const AppThemeInitial());

  void loadThemeMode() {
    final storedThemeMode = _sfService.getThemeMode();

    switch (storedThemeMode) {
      case ThemeMode.light:
        emit(const LightThemeMode());
        break;

      case ThemeMode.dark:
        emit(const DarkThemeMode());
        break;

      case ThemeMode.system:
        emit(const AppThemeInitial());
        break;
    }
  }

  Future<void> updateThemeMode(ThemeMode themeMode) async {
    await _sfService.saveThemeMode(themeMode);

    switch (themeMode) {
      case ThemeMode.light:
        emit(const LightThemeMode());
        break;

      case ThemeMode.dark:
        emit(const DarkThemeMode());
        break;

      case ThemeMode.system:
        emit(const AppThemeInitial());
        break;
    }
  }
}
