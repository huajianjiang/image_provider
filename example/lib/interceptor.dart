import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:logging/logging.dart';

import 'api_response.dart';

final logger = Logger('CommonInterceptor');

class CommonInterceptor implements RequestInterceptor, ResponseInterceptor {

  @override
  FutureOr<Request> onRequest(Request request) async {
    return request;
  }

  @override
  FutureOr<Response> onResponse(Response response) async {
    if(!response.isSuccessful) {
      dynamic body = utf8.decode(response.bodyBytes);
      try {
        body = json.decode(body);
      } catch(e) {
        logger.warning('$e');
        rethrow;
      }
      throw ApiError.fromJsonFactory(body as Map<String, dynamic>);
    }
    return response;
  }

}

