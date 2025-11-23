import 'package:freezed_annotation/freezed_annotation.dart';

import './user_settings.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory UserModel({
    required String uid,
    String? username,
    required String phoneNumber,
    String? email,
    String? displayName,
    String? profileImageUrl,
    @Default('Hey there! I am using Calling App.') String about,
    @Default(false) bool isOnline,
    DateTime? lastSeen,
    String? pushToken,
    DateTime? createdAt,
    @Default(<String>[]) List<String> blockedUsers,
    @Default(<String>[]) List<String> mutedUsers,
    required UserSettings settings,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
