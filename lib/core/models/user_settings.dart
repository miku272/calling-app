import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_settings.freezed.dart';
part 'user_settings.g.dart';

enum PrivacyLevel { everyone, contacts, nobody }

@freezed
abstract class UserSettings with _$UserSettings {
  const factory UserSettings({
    @Default(PrivacyLevel.everyone) PrivacyLevel lastSeenPrivacy,
    @Default(PrivacyLevel.everyone) PrivacyLevel profilePhotoPrivacy,
    @Default(PrivacyLevel.everyone) PrivacyLevel aboutPrivacy,
    @Default(PrivacyLevel.everyone) PrivacyLevel groupAddPrivacy,
    @Default(true) bool readReceipts,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);
}
