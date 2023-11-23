import 'dart:convert';

PaginationParam paginationParamFromJson(String str) =>
    PaginationParam.fromJson(json.decode(str));

String paginationParamToJson(PaginationParam data) =>
    json.encode(data.toJson());

class PaginationParam {
  PaginationParam({
    required this.pageCommon,
  });

  PageCommon pageCommon;

  factory PaginationParam.fromJson(Map<String, dynamic> json) =>
      PaginationParam(
        pageCommon: PageCommon.fromJson(json["pageCommon"]),
      );

  Map<String, dynamic> toJson() => {
        "pageCommon": pageCommon.toJson(),
      };
}

class PageCommon {
  PageCommon({
    required this.page,
    required this.pageSize,
  });

  int page;
  int pageSize;

  factory PageCommon.fromJson(Map<String, dynamic> json) => PageCommon(
        page: json["page"],
        pageSize: json["pageSize"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "pageSize": pageSize,
      };
}
