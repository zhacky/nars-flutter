import 'dart:convert';

import 'package:nars/models/appointment/appointment.dart';

GetAppointmentsResponse getAppointmentsResponseFromJson(String str) =>
    GetAppointmentsResponse.fromJson(json.decode(str));

String getAppointmentsResponseToJson(GetAppointmentsResponse data) =>
    json.encode(data.toJson());

class GetAppointmentsResponse {
  GetAppointmentsResponse({
    required this.results,
    required this.currentPage,
    required this.pageCount,
    required this.pageSize,
    required this.rowCount,
    required this.firstRowOnPage,
    required this.lastRowOnPage,
  });

  List<Appointment> results;
  int currentPage;
  int pageCount;
  int pageSize;
  int rowCount;
  int firstRowOnPage;
  int lastRowOnPage;

  factory GetAppointmentsResponse.fromJson(Map<String, dynamic> json) =>
      GetAppointmentsResponse(
        results: List<Appointment>.from(
            json["results"].map((x) => Appointment.fromJson(x))),
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
