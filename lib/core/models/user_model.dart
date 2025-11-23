import 'package:freezed_annotation/freezed_annotation.dart';

import './user_settings.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Represents a user in the calling app.
///
/// Contains all user profile information, authentication details, and preferences.
/// This model is synchronized with Firestore and Firebase Authentication.
@freezed
abstract class UserModel with _$UserModel {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory UserModel({
    /// Unique identifier for the user (matches Firebase Auth UID).
    required String uid,

    /// Optional unique username for the user.
    ///
    /// Can be used for user searches and mentions.
    String? username,

    /// User's phone number with country code.
    ///
    /// This is the primary authentication credential.
    required String phoneNumber,

    /// User's email address (optional).
    String? email,

    /// User's display name shown throughout the app.
    ///
    /// Required for new users during profile setup.
    String? displayName,

    /// URL to the user's profile image.
    ///
    /// Can be a Firebase Storage URL or external image URL.
    String? profileImageUrl,

    /// User's status/about text.
    ///
    /// Defaults to a standard message if not customized.
    @Default('Hey there! I am using Calling App.') String about,

    /// Current online status of the user.
    ///
    /// True when the user is actively using the app.
    @Default(false) bool isOnline,

    /// Timestamp of when the user was last seen online.
    ///
    /// Updated when the user goes offline.
    DateTime? lastSeen,

    /// Push notification token for this device.
    ///
    /// Used to send notifications to the user's device.
    String? pushToken,

    /// Timestamp of when the user account was created.
    DateTime? createdAt,

    /// List of UIDs of users blocked by this user.
    ///
    /// Blocked users cannot contact or see this user's information.
    @Default(<String>[]) List<String> blockedUsers,

    /// List of UIDs of users muted by this user.
    ///
    /// Muted users' notifications are silenced but messages are still received.
    @Default(<String>[]) List<String> mutedUsers,

    /// User's privacy and preference settings.
    required UserSettings settings,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
