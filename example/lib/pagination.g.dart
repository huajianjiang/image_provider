// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meta _$MetaFromJson(Map<String, dynamic> json) {
  return Meta(
    json['page'] as int,
    json['per_page'] as int,
    json['pages'] as int,
    json['total'] as int,
  );
}

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      'page': instance.page,
      'per_page': instance.perPage,
      'pages': instance.pages,
      'total': instance.total,
    };
