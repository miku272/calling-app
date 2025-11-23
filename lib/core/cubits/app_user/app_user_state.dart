part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {
  final UserModel? appUser;

  const AppUserState({this.appUser});
}

final class AppUserInitial extends AppUserState {
  const AppUserInitial({super.appUser});
}

final class AppUserLoggedIn extends AppUserState {
  final UserModel userModel;

  const AppUserLoggedIn(this.userModel) : super(appUser: userModel);
}
