import 'dart:convert';

import 'package:nars/models/pagination/pagination_param.dart';

GetAppointmentByPatientIdParam getAppointmentByPatientIdParamFromJson(
        String str) =>
    GetAppointmentByPatientIdParam.fromJson(json.decode(str));

String getAppointmentByPatientIdParamToJson(
        GetAppointmentByPatientIdParam data) =>
    json.encode(data.toJson());

class GetAppointmentByPatientIdParam {
  GetAppointmentByPatientIdParam({
    required this.patientId,
    required this.pageCommon,
    required this.appointmentStatuses,
    required this.userTypes,
  });

  int patientId;
  PageCommon pageCommon;
  List<int> appointmentStatuses;
  List<int> userTypes;

  factory GetAppointmentByPatientIdParam.fromJson(Map<String, dynamic> json) =>
      GetAppointmentByPatientIdParam(
        patientId: json["patientId"],
        pageCommon: PageCommon.fromJson(json["pageCommon"]),
        appointmentStatuses:
            List<int>.from(json["appointmentStatuses"].map((x) => x)),
        userTypes: List<int>.from(json["userTypes"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "patientId": patientId,
        "pageCommon": pageCommon.toJson(),
        "appointmentStatuses":
            List<dynamic>.from(appointmentStatuses.map((x) => x)),
        "userTypes": List<dynamic>.from(userTypes.map((x) => x)),
      };
}
