import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/models/user_model.dart';

abstract interface class SettingsRemoteDatasource {
  Stream<UserModel> getCurrentUser(String uid);
}

class SettingsRemoteDatasourceImpl implements SettingsRemoteDatasource {
  final FirebaseFirestore _firestore;

  SettingsRemoteDatasourceImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  @override
  Stream<UserModel> getCurrentUser(String uid) async* {
    try {
      final userModelStream = _firestore
          .collection('users')
          .doc(uid)
          .snapshots()
          .map((doc) => UserModel.fromJson(doc.data()!));

      yield* userModelStream;
    } catch (error) {
      rethrow;
    }
  }
}
