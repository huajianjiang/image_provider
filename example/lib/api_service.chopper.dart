// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$ApiService extends ApiService {
  _$ApiService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = ApiService;

  @override
  Future<Response<DramaGroups>> getDramaGroups(Map<String, dynamic> query) {
    final $url = 'dramas/groups/';
    final $params = query;
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<DramaGroups, DramaGroups>($request);
  }

  @override
  Future<Response<Drama>> getDramaDetails(String dramaId) {
    final $url = 'dramas/$dramaId';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<Drama, Drama>($request);
  }

  @override
  Future<Response<Dramas>> getDramas(Map<String, dynamic> query) {
    final $url = 'dramas';
    final $params = query;
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<Dramas, Dramas>($request);
  }
}
