import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/models/user_model.dart';

/// Result of an OTP verification operation.
///
/// Contains the authentication result and user information after
/// successfully verifying the OTP code or auto-credential.
class VerifyOtpResult {
  /// The Firebase authentication credential result.
  ///
  /// Contains the authenticated user's Firebase Auth data and metadata.
  final UserCredential userCredential;

  /// Whether this is a new user (first-time sign-in).
  ///
  /// True if the user doesn't have a display name set, indicating
  /// they need to complete profile setup. False for returning users.
  final bool isNewUser;

  /// The user's profile data from Firestore.
  ///
  /// Contains the full user model with all profile information,
  /// settings, and preferences. May be null if there was an error
  /// fetching the user document.
  UserModel? userModel;

  VerifyOtpResult({
    required this.userCredential,
    required this.isNewUser,
    this.userModel,
  });
}
