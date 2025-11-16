import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/verify_otp_result.dart';
import '../../domain/usecases/send_otp.dart';
import '../../domain/usecases/update_display_name_and_photo_url.dart';
import '../../domain/usecases/verify_otp.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendOtp _sendOtp;
  final VerifyOtp _verifyOtp;
  final UpdateDisplayNameAndPhotoUrl _updateDisplayNameAndPhotoUrl;

  AuthBloc({
    required SendOtp sendOtp,
    required VerifyOtp verifyOtp,
    required UpdateDisplayNameAndPhotoUrl updateDisplayNameAndPhotoUrl,
  }) : _sendOtp = sendOtp,
       _verifyOtp = verifyOtp,
       _updateDisplayNameAndPhotoUrl = updateDisplayNameAndPhotoUrl,
       super(AuthInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<UpdateDisplayNameAndPhotoUrlEvent>(_onUpdateDisplayNameAndPhotoUrl);
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

  Future<void> _onUpdateDisplayNameAndPhotoUrl(
    UpdateDisplayNameAndPhotoUrlEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(DisplayNameAndPhotoUrlUpdateLoading());

    final res = await _updateDisplayNameAndPhotoUrl(
      UpdateDisplayNameAndPhotoUrlParams(
        displayName: event.displayName,
        photoUrl: event.photoUrl,
      ),
    );

    res.fold(
      (failure) => emit(
        DisplayNameAndPhotoUrlFailure(
          statusCode: failure.statusCode,
          firebaseErrorCode: failure.firebaseErrorCode,
          message: failure.message,
        ),
      ),
      (_) => emit(DisplayNameAndPhotoUrlSuccess()),
    );
  }
}
