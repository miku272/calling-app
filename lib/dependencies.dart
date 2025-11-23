import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './core/services/sf_service.dart';
import './core/cubits/app_localization/app_localization_cubit.dart';
import './core/cubits/app_theme/app_theme_cubit.dart';
import './core/cubits/app_user/app_user_cubit.dart';

import './features/auth/data/datasources/auth_remote_datasource.dart';
import './features/auth/data/repositories/auth_repository_impl.dart';
import './features/auth/domain/repositories/auth_repository.dart';
import './features/auth/domain/usecases/send_otp.dart';
import './features/auth/domain/usecases/verify_otp.dart';
import './features/auth/domain/usecases/update_display_name_and_photo_url.dart';
import './features/auth/presentation/bloc/auth_bloc.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  await _initSfService();
  _initFirebaseServices();

  _initAppLocalization();
  _initAppTheme();
  _initAppUser();
  _initAuth();
}

Future<void> _initSfService() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);

  getIt.registerLazySingleton<SfService>(
    () => SfService(sharedPreferences: getIt<SharedPreferences>()),
  );
}

void _initFirebaseServices() {
  final firebaseAuth = FirebaseAuth.instance;
  getIt.registerLazySingleton<FirebaseAuth>(() => firebaseAuth);

  final firebaseFirestore = FirebaseFirestore.instance;
  getIt.registerLazySingleton<FirebaseFirestore>(() => firebaseFirestore);
}

void _initAppLocalization() {
  getIt.registerLazySingleton<AppLocalizationCubit>(
    () => AppLocalizationCubit(sfService: getIt<SfService>()),
  );
}

void _initAppTheme() {
  getIt.registerLazySingleton<AppThemeCubit>(
    () => AppThemeCubit(sfService: getIt<SfService>()),
  );
}

void _initAppUser() {
  getIt.registerLazySingleton<AppUserCubit>(
    () => AppUserCubit(
      firestore: getIt<FirebaseFirestore>(),
      firebaseAuth: getIt<FirebaseAuth>(),
    ),
  );
}

void _initAuth() {
  getIt.registerFactory<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(
      firebaseAuth: getIt<FirebaseAuth>(),
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  getIt.registerFactory<AuthRepository>(
    () =>
        AuthRepositoryImpl(authRemoteDatasource: getIt<AuthRemoteDatasource>()),
  );

  getIt.registerFactory<SendOtp>(
    () => SendOtp(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerFactory<VerifyOtp>(
    () => VerifyOtp(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerFactory<UpdateDisplayNameAndPhotoUrl>(
    () => UpdateDisplayNameAndPhotoUrl(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      appUserCubit: getIt<AppUserCubit>(),
      sendOtp: getIt<SendOtp>(),
      verifyOtp: getIt<VerifyOtp>(),
      updateDisplayNameAndPhotoUrl: getIt<UpdateDisplayNameAndPhotoUrl>(),
    ),
  );
}
