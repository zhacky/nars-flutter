import 'package:flutter/material.dart';

class HospitalScheduleTimeSpan {
  HospitalScheduleTimeSpan({
    this.id,
    this.start,
    this.end,
  });

  int? id;
  TimeOfDay? start;
  TimeOfDay? end;

  factory HospitalScheduleTimeSpan.fromJson(Map<String, dynamic> json) =>
      HospitalScheduleTimeSpan(
        id: json["id"],
        start: TimeOfDay(
          hour: int.parse(json["start"].split(":")[0]),
          minute: int.parse(json["start"].split(":")[1]),
        ),
        end: TimeOfDay(
          hour: int.parse(json["end"].split(":")[0]),
          minute: int.parse(json["end"].split(":")[1]),
        ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "start":
            '${start!.hour.toString().padLeft(2, '0')}:${start!.minute.toString().padLeft(2, '0')}',
        "end":
            '${end!.hour.toString().padLeft(2, '0')}:${end!.minute.toString().padLeft(2, '0')}',
      };
}
