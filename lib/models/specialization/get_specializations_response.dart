import 'dart:convert';

import 'package:nars/models/specialization/specialization.dart';

GetSpecializationsResponse getSpecializationsResponseFromJson(String str) =>
    GetSpecializationsResponse.fromJson(json.decode(str));

String getSpecializationsResponseToJson(GetSpecializationsResponse data) =>
    json.encode(data.toJson());

class GetSpecializationsResponse {
  GetSpecializationsResponse({
    required this.results,
    required this.currentPage,
    required this.pageCount,
    required this.pageSize,
    required this.rowCount,
    required this.firstRowOnPage,
    required this.lastRowOnPage,
  });

  List<Specialization> results;
  int currentPage;
  int pageCount;
  int pageSize;
  int rowCount;
  int firstRowOnPage;
  int lastRowOnPage;

  factory GetSpecializationsResponse.fromJson(Map<String, dynamic> json) =>
      GetSpecializationsResponse(
        results: List<Specialization>.from(
            json["results"].map((x) => Specialization.fromJson(x))),
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
