import 'dart:convert';

import 'package:nars/models/hospital/hospital_address.dart';
import 'package:nars/models/hospital/hospital_schedule.dart';

List<PractitionerHospital> getPractitionerHospitalsFromJson(String str) =>
    List<PractitionerHospital>.from(
        json.decode(str).map((x) => PractitionerHospital.fromJson(x)));

PractitionerHospital getPractitionerHospitalFromJson(String str) =>
    PractitionerHospital.fromJson(json.decode(str));

String getPractitionerHospitalsToJson(List<PractitionerHospital> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

String practitionerHospitalToJson(PractitionerHospital data) =>
    json.encode(data.toJson());

class PractitionerHospital {
  PractitionerHospital({
    this.id,
    this.hospitalId,
    this.hospitalName,
    this.hospitalAddress,
    required this.hospitalSchedule,
  });

  int? id;
  int? hospitalId;
  String? hospitalName;
  HospitalAddress? hospitalAddress;
  bool allDayExist = false;
  bool deleteMode = false;
  List<HospitalSchedule> hospitalSchedule;

  factory PractitionerHospital.fromJson(Map<String, dynamic> json) =>
      PractitionerHospital(
        id: json["id"],
        hospitalId: json["hospitalId"],
        hospitalName: json["hospitalName"],
        hospitalAddress: json["hospitalAddress"] != null
            ? HospitalAddress.fromJson(json["hospitalAddress"])
            : null,
        hospitalSchedule: List<HospitalSchedule>.from(
            json["hospitalSchedule"].map((x) => HospitalSchedule.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "hospitalId": hospitalId,
        "hospitalName": hospitalName,
        "hospitalAddress":
            hospitalAddress != null ? hospitalAddress!.toJson() : null,
        "hospitalSchedule":
            List<dynamic>.from(hospitalSchedule.map((x) => x.toJson())),
      };
}
