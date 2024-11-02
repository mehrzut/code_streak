part of 'user_info_bloc.dart';

@freezed
class UserInfoEvent with _$UserInfoEvent {
   factory UserInfoEvent.getUserInfo() = _GetUserInfoEvent;
}