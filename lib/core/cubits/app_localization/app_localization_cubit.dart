import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/sf_service.dart';

part 'app_localization_state.dart';

class AppLocalizationCubit extends Cubit<AppLocalizationState> {
  final SfService _sfService;

  AppLocalizationCubit({required SfService sfService})
    : _sfService = sfService,
      super(const AppLocalizationInitial());

  void loadLocalization() {
    final storedLocale = _sfService.getLocalization();

    emit(AppLocalizationUpdated(locale: storedLocale));
  }
}
