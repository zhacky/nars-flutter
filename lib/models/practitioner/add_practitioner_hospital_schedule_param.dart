import 'dart:convert';

import 'package:nars/models/hospital/hospital_schedule.dart';

AddPractitionerHospitalScheduleParam
    addPractitionerHospitalScheduleParamFromJson(String str) =>
        AddPractitionerHospitalScheduleParam.fromJson(json.decode(str));

String addPractitionerHospitalScheduleParamToJson(
        AddPractitionerHospitalScheduleParam data) =>
    json.encode(data.toJson());

class AddPractitionerHospitalScheduleParam {
  AddPractitionerHospitalScheduleParam({
    required this.hospitalId,
    required this.hospitalSchedules,
  });

  int hospitalId;
  List<HospitalSchedule> hospitalSchedules;

  factory AddPractitionerHospitalScheduleParam.fromJson(
          Map<String, dynamic> json) =>
      AddPractitionerHospitalScheduleParam(
        hospitalId: json["hospitalId"],
        hospitalSchedules: List<HospitalSchedule>.from(
            json["hospitalSchedules"].map((x) => HospitalSchedule.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "hospitalId": hospitalId,
        "hospitalSchedules":
            List<dynamic>.from(hospitalSchedules.map((x) => x.toJson())),
      };
}
