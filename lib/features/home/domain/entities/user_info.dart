import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_info.freezed.dart';

@freezed
class UserInfo with _$UserInfo {
  factory UserInfo(
      {required String username,
      required String fullName,
      required String? avatarUrl,
      required String? bio,
      required String? location}) = _UserInfo;
}
