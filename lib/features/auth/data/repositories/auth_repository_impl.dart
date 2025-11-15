import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/phone_auth_result.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _authRemoteDatasource;

  AuthRepositoryImpl({required AuthRemoteDatasource authRemoteDatasource})
    : _authRemoteDatasource = authRemoteDatasource;

  @override
  Future<Either<Failure, PhoneAuthResult>> sendOtp(
    String phoneNumber, {
    int? resendToken,
  }) async {
    try {
      final phoneAuthResult = await _authRemoteDatasource.sendOtp(
        phoneNumber,
        resendToken: resendToken,
      );

      return right(phoneAuthResult);
    } on FirebaseException catch (e) {
      return left(
        Failure(
          firebaseErrorCode: e.code,
          message: e.message ?? 'Something went wrong while sending OTP',
        ),
      );
    } catch (e) {
      return left(Failure(message: 'Something went wrong while sending OTP'));
    }
  }

  @override
  Future<Either<Failure, UserCredential>> verifyOtp({
    String? verificationId,
    String? smsCode,
    PhoneAuthCredential? autoCredential,
  }) async {
    try {
      final userCredential = await _authRemoteDatasource.verifyOtp(
        verificationId: verificationId,
        smsCode: smsCode,
        autoCredential: autoCredential,
      );

      return right(userCredential);
    } on FirebaseException catch (e) {
      return left(
        Failure(
          firebaseErrorCode: e.code,
          message: e.message ?? 'Something went wrong while verifying OTP',
        ),
      );
    } catch (e) {
      return left(Failure(message: 'Something went wrong while verifying OTP'));
    }
  }
}
