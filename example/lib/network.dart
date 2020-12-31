import 'package:chopper/chopper.dart';
import 'api_response.dart';
import 'api_service.dart';
import 'constants.dart';
import 'converter.dart';
import 'drama.dart';
import 'interceptor.dart';

class NetworkManager {
  static final NetworkManager _instance = NetworkManager._internal();

  static const _jsonFactories = {
    ApiError: ApiError.fromJsonFactory,
    DramaGroups: DramaGroups.fromJsonFactory,
    DramaGroup: DramaGroup.fromJsonFactory,
    Drama: Drama.fromJsonFactory,
    Dramas: Dramas.fromJsonFactory,
  };

  final ChopperClient client = ChopperClient(
      baseUrl: Api.base_url,
      services: [ApiService.create()],
      converter: JsonResponseConverter(_jsonFactories),
      interceptors: [CommonInterceptor(), HttpLoggingInterceptor()]
  );

  NetworkManager._internal();

  factory NetworkManager() {
    return _instance;
  }
}

final ApiService apiService = NetworkManager().client.getService<ApiService>();

T takeBody<T>(Response<T> value) {
  return value.body;
}

enum LoadingState {
  def,
  refresh,
  more
}

class ApiErrorCode {
  static const UNKNOWN = -4000;
  static const TOKEN_EXPIRED = 4011;
  static const NO_MORE_DATA = 4003;
}

