import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/usecase/usecase.dart';

import '../repository/auth_repository.dart';

class SignUpWithEmailAndPassword
    implements Usecase<UserModel, SignUpWithEmailAndPasswordParams> {
  final AuthRepository _authRepository;

  SignUpWithEmailAndPassword({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, UserModel>> call(
    SignUpWithEmailAndPasswordParams params,
  ) async {
    return await _authRepository.signUpWithEmailAndPassword(
      displayName: params.displayName,
      phoneNumber: params.phoneNumber,
      email: params.email,
      password: params.password,
    );
  }
}

class SignUpWithEmailAndPasswordParams {
  final String? displayName;
  final String? phoneNumber;
  final String email;
  final String password;

  SignUpWithEmailAndPasswordParams({
    this.displayName,
    this.phoneNumber,
    required this.email,
    required this.password,
  });
}
