import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';

import '../../data/models/phone_auth_result.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, PhoneAuthResult>> sendOtp(
    String phoneNumber, {
    int? resendToken,
  });

  Future<Either<Failure, UserCredential>> verifyOtp({
    String? verificationId,
    String? smsCode,
    PhoneAuthCredential? autoCredential,
  });
}
