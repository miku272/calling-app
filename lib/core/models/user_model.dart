import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String phoneNumber,
    String? email,
    String? displayName,
    String? profileImageUrl,
    @Default('Hey there! I am using Calling App.') String about,
    @Default(false) bool isOnline,
    DateTime? lastSeen,
    String? pushToken,
    DateTime? createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
