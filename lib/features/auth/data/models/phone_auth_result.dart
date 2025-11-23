import 'package:firebase_auth/firebase_auth.dart';

/// Result of a phone authentication OTP send operation.
///
/// Contains the authentication state after initiating phone verification.
/// Exactly one of [phoneAuthCredential] or [verificationId] will be non-null:
/// - [phoneAuthCredential] is set when auto-verification succeeds immediately
/// - [verificationId] is set when manual OTP entry is required
final class PhoneAuthResult {
  /// Credential for automatic verification (on supported devices).
  ///
  /// Non-null when Firebase automatically verifies the phone number
  /// without requiring manual OTP entry. This happens on Android devices
  /// with automatic SMS verification enabled.
  final PhoneAuthCredential? phoneAuthCredential;

  /// Verification ID for manual OTP entry.
  ///
  /// Non-null when the user needs to manually enter the OTP code.
  /// This ID is used along with the OTP code to complete verification.
  final String? verificationId;

  /// Token for resending the OTP.
  ///
  /// Can be used to force Firebase to resend the verification code
  /// if the user doesn't receive it or requests a new one.
  final int? resendToken;

  PhoneAuthResult({
    this.phoneAuthCredential,
    this.verificationId,
    this.resendToken,
  });
}
