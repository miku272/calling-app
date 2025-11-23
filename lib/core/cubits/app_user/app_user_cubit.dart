import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_model.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(const AppUserInitial());

  void updateAppUser(UserModel userModel) => emit(AppUserLoggedIn(userModel));

  void removeAppUser() => emit(const AppUserInitial());

  UserModel? get currentUser => state.appUser;
}
