import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './core/services/sf_service.dart';
import './core/cubits/app_theme/app_theme_cubit.dart';

import './features/auth/data/datasources/auth_remote_datasource.dart';
import './features/auth/domain/repository/auth_repository.dart';
import './features/auth/data/repository/auth_repository_impl.dart';
import './features/auth/domain/usecases/sign_up_with_email_and_password.dart';
import './features/auth/presentation/bloc/auth_bloc.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  await _initSfService();
  _initFirebaseServices();

  _initAppTheme();
  _initAuth();
}

Future<void> _initSfService() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);

  getIt.registerLazySingleton<SfService>(
    () => SfService(sharedPreferences: getIt<SharedPreferences>()),
  );
}

void _initAppTheme() {
  getIt.registerLazySingleton<AppThemeCubit>(
    () => AppThemeCubit(sfService: getIt<SfService>()),
  );
}

void _initFirebaseServices() {
  final firebaseAuth = FirebaseAuth.instance;
  getIt.registerLazySingleton<FirebaseAuth>(() => firebaseAuth);

  final firebaseFirestore = FirebaseFirestore.instance;
  getIt.registerLazySingleton<FirebaseFirestore>(() => firebaseFirestore);
}

void _initAuth() {
  getIt.registerFactory<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(
      firebaseAuth: getIt<FirebaseAuth>(),
      firebaseFirestore: getIt<FirebaseFirestore>(),
    ),
  );

  getIt.registerFactory<AuthRepository>(
    () =>
        AuthRepositoryImpl(authRemoteDatasource: getIt<AuthRemoteDatasource>()),
  );

  getIt.registerFactory<SignUpWithEmailAndPassword>(
    () => SignUpWithEmailAndPassword(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      signUpWithEmailAndPassword: getIt<SignUpWithEmailAndPassword>(),
    ),
  );
}
