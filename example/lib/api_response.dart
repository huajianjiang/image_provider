import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

class ApiResponse<T> {
  int code;
  String message;
  T data;

  ApiResponse(this.code, this.message, this.data);
}

@JsonSerializable()
class ApiError implements Exception {
  int code;
  String message;

  ApiError(this.code, this.message);

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return fromJsonFactory(json);
  }

  static const fromJsonFactory = _$ApiErrorFromJson;

  Map<String, dynamic> toJson() {
    return _$ApiErrorToJson(this);
  }

  @override
  String toString() {
    return message;
  }

}