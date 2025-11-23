import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/models/user_model.dart';
import '../../../../core/models/user_settings.dart';
import '../models/phone_auth_result.dart';
import '../models/verify_otp_result.dart';

/// Abstract interface for authentication remote data source operations.
///
/// Defines the contract for authentication-related operations with Firebase.
abstract interface class AuthRemoteDatasource {
  /// Sends an OTP to the specified phone number.
  ///
  /// [phoneNumber] The phone number to send the OTP to (must include country code).
  /// [resendToken] Optional token to force resend the OTP.
  ///
  /// Returns a [PhoneAuthResult] containing either the verification ID or
  /// a credential if auto-verification succeeds.
  ///
  /// Throws [FirebaseAuthException] if the operation fails.
  Future<PhoneAuthResult> sendOtp(String phoneNumber, {int? resendToken});

  /// Verifies the OTP code provided by the user.
  ///
  /// Either [autoCredential] or both [verificationId] and [smsCode] must be provided.
  ///
  /// [verificationId] The verification ID received from [sendOtp].
  /// [smsCode] The OTP code entered by the user.
  /// [autoCredential] The credential received from auto-verification.
  ///
  /// Returns a [VerifyOtpResult] containing the user credential, whether the user
  /// is new, and the user model from Firestore.
  ///
  /// Throws [FirebaseAuthException] if verification fails.
  /// Throws [Exception] if required parameters are missing.
  Future<VerifyOtpResult> verifyOtp({
    String? verificationId,
    String? smsCode,
    PhoneAuthCredential? autoCredential,
  });

  /// Updates the display name and profile photo URL for the current user.
  ///
  /// [displayName] The new display name for the user.
  /// [photoUrl] Optional URL for the user's profile photo.
  ///
  /// Returns the updated [UserModel] from Firestore.
  ///
  /// Throws [FirebaseAuthException] if the update fails.
  /// Throws [Exception] if no authenticated user is found.
  Future<UserModel> updateDisplayNameAndPhotoUrl({
    required String displayName,
    String? photoUrl,
  });
}

/// Implementation of [AuthRemoteDatasource] using Firebase services.
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

  /// Synchronizes the Firebase Auth user data with Firestore.
  ///
  /// [user] The Firebase Auth user to sync.
  /// [createIfNew] If true, creates a new user document if it doesn't exist.
  /// [updateProfile] If true, updates the existing user profile with current data.
  ///
  /// This method ensures that user data in Firestore stays in sync with
  /// Firebase Authentication profile information.
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
