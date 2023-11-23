import 'dart:convert';

import 'package:nars/models/hospital/hospital.dart';

GetHospitalsResponse getHospitalsResponseFromJson(String str) =>
    GetHospitalsResponse.fromJson(json.decode(str));

String getHospitalsResponseToJson(GetHospitalsResponse data) =>
    json.encode(data.toJson());

class GetHospitalsResponse {
  GetHospitalsResponse({
    required this.results,
    required this.currentPage,
    required this.pageCount,
    required this.pageSize,
    required this.rowCount,
    required this.firstRowOnPage,
    required this.lastRowOnPage,
  });

  List<Hospital> results;
  int currentPage;
  int pageCount;
  int pageSize;
  int rowCount;
  int firstRowOnPage;
  int lastRowOnPage;

  factory GetHospitalsResponse.fromJson(Map<String, dynamic> json) =>
      GetHospitalsResponse(
        results: List<Hospital>.from(
            json["results"].map((x) => Hospital.fromJson(x))),
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
