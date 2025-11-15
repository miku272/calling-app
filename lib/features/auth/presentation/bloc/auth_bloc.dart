import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/send_otp.dart';
import '../../domain/usecases/verify_otp.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendOtp _sendOtp;
  final VerifyOtp _verifyOtp;

  AuthBloc({required SendOtp sendOtp, required VerifyOtp verifyOtp})
    : _sendOtp = sendOtp,
      _verifyOtp = verifyOtp,
      super(AuthInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(SendOtpLoading());

    final res = await _sendOtp(SendOtpParams(phoneNumber: event.phoneNumber));

    res.fold(
      (failure) => emit(
        SendOtpFailure(
          statusCode: failure.statusCode,
          firebaseErrorCode: failure.firebaseErrorCode,
          message: failure.message,
        ),
      ),
      (phoneAuthResult) {
        if (phoneAuthResult.phoneAuthCredential != null) {
          emit(AutomaticallyVerified(phoneAuthResult.phoneAuthCredential!));

          return;
        }

        if (phoneAuthResult.verificationId != null) {
          emit(
            OtpSent(
              phoneAuthResult.verificationId!,
              resendToken: phoneAuthResult.resendToken,
            ),
          );

          return;
        }
      },
    );
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(VerifyOtpLoading());

    final res = await _verifyOtp(
      VerifyOtpParms(
        verificationId: event.verificationId,
        smsCode: event.smsCode,
        autoCredential: event.autoCredential,
      ),
    );

    res.fold(
      (failure) => emit(
        VerifyOtpFailure(
          statusCode: failure.statusCode,
          firebaseErrorCode: failure.firebaseErrorCode,
          message: failure.message,
        ),
      ),
      (userCredential) {
        emit(OtpVerified(userCredential));
      },
    );
  }
}
