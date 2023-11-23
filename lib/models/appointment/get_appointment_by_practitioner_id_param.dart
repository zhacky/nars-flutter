import 'dart:convert';

import 'package:nars/models/common/date_filter.dart';
import 'package:nars/models/pagination/pagination_param.dart';

GetAppointmentByPractitionerIdParam getAppointmentByPractitionerIdParamFromJson(
        String str) =>
    GetAppointmentByPractitionerIdParam.fromJson(json.decode(str));

String getAppointmentByPractitionerIdParamToJson(
        GetAppointmentByPractitionerIdParam data) =>
    json.encode(data.toJson());

class GetAppointmentByPractitionerIdParam {
  GetAppointmentByPractitionerIdParam({
    required this.practitionerId,
    required this.pageCommon,
    required this.appointmentStatuses,
    this.dateFilterCommon,
    this.scheduleFilterCommon,
    required this.isDescending,
  });

  int practitionerId;
  PageCommon pageCommon;
  List<int> appointmentStatuses;
  DateFilterCommon? dateFilterCommon;
  DateFilterCommon? scheduleFilterCommon;
  bool isDescending;

  factory GetAppointmentByPractitionerIdParam.fromJson(
          Map<String, dynamic> json) =>
      GetAppointmentByPractitionerIdParam(
        practitionerId: json["practitionerId"],
        pageCommon: PageCommon.fromJson(json["pageCommon"]),
        appointmentStatuses:
            List<int>.from(json["appointmentStatuses"].map((x) => x)),
        dateFilterCommon: json["dateFilterCommon"] == null
            ? null
            : DateFilterCommon.fromJson(json["dateFilterCommon"]),
        scheduleFilterCommon: json["scheduleFilterCommon"] == null
            ? null
            : DateFilterCommon.fromJson(json["scheduleFilterCommon"]),
        isDescending: json["isDescending"],
      );

  Map<String, dynamic> toJson() => {
        "practitionerId": practitionerId,
        "pageCommon": pageCommon.toJson(),
        "appointmentStatuses":
            List<dynamic>.from(appointmentStatuses.map((x) => x)),
        "dateFilterCommon":
            dateFilterCommon == null ? null : dateFilterCommon!.toJson(),
        "scheduleFilterCommon": scheduleFilterCommon == null
            ? null
            : scheduleFilterCommon!.toJson(),
        "isDescending": isDescending,
      };
}
