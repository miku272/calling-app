part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthResetEvent extends AuthEvent {}

final class SignUpWithEmailAndPasswordEvent extends AuthEvent {
  final String? displayName;
  final String? phoneNumber;
  final String email;
  final String password;

  SignUpWithEmailAndPasswordEvent({
    this.displayName,
    this.phoneNumber,
    required this.email,
    required this.password,
  });
}
