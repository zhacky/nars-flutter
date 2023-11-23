import 'dart:convert';

import 'package:nars/models/information/information.dart';
import 'package:nars/models/patient/patient_profile.dart';

EditPatientProfileParam editPatientProfileParamFromJson(String str) =>
    EditPatientProfileParam.fromJson(json.decode(str));

String editPatientProfileParamToJson(EditPatientProfileParam data) =>
    json.encode(data.toJson());

class EditPatientProfileParam {
  EditPatientProfileParam({
    required this.id,
    required this.patientProfile,
  });

  int id;
  PatientProfile patientProfile;

  factory EditPatientProfileParam.fromJson(Map<String, dynamic> json) =>
      EditPatientProfileParam(
        id: json["id"],
        patientProfile: PatientProfile.fromJson(json["patientProfile"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "patientProfile": patientProfile.toJson(),
      };
}

