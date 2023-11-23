import 'dart:convert';

import 'package:nars/models/practitioner/practitioner.dart';
import 'package:nars/models/practitioner/practitioner.dart';

GetPractitionersResponse getPractitionersResponseFromJson(String str) =>
    GetPractitionersResponse.fromJson(json.decode(str));

String getPractitionersResponseToJson(GetPractitionersResponse data) =>
    json.encode(data.toJson());

class GetPractitionersResponse {
  GetPractitionersResponse({
    required this.results,
    required this.currentPage,
    required this.pageCount,
    required this.pageSize,
    required this.rowCount,
    required this.firstRowOnPage,
    required this.lastRowOnPage,
  });

  List<Practitioner> results;
  int currentPage;
  int pageCount;
  int pageSize;
  int rowCount;
  int firstRowOnPage;
  int lastRowOnPage;

  factory GetPractitionersResponse.fromJson(Map<String, dynamic> json) =>
      GetPractitionersResponse(
        results: List<Practitioner>.from(
            json["results"].map((x) => Practitioner.fromJson(x))),
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
