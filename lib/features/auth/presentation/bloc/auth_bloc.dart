import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/sign_up_with_email_and_password.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpWithEmailAndPassword _signUpWithEmailAndPassword;

  AuthBloc({required SignUpWithEmailAndPassword signUpWithEmailAndPassword})
    : _signUpWithEmailAndPassword = signUpWithEmailAndPassword,
      super(AuthInitial()) {
    on<AuthResetEvent>((event, emit) => emit(AuthInitial()));

    on<SignUpWithEmailAndPasswordEvent>(_onSignUpWithEmailAndPassword);
  }

  Future<void> _onSignUpWithEmailAndPassword(
    SignUpWithEmailAndPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(SignUpWithEmailAndPasswordLoading());

    final res = await _signUpWithEmailAndPassword(
      SignUpWithEmailAndPasswordParams(
        displayName: event.displayName,
        phoneNumber: event.phoneNumber,
        email: event.email,
        password: event.password,
      ),
    );

    res.fold(
      (failure) => emit(
        SignUpWithEmailAndPasswordFailure(
          statusCode: failure.statusCode,
          firebaseErrorCode: failure.firebaseErrorCode,
          message: failure.message,
        ),
      ),
      (userModel) {
        emit(SignUpWithEmailAndPasswordSuccess());
      },
    );
  }
}
