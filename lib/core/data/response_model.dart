import 'package:code_streak/core/data/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'response_model.freezed.dart';

@freezed
abstract class ResponseModel<T> with _$ResponseModel {
  factory ResponseModel.success(T data) = _SuccessResponse;
  factory ResponseModel.failed(Failure failure) = _FailResponse;
}
