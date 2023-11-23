import 'dart:convert';

ReschedAppointmentParam reschedAppointmentParamFromJson(String str) =>
    ReschedAppointmentParam.fromJson(json.decode(str));

String reschedAppointmentParamToJson(ReschedAppointmentParam data) =>
    json.encode(data.toJson());

class ReschedAppointmentParam {
  ReschedAppointmentParam({
    required this.appointmentId,
    required this.dateTime,
    required this.rescheduleReason,
  });

  int appointmentId;
  DateTime dateTime;
  String rescheduleReason;

  factory ReschedAppointmentParam.fromJson(Map<String, dynamic> json) =>
      ReschedAppointmentParam(
        appointmentId: json["appointmentId"],
        dateTime: DateTime.parse(json["dateTime"]),
        rescheduleReason: json["rescheduleReason"],
      );

  Map<String, dynamic> toJson() => {
        "appointmentId": appointmentId,
        "dateTime": dateTime.toIso8601String(),
        "rescheduleReason": rescheduleReason,
      };
}
