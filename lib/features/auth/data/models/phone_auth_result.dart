import 'package:firebase_auth/firebase_auth.dart';

final class PhoneAuthResult {
  final PhoneAuthCredential? phoneAuthCredential;
  final String? verificationId;
  final int? resendToken;

  PhoneAuthResult({
    this.phoneAuthCredential,
    this.verificationId,
    this.resendToken,
  });
}
