part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class SendOtpLoading extends AuthState {}

final class AutomaticallyVerified extends AuthState {
  final PhoneAuthCredential phoneAuthCredential;

  AutomaticallyVerified(this.phoneAuthCredential);
}

final class OtpSent extends AuthState {
  final String verificationCode;
  final int? resendToken;

  OtpSent(this.verificationCode, {this.resendToken});
}

final class SendOtpFailure extends AuthState {
  final int? statusCode;
  final String? firebaseErrorCode;
  final String message;

  SendOtpFailure({
    this.statusCode,
    this.firebaseErrorCode,
    required this.message,
  });
}

final class VerifyOtpLoading extends AuthState {}

final class OtpVerified extends AuthState {
  final VerifyOtpResult verifyOtpResult;

  OtpVerified(this.verifyOtpResult);
}

final class VerifyOtpFailure extends AuthState {
  final int? statusCode;
  final String? firebaseErrorCode;
  final String message;

  VerifyOtpFailure({
    this.statusCode,
    this.firebaseErrorCode,
    required this.message,
  });
}

final class DisplayNameAndPhotoUrlUpdateLoading extends AuthState {}

final class DisplayNameAndPhotoUrlSuccess extends AuthState {}

final class DisplayNameAndPhotoUrlFailure extends AuthState {
  final int? statusCode;
  final String? firebaseErrorCode;
  final String message;

  DisplayNameAndPhotoUrlFailure({
    this.statusCode,
    this.firebaseErrorCode,
    required this.message,
  });
}
