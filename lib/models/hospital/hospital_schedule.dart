import 'dart:convert';

import 'package:nars/models/hospital/hospital_schedule_timespan.dart';

String hospitalScheduleToJson(List<HospitalSchedule> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HospitalSchedule {
  HospitalSchedule({
    this.id,
    this.day,
    required this.hospitalScheduleTimeSpans,
  });

  int? id;
  String? day;
  List<HospitalScheduleTimeSpan> hospitalScheduleTimeSpans;

  factory HospitalSchedule.fromJson(Map<String, dynamic> json) =>
      HospitalSchedule(
        id: json["id"],
        day: json["day"],
        hospitalScheduleTimeSpans: List<HospitalScheduleTimeSpan>.from(
            json["hospitalScheduleTimeSpans"]
                .map((x) => HospitalScheduleTimeSpan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "day": day,
        "hospitalScheduleTimeSpans": List<dynamic>.from(
            hospitalScheduleTimeSpans.map((x) => x.toJson())),
      };
}
