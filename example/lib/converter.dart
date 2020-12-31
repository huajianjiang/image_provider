import 'package:chopper/chopper.dart';

typedef T JsonFactory<T>(Map<String, dynamic> json);

class JsonResponseConverter extends JsonConverter {
  final Map<Type, JsonFactory> factories;

  JsonResponseConverter(this.factories);

  @override
  Request convertRequest(Request request) {
    if (request.body is Map<String, String>) return request;
    if (request.body is Map) {
      final body = <String, String>{};
      request.body.forEach((key, val) {
        if (val != null) {
          body[key.toString()] = val.toString();
        }
      });
      request = request.copyWith(body: body);
    }
    return request;
  }

  T _decodeMap<T>(Map<String, dynamic> values) {
    final jsonFactory = factories[T];
    if (jsonFactory == null || jsonFactory is! JsonFactory<T>) {
      throw ConvertException('jsonFactory type must be $T.');
    }
    return jsonFactory(values);
  }

  List<T> _decodeList<T>(List values) =>
      values.where((v) => v != null).map<T>((v) => _decode<T>(v)).toList();

  dynamic _decode<T>(entity) {
    if (entity is Iterable) return _decodeList<T>(entity);
    if (entity is Map) return _decodeMap<T>(entity);
    return entity;
  }

  @override
  Response<BodyType> convertResponse<BodyType, InnerType>(Response response) {
    var jsonResponse = super.convertResponse(response);
    return jsonResponse.copyWith<BodyType>(
        body: _decode<InnerType>(jsonResponse.body));
  }

}

class ConvertException implements Exception {
    final String message;

    ConvertException(this.message);

    @override
    String toString() {
      return '$message';
    }
}