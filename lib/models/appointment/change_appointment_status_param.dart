import 'dart:convert';

ChangeAppointmentStatusParam changeAppointmentStatusParamFromJson(String str) =>
    ChangeAppointmentStatusParam.fromJson(json.decode(str));

String changeAppointmentStatusParamToJson(ChangeAppointmentStatusParam data) =>
    json.encode(data.toJson());

class ChangeAppointmentStatusParam {
  ChangeAppointmentStatusParam({
    required this.appointmentId,
    required this.appointmentStatus,
  });

  int appointmentId;
  int appointmentStatus;

  factory ChangeAppointmentStatusParam.fromJson(Map<String, dynamic> json) =>
      ChangeAppointmentStatusParam(
        appointmentId: json["appointmentId"],
        appointmentStatus: json["appointmentStatus"],
      );

  Map<String, dynamic> toJson() => {
        "appointmentId": appointmentId,
        "appointmentStatus": appointmentStatus,
      };
}
