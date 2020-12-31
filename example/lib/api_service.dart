import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;
import 'drama.dart';

part 'api_service.chopper.dart';

@ChopperApi()
abstract class ApiService extends ChopperService {
  static ApiService create([ChopperClient client]) => _$ApiService(client);

  @Get(path: 'dramas/groups/')
  Future<Response<DramaGroups>> getDramaGroups(@QueryMap() Map<String, dynamic> query);

  @Get(path: 'dramas/{drama_id}')
  Future<Response<Drama>> getDramaDetails(@Path("drama_id") String dramaId);

  @Get(path: 'dramas')
  Future<Response<Dramas>> getDramas(@QueryMap() Map<String, dynamic> query);

}