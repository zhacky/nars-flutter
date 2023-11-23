import 'dart:convert';

import 'package:nars/models/information/information.dart';
import 'package:nars/models/patient/patient_profile.dart';

AddPatientProfileParam addPatientProfileParamFromJson(String str) =>
    AddPatientProfileParam.fromJson(json.decode(str));

String addPatientProfileParamToJson(AddPatientProfileParam data) =>
    json.encode(data.toJson());

class AddPatientProfileParam {
  AddPatientProfileParam({
    required this.patientProfile,
  });

  PatientProfile patientProfile;

  factory AddPatientProfileParam.fromJson(Map<String, dynamic> json) =>
      AddPatientProfileParam(
        patientProfile: PatientProfile.fromJson(json["patientProfile"]),
      );

  Map<String, dynamic> toJson() => {
        "patientProfile": patientProfile.toJson(),
      };
}

