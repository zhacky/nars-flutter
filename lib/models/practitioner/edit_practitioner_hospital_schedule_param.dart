import 'dart:convert';

import 'package:nars/models/hospital/hospital_schedule.dart';

EditPractitionerHospitalScheduleParam
    editPractitionerHospitalScheduleParamFromJson(String str) =>
        EditPractitionerHospitalScheduleParam.fromJson(json.decode(str));

String editPractitionerHospitalScheduleParamToJson(
        EditPractitionerHospitalScheduleParam data) =>
    json.encode(data.toJson());

class EditPractitionerHospitalScheduleParam {
  EditPractitionerHospitalScheduleParam({
    required this.practitionerHospitalId,
    required this.hospitalSchedules,
  });

  int practitionerHospitalId;
  List<HospitalSchedule> hospitalSchedules;

  factory EditPractitionerHospitalScheduleParam.fromJson(
          Map<String, dynamic> json) =>
      EditPractitionerHospitalScheduleParam(
        practitionerHospitalId: json["practitionerHospitalId"],
        hospitalSchedules: List<HospitalSchedule>.from(
            json["hospitalSchedules"].map((x) => HospitalSchedule.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "practitionerHospitalId": practitionerHospitalId,
        "hospitalSchedules":
            List<dynamic>.from(hospitalSchedules.map((x) => x.toJson())),
      };
}
