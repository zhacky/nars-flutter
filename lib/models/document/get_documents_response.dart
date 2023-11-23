import 'dart:convert';

import 'package:nars/models/document/document.dart';

GetDocumentsResponse getDocumentsResponseFromJson(String str) =>
    GetDocumentsResponse.fromJson(json.decode(str));

String getDocumentsResponseToJson(GetDocumentsResponse data) =>
    json.encode(data.toJson());

class GetDocumentsResponse {
  GetDocumentsResponse({
    required this.results,
    required this.currentPage,
    required this.pageCount,
    required this.pageSize,
    required this.rowCount,
    required this.firstRowOnPage,
    required this.lastRowOnPage,
  });

  List<Document> results;
  int currentPage;
  int pageCount;
  int pageSize;
  int rowCount;
  int firstRowOnPage;
  int lastRowOnPage;

  factory GetDocumentsResponse.fromJson(Map<String, dynamic> json) =>
      GetDocumentsResponse(
        results: List<Document>.from(
            json["results"].map((x) => Document.fromJson(x))),
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
