import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_settings.freezed.dart';
part 'user_settings.g.dart';

/// Defines the privacy levels for user profile information.
///
/// - [everyone]: Information is visible to all users.
/// - [contacts]: Information is visible only to users in contacts.
/// - [nobody]: Information is hidden from all users.
enum PrivacyLevel { everyone, contacts, nobody }

/// User privacy and preference settings.
///
/// Controls various privacy settings and feature preferences for the user account.
/// All privacy settings default to [PrivacyLevel.everyone] for maximum visibility.
@freezed
abstract class UserSettings with _$UserSettings {
  const factory UserSettings({
    /// Privacy level for last seen/online status visibility.
    ///
    /// Determines who can see when the user was last active.
    @Default(PrivacyLevel.everyone) PrivacyLevel lastSeenPrivacy,

    /// Privacy level for profile photo visibility.
    ///
    /// Controls who can view the user's profile picture.
    @Default(PrivacyLevel.everyone) PrivacyLevel profilePhotoPrivacy,

    /// Privacy level for about/status visibility.
    ///
    /// Determines who can see the user's about section.
    @Default(PrivacyLevel.everyone) PrivacyLevel aboutPrivacy,

    /// Privacy level for group addition permissions.
    ///
    /// Controls who can add this user to groups.
    @Default(PrivacyLevel.everyone) PrivacyLevel groupAddPrivacy,

    /// Whether to send read receipts to other users.
    ///
    /// When true, other users will see when this user has read their messages.
    @Default(true) bool readReceipts,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);
}
