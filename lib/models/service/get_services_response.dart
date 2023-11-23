import 'dart:convert';

import 'package:nars/models/service/service.dart';

GetServicesResponse getServicesResponseFromJson(String str) =>
    GetServicesResponse.fromJson(json.decode(str));

String getServicesResponseToJson(GetServicesResponse data) =>
    json.encode(data.toJson());

class GetServicesResponse {
  GetServicesResponse({
    required this.results,
    required this.currentPage,
    required this.pageCount,
    required this.pageSize,
    required this.rowCount,
    required this.firstRowOnPage,
    required this.lastRowOnPage,
  });

  List<Service> results;
  int currentPage;
  int pageCount;
  int pageSize;
  int rowCount;
  int firstRowOnPage;
  int lastRowOnPage;

  factory GetServicesResponse.fromJson(Map<String, dynamic> json) =>
      GetServicesResponse(
        results:
            List<Service>.from(json["results"].map((x) => Service.fromJson(x))),
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
