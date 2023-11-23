import 'dart:convert';

import 'package:nars/models/common/date_filter.dart';

GetPractitionerAppointmentsCountParam
    getPractitionerAppointmentsCountParamFromJson(String str) =>
        GetPractitionerAppointmentsCountParam.fromJson(json.decode(str));

String getPractitionerAppointmentsCountParamToJson(
        GetPractitionerAppointmentsCountParam data) =>
    json.encode(data.toJson());

class GetPractitionerAppointmentsCountParam {
  GetPractitionerAppointmentsCountParam({
    required this.practitionerId,
    required this.dateFilterCommon,
  });

  int practitionerId;
  DateFilterCommon dateFilterCommon;

  factory GetPractitionerAppointmentsCountParam.fromJson(
          Map<String, dynamic> json) =>
      GetPractitionerAppointmentsCountParam(
        practitionerId: json["practitionerId"],
        dateFilterCommon: DateFilterCommon.fromJson(json["dateFilterCommon"]),
      );

  Map<String, dynamic> toJson() => {
        "practitionerId": practitionerId,
        "dateFilterCommon": dateFilterCommon.toJson(),
      };
}
