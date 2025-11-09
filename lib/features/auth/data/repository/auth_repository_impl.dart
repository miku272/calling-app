import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/models/user_model.dart';

import '../datasources/auth_remote_datasource.dart';
import '../../domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _authRemoteDatasource;

  AuthRepositoryImpl({required AuthRemoteDatasource authRemoteDatasource})
    : _authRemoteDatasource = authRemoteDatasource;

  @override
  Future<Either<Failure, UserModel>> signUpWithEmailAndPassword({
    String? displayName,
    String? phoneNumber,
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _authRemoteDatasource.signUpWithEmailAndPassword(
        displayName: displayName,
        phoneNumber: phoneNumber,
        email: email,
        password: password,
      );

      return right(userModel);
    } on FirebaseAuthException catch (e) {
      return left(
        Failure(
          firebaseErrorCode: e.code,
          message: e.message ?? 'Failed to sign up',
        ),
      );
    } on FirebaseException catch (e) {
      return left(
        Failure(
          firebaseErrorCode: e.code,
          message: e.message ?? 'Failed to sign up',
        ),
      );
    } catch (error) {
      return left(Failure(message: 'Unexpected error during sign up'));
    }
  }
}
