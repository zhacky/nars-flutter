import 'dart:convert';

List<AppointmentCount> appointmentsCountFromJson(String str) =>
    List<AppointmentCount>.from(
        json.decode(str).map((x) => AppointmentCount.fromJson(x)));

AppointmentCount appointmentCountFromJson(String str) =>
    AppointmentCount.fromJson(json.decode(str));

String appointmentCountToJson(AppointmentCount data) =>
    json.encode(data.toJson());

class AppointmentCount {
  AppointmentCount({
    required this.appointmentStatus,
    required this.count,
  });

  String appointmentStatus;
  int count;

  factory AppointmentCount.fromJson(Map<String, dynamic> json) =>
      AppointmentCount(
        appointmentStatus: json["appointmentStatus"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "appointmentStatus": appointmentStatus,
        "count": count,
      };
}
