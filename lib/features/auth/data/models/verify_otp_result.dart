import 'package:firebase_auth/firebase_auth.dart';

class VerifyOtpResult {
  final UserCredential userCredential;
  final bool isNewUser;

  VerifyOtpResult({required this.userCredential, required this.isNewUser});
}
