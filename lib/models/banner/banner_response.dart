import 'dart:convert';

import 'package:nars/models/banner/banner_photo.dart';

BannerResponse bannerResponseFromJson(String str) =>
    BannerResponse.fromJson(json.decode(str));

String bannerResponseToJson(BannerResponse data) => json.encode(data.toJson());

class BannerResponse {
  BannerResponse({
    required this.results,
    required this.currentPage,
    required this.pageCount,
    required this.pageSize,
    required this.rowCount,
    required this.firstRowOnPage,
    required this.lastRowOnPage,
  });

  List<BannerPhoto> results;
  int currentPage;
  int pageCount;
  int pageSize;
  int rowCount;
  int firstRowOnPage;
  int lastRowOnPage;

  factory BannerResponse.fromJson(Map<String, dynamic> json) => BannerResponse(
        results: List<BannerPhoto>.from(
            json["results"].map((x) => BannerPhoto.fromJson(x))),
        currentPage: json["currentPage"],
        pageCount: json["pageCount"],
        pageSize: json["pageSize"],
        rowCount: json["rowCount"],
        firstRowOnPage: json["firstRowOnPage"],
        lastRowOnPage: json["lastRowOnPage"],
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "currentPage": currentPage,
        "pageCount": pageCount,
        "pageSize": pageSize,
        "rowCount": rowCount,
        "firstRowOnPage": firstRowOnPage,
        "lastRowOnPage": lastRowOnPage,
      };
}
