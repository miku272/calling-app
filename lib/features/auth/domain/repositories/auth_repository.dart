import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';

import '../../data/models/phone_auth_result.dart';
import '../../data/models/verify_otp_result.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, PhoneAuthResult>> sendOtp(
    String phoneNumber, {
    int? resendToken,
  });

  Future<Either<Failure, VerifyOtpResult>> verifyOtp({
    String? verificationId,
    String? smsCode,
    PhoneAuthCredential? autoCredential,
  });

  Future<Either<Failure, void>> updateDisplayNameAndPhotoUrl({
    required String displayName,
    String? photoUrl,
  });
}
