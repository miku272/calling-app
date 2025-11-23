import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/models/user_model.dart';
import '../../../../core/models/user_settings.dart';
import '../models/phone_auth_result.dart';
import '../models/verify_otp_result.dart';

abstract interface class AuthRemoteDatasource {
  Future<PhoneAuthResult> sendOtp(String phoneNumber, {int? resendToken});
  Future<VerifyOtpResult> verifyOtp({
    String? verificationId,
    String? smsCode,
    PhoneAuthCredential? autoCredential,
  });
  Future<UserModel> updateDisplayNameAndPhotoUrl({
    required String displayName,
    String? photoUrl,
  });
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDatasourceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore;

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
      UserCredential userCredential;
      UserModel? userModel;

      if (autoCredential != null) {
        userCredential = await _firebaseAuth.signInWithCredential(
          autoCredential,
        );
      } else if (verificationId != null && smsCode != null) {
        final credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        );
        userCredential = await _firebaseAuth.signInWithCredential(credential);
      } else {
        throw Exception(
          'Either the credential is null or the verification id and sms code are null',
        );
      }

      final isNewUser = userCredential.user?.displayName == null;
      final user = userCredential.user;

      if (user != null) {
        await _syncUserToFirestore(user, createIfNew: isNewUser);

        userModel = await _firestore
            .collection('users')
            .doc(user.uid)
            .get()
            .then((doc) => UserModel.fromJson(doc.data()!));
      }

      return VerifyOtpResult(
        userCredential: userCredential,
        isNewUser: isNewUser,
        userModel: userModel,
      );
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<UserModel> updateDisplayNameAndPhotoUrl({
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
        final updatedUser = _firebaseAuth.currentUser;

        if (updatedUser != null) {
          await _syncUserToFirestore(updatedUser, updateProfile: true);
        }
      } else {
        throw Exception('No authenticated user found.');
      }

      return await _firestore
          .collection('users')
          .doc(user.uid)
          .get()
          .then((doc) => UserModel.fromJson(doc.data()!));
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _syncUserToFirestore(
    User user, {
    bool createIfNew = false,
    bool updateProfile = false,
  }) async {
    final userDocRef = _firestore.collection('users').doc(user.uid);
    final userDoc = await userDocRef.get();

    if (!userDoc.exists || createIfNew) {
      final newUser = UserModel(
        uid: user.uid,
        phoneNumber: user.phoneNumber ?? '',
        displayName: user.displayName,
        profileImageUrl: user.photoURL,
        email: user.email,
        createdAt: user.metadata.creationTime,
        settings: const UserSettings(),
      );
      await userDocRef.set(newUser.toJson());
    } else if (updateProfile && userDoc.exists) {
      try {
        final existingUser = UserModel.fromJson(userDoc.data()!);
        final updatedUser = existingUser.copyWith(
          displayName: user.displayName,
          profileImageUrl: user.photoURL,
        );

        await userDocRef.set(updatedUser.toJson());
      } catch (e) {
        await userDocRef.set({
          'displayName': user.displayName,
          'profileImageUrl': user.photoURL,
        }, SetOptions(merge: true));
      }
    }
  }
}
