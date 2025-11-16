part of 'app_localization_cubit.dart';

@immutable
sealed class AppLocalizationState {
  final Locale locale;

  const AppLocalizationState({this.locale = const Locale('en', '')});
}

final class AppLocalizationInitial extends AppLocalizationState {
  const AppLocalizationInitial({super.locale = const Locale('en', '')});
}

final class AppLocalizationUpdated extends AppLocalizationState {
  const AppLocalizationUpdated({required super.locale});
}
