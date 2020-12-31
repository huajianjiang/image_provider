import 'package:json_annotation/json_annotation.dart';

import 'pagination.dart';

part 'drama.g.dart';

@JsonSerializable(explicitToJson: true)
class DramaGroups with Pagination {
  final List<DramaGroup> groups;

  DramaGroups(this.groups, Meta meta) {
    super.meta = meta;
  }

  factory DramaGroups.fromJson(Map<String, dynamic> json) {
    return fromJsonFactory(json);
  }

  static const fromJsonFactory = _$DramaGroupsFromJson;

  Map<String, dynamic> toJson() {
    return _$DramaGroupsToJson(this);
  }

}

@JsonSerializable(explicitToJson: true)
class DramaGroup {
  final int id;
  final String label;
  final List<Drama> dramas;

  DramaGroup(this.id, this.label, this.dramas);

  factory DramaGroup.fromJson(Map<String, dynamic> json) {
    return fromJsonFactory(json);
  }

  static const fromJsonFactory = _$DramaGroupFromJson;

  Map<String, dynamic> toJson() {
    return _$DramaGroupToJson(this);
  }

}

@JsonSerializable(explicitToJson: true)
class Dramas with Pagination {
  List<Drama> dramas;

  Dramas(this.dramas, Meta meta) {
    super.meta = meta;
  }

  factory Dramas.fromJson(Map<String, dynamic> json) {
    return fromJsonFactory(json);
  }

  static const fromJsonFactory = _$DramasFromJson;

  Map<String, dynamic> toJson() {
    return _$DramasToJson(this);
  }

}

@JsonSerializable(explicitToJson: true)
class Drama {
  int id;
  @JsonKey(name: "drama_id")
  String dramaId;
  @JsonKey(name: "play_url")
  String playUrl;
  String name;
  String category;
  String alias;
  @JsonKey(name: "poster_url", defaultValue: '')
  String posterUrl;
  int season;
  @JsonKey(name: "episode_total")
  int episodeTotal;
  @JsonKey(name: "episode_current")
  int episodeCurrent;
  @JsonKey(name: "res_update_status")
  String resUpdateStatus;
  @JsonKey(name: "res_updated_at")
  String resUpdatedAt;
  String media;
  @JsonKey(name: "douban_url")
  String doubanUrl;
  String summary;
  String people;
  @JsonKey(name: "created_at")
  String createdAt;
  @JsonKey(name: "updated_at")
  String updatedAt;
  List<DramaResource> resources;

  Drama(
      this.id,
      this.dramaId,
      this.playUrl,
      this.name,
      this.category,
      this.alias,
      this.posterUrl,
      this.season,
      this.episodeTotal,
      this.episodeCurrent,
      this.resUpdateStatus,
      this.resUpdatedAt,
      this.media,
      this.doubanUrl,
      this.summary,
      this.people,
      this.createdAt,
      this.updatedAt,
      this.resources);

  factory Drama.fromJson(Map<String, dynamic> json) {
    return fromJsonFactory(json);
  }

  static const fromJsonFactory = _$DramaFromJson;

  Map<String, dynamic> toJson() {
    return _$DramaToJson(this);
  }
}

@JsonSerializable(explicitToJson: true)
class DramaResource {
  int id;
  @JsonKey(name: "res_id")
  String resId;
  @JsonKey(name: "drama_id")
  String dramaId;
  @JsonKey(name: "res_name")
  String resName;
  @JsonKey(name: "res_url")
  String resUrl;
  String source;

  DramaResource(
      this.id,
      this.resId,
      this.dramaId,
      this.resName,
      this.resUrl,
      this.source);

  factory DramaResource.fromJson(Map<String, dynamic> json) {
    return fromJsonFactory(json);
  }

  static const fromJsonFactory = _$DramaResourceFromJson;

  Map<String, dynamic> toJson() {
    return _$DramaResourceToJson(this);
  }

}
