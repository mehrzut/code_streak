import 'package:appwrite/models.dart';
import 'package:code_streak/common/typedefs.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'auth_result_data.freezed.dart';
part 'auth_result_data.g.dart';

@freezed
class AuthResultData with _$AuthResultData {
  factory AuthResultData.session({
    @SessionConverter() required Session session,
  }) = _AuthResultData;

  AuthResultData._();

  factory AuthResultData.fromJson(Json json) => _$AuthResultDataFromJson(json);
}

class SessionConverter extends JsonConverter<Session, Json> {
  const SessionConverter();
  @override
  Session fromJson(Json json) {
    return Session.fromMap(json);
  }

  @override
  Json toJson(Session object) {
    return (object).toMap();
  }
}
