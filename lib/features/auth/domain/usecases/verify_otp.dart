import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';

import '../../data/models/verify_otp_result.dart';
import '../repositories/auth_repository.dart';

class VerifyOtp implements Usecase<VerifyOtpResult, VerifyOtpParms> {
  final AuthRepository _authRepository;

  VerifyOtp({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, VerifyOtpResult>> call(VerifyOtpParms params) async {
    return await _authRepository.verifyOtp(
      verificationId: params.verificationId,
      smsCode: params.smsCode,
      autoCredential: params.autoCredential,
    );
  }
}

class VerifyOtpParms {
  final String? verificationId;
  final String? smsCode;
  final PhoneAuthCredential? autoCredential;

  VerifyOtpParms({this.verificationId, this.smsCode, this.autoCredential});
}
