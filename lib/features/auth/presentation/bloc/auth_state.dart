part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class SignUpWithEmailAndPasswordLoading extends AuthState {}

final class SignUpWithEmailAndPasswordSuccess extends AuthState {}

final class SignUpWithEmailAndPasswordFailure extends AuthState {
  final int? statusCode;
  final String? firebaseErrorCode;
  final String message;

  SignUpWithEmailAndPasswordFailure({
    this.statusCode,
    this.firebaseErrorCode,
    required this.message,
  });
}
