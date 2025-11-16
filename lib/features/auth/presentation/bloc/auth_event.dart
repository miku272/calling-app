part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class SendOtpEvent extends AuthEvent {
  final String phoneNumber;
  final int? resendToken;

  SendOtpEvent({required this.phoneNumber, this.resendToken});
}

final class VerifyOtpEvent extends AuthEvent {
  final String? verificationId;
  final String? smsCode;
  final PhoneAuthCredential? autoCredential;

  VerifyOtpEvent({this.verificationId, this.smsCode, this.autoCredential});
}

final class UpdateDisplayNameAndPhotoUrlEvent extends AuthEvent {
  final String displayName;
  final String? photoUrl;

  UpdateDisplayNameAndPhotoUrlEvent({required this.displayName, this.photoUrl});
}
