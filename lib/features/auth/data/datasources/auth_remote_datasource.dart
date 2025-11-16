import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../models/phone_auth_result.dart';
import '../models/verify_otp_result.dart';

abstract interface class AuthRemoteDatasource {
  Future<PhoneAuthResult> sendOtp(String phoneNumber, {int? resendToken});
  Future<VerifyOtpResult> verifyOtp({
    String? verificationId,
    String? smsCode,
    PhoneAuthCredential? autoCredential,
  });
  Future<void> updateDisplayNameAndPhotoUrl({
    required String displayName,
    String? photoUrl,
  });
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteDatasourceImpl({required FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth;

  @override
  Future<PhoneAuthResult> sendOtp(
    String phoneNumber, {
    int? resendToken,
  }) async {
    try {
      Completer<PhoneAuthResult> completer = Completer();

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 120),
        forceResendingToken: resendToken,
        verificationCompleted: (PhoneAuthCredential credential) async {
          if (!completer.isCompleted) {
            completer.complete(
              PhoneAuthResult(phoneAuthCredential: credential),
            );
          }
        },
        verificationFailed: (FirebaseAuthException error) {
          if (!completer.isCompleted) {
            completer.completeError(error);
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          if (!completer.isCompleted) {
            completer.complete(
              PhoneAuthResult(
                verificationId: verificationId,
                resendToken: resendToken,
              ),
            );
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (!completer.isCompleted) {
            completer.complete(PhoneAuthResult(verificationId: verificationId));
          }
        },
      );

      return completer.future;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<VerifyOtpResult> verifyOtp({
    String? verificationId,
    String? smsCode,
    PhoneAuthCredential? autoCredential,
  }) async {
    try {
      if (autoCredential != null) {
        final userCredential = await _firebaseAuth.signInWithCredential(
          autoCredential,
        );

        final isNewUser = userCredential.user?.displayName == null;

        return VerifyOtpResult(
          userCredential: userCredential,
          isNewUser: isNewUser,
        );
      }

      if (verificationId != null && smsCode != null) {
        final credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        );

        final userCredential = await _firebaseAuth.signInWithCredential(
          credential,
        );

        final isNewUser = userCredential.user?.displayName == null;

        return VerifyOtpResult(
          userCredential: userCredential,
          isNewUser: isNewUser,
        );
      }

      throw Exception(
        'Either the credential is null or the verification id and sms code are null',
      );
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> updateDisplayNameAndPhotoUrl({
    required String displayName,
    String? photoUrl,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user != null) {
        await user.updateDisplayName(displayName);

        if (photoUrl != null) {
          await user.updatePhotoURL(photoUrl);
        }

        await user.reload();
      } else {
        throw Exception('No authenticated user found.');
      }
    } catch (error) {
      rethrow;
    }
  }
}
