import 'package:json_annotation/json_annotation.dart';

part 'pagination.g.dart';

mixin Pagination {
  Meta meta;
}

@JsonSerializable()
class Meta {
  int page;
  @JsonKey(name: "per_page")
  int perPage;
  int pages;
  int total;

  Meta(this.page, this.perPage, this.pages, this.total);

  factory Meta.fromJson(Map<String, dynamic> json) {
    return fromJsonFactory(json);
  }

  static const fromJsonFactory = _$MetaFromJson;

  Map<String, dynamic> toJson() {
    return _$MetaToJson(this);
  }

}
