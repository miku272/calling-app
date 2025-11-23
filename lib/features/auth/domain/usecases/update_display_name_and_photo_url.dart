import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/usecase/usecase.dart';

import '../repositories/auth_repository.dart';

class UpdateDisplayNameAndPhotoUrl
    implements Usecase<UserModel, UpdateDisplayNameAndPhotoUrlParams> {
  final AuthRepository _authRepository;

  UpdateDisplayNameAndPhotoUrl({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, UserModel>> call(
    UpdateDisplayNameAndPhotoUrlParams params,
  ) {
    return _authRepository.updateDisplayNameAndPhotoUrl(
      displayName: params.displayName,
      photoUrl: params.photoUrl,
    );
  }
}

class UpdateDisplayNameAndPhotoUrlParams {
  final String displayName;
  final String? photoUrl;

  UpdateDisplayNameAndPhotoUrlParams({
    required this.displayName,
    this.photoUrl,
  });
}
