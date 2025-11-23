import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/models/user_model.dart';

class VerifyOtpResult {
  final UserCredential userCredential;
  final bool isNewUser;
  UserModel? userModel;

  VerifyOtpResult({
    required this.userCredential,
    required this.isNewUser,
    this.userModel,
  });
}
