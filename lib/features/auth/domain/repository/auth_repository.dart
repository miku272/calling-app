import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/models/user_model.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserModel>> signUpWithEmailAndPassword({
    String? displayName,
    String? phoneNumber,
    required String email,
    required String password,
  });
}
