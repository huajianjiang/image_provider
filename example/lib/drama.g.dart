// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drama.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DramaGroups _$DramaGroupsFromJson(Map<String, dynamic> json) {
  return DramaGroups(
    (json['groups'] as List)
        ?.map((e) =>
            e == null ? null : DramaGroup.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['meta'] == null
        ? null
        : Meta.fromJson(json['meta'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DramaGroupsToJson(DramaGroups instance) =>
    <String, dynamic>{
      'meta': instance.meta?.toJson(),
      'groups': instance.groups?.map((e) => e?.toJson())?.toList(),
    };

DramaGroup _$DramaGroupFromJson(Map<String, dynamic> json) {
  return DramaGroup(
    json['id'] as int,
    json['label'] as String,
    (json['dramas'] as List)
        ?.map(
            (e) => e == null ? null : Drama.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$DramaGroupToJson(DramaGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'dramas': instance.dramas?.map((e) => e?.toJson())?.toList(),
    };

Dramas _$DramasFromJson(Map<String, dynamic> json) {
  return Dramas(
    (json['dramas'] as List)
        ?.map(
            (e) => e == null ? null : Drama.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['meta'] == null
        ? null
        : Meta.fromJson(json['meta'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DramasToJson(Dramas instance) => <String, dynamic>{
      'meta': instance.meta?.toJson(),
      'dramas': instance.dramas?.map((e) => e?.toJson())?.toList(),
    };

Drama _$DramaFromJson(Map<String, dynamic> json) {
  return Drama(
    json['id'] as int,
    json['drama_id'] as String,
    json['play_url'] as String,
    json['name'] as String,
    json['category'] as String,
    json['alias'] as String,
    json['poster_url'] as String ?? '',
    json['season'] as int,
    json['episode_total'] as int,
    json['episode_current'] as int,
    json['res_update_status'] as String,
    json['res_updated_at'] as String,
    json['media'] as String,
    json['douban_url'] as String,
    json['summary'] as String,
    json['people'] as String,
    json['created_at'] as String,
    json['updated_at'] as String,
    (json['resources'] as List)
        ?.map((e) => e == null
            ? null
            : DramaResource.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$DramaToJson(Drama instance) => <String, dynamic>{
      'id': instance.id,
      'drama_id': instance.dramaId,
      'play_url': instance.playUrl,
      'name': instance.name,
      'category': instance.category,
      'alias': instance.alias,
      'poster_url': instance.posterUrl,
      'season': instance.season,
      'episode_total': instance.episodeTotal,
      'episode_current': instance.episodeCurrent,
      'res_update_status': instance.resUpdateStatus,
      'res_updated_at': instance.resUpdatedAt,
      'media': instance.media,
      'douban_url': instance.doubanUrl,
      'summary': instance.summary,
      'people': instance.people,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'resources': instance.resources?.map((e) => e?.toJson())?.toList(),
    };

DramaResource _$DramaResourceFromJson(Map<String, dynamic> json) {
  return DramaResource(
    json['id'] as int,
    json['res_id'] as String,
    json['drama_id'] as String,
    json['res_name'] as String,
    json['res_url'] as String,
    json['source'] as String,
  );
}

Map<String, dynamic> _$DramaResourceToJson(DramaResource instance) =>
    <String, dynamic>{
      'id': instance.id,
      'res_id': instance.resId,
      'drama_id': instance.dramaId,
      'res_name': instance.resName,
      'res_url': instance.resUrl,
      'source': instance.source,
    };
