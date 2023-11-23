import 'dart:convert';

import 'package:nars/models/appointment/nurse_appointment_param.dart';

AddAppointmentParam addAppointmentParamFromJson(String str) =>
    AddAppointmentParam.fromJson(json.decode(str));

String addAppointmentParamToJson(AddAppointmentParam data) =>
    json.encode(data.toJson());

class AddAppointmentParam {
  AddAppointmentParam({
    required this.patientProfileId,
    required this.practitionerFee,
    required this.bookingType,
    this.practitionerId,
    required this.minutes,
    required this.reason,
    required this.schedule,
    required this.covid,
    this.dateOfTest,
    this.nurseAddedFeeIds,
  });

  int patientProfileId;
  double practitionerFee;
  int bookingType;
  int? practitionerId;
  int minutes;
  String reason;
  DateTime schedule;
  int covid;
  DateTime? dateOfTest;
  List<int>? nurseAddedFeeIds;

  factory AddAppointmentParam.fromJson(Map<String, dynamic> json) =>
      AddAppointmentParam(
        patientProfileId: json["patientProfileId"],
        practitionerFee: json["practitionerFee"],
        bookingType: json["bookingType"],
        practitionerId: json["practitionerId"],
        minutes: json["minutes"],
        reason: json["reason"],
        schedule: DateTime.parse(json["schedule"]),
        covid: json["covid"],
        dateOfTest: DateTime.parse(json["dateOfTest"]),
        nurseAddedFeeIds: json["nurseAddedFeeIds"] == null
            ? null
            : List<int>.from(json["nurseAddedFeeIds"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "patientProfileId": patientProfileId,
        "practitionerFee": practitionerFee,
        "bookingType": bookingType,
        "practitionerId": practitionerId,
        "minutes": minutes,
        "reason": reason,
        "schedule": schedule.toIso8601String(),
        "covid": covid,
        "dateOfTest": dateOfTest?.toIso8601String(),
        "nurseAddedFeeIds": nurseAddedFeeIds == null
            ? null
            : List<dynamic>.from(nurseAddedFeeIds!.map((x) => x)),
      };
}
