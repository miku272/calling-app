import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_model.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;
  StreamSubscription<DocumentSnapshot>? _userStreamSubscription;

  AppUserCubit({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
  }) : _firestore = firestore,
       _firebaseAuth = firebaseAuth,
       super(const AppUserInitial());

  void updateAppUser(UserModel userModel) => emit(AppUserLoggedIn(userModel));

  Future<void> removeAppUser() async {
    _cancelUserStream();
    await _firebaseAuth.signOut();
    emit(const AppUserInitial());
  }

  /// Start listening to real-time user data updates from Firestore
  /// If the user document is deleted, it will emit AppUserInitial state
  /// for that case.
  void startUserStream(String uid) {
    // Cancel any existing subscription first
    _cancelUserStream();

    _userStreamSubscription = _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen(
          (snapshot) {
            if (snapshot.exists && snapshot.data() != null) {
              final userModel = UserModel.fromJson(snapshot.data()!);
              emit(AppUserLoggedIn(userModel));
            } else {
              // User document doesn't exist or was deleted
              removeAppUser();
            }
          },
          onError: (error) {
            // Handle stream errors gracefully
            debugPrint('Error in user stream: $error');
          },
        );
  }

  void _cancelUserStream() {
    _userStreamSubscription?.cancel();
    _userStreamSubscription = null;
  }

  UserModel? get currentUser => state.appUser;

  @override
  Future<void> close() {
    _cancelUserStream();
    return super.close();
  }
}
