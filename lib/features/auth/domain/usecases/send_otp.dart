import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';

import '../../data/models/phone_auth_result.dart';
import '../repositories/auth_repository.dart';

class SendOtp implements Usecase<PhoneAuthResult, SendOtpParams> {
  final AuthRepository _authRepository;

  SendOtp({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, PhoneAuthResult>> call(SendOtpParams params) async {
    return await _authRepository.sendOtp(
      params.phoneNumber,
      resendToken: params.resendToken,
    );
  }
}

class SendOtpParams {
  final String phoneNumber;
  final int? resendToken;

  SendOtpParams({required this.phoneNumber, this.resendToken});
}
