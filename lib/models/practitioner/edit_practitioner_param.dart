// To parse this JSON data, do
//
//     final editPractitionerProfileParam = editPractitionerProfileParamFromJson(jsonString);

import 'dart:convert';

import 'package:nars/models/practitioner/practitioner.dart';

EditPractitionerProfileParam editPractitionerProfileParamFromJson(String str) =>
    EditPractitionerProfileParam.fromJson(json.decode(str));

String editPractitionerProfileParamToJson(EditPractitionerProfileParam data) =>
    json.encode(data.toJson());

class EditPractitionerProfileParam {
  EditPractitionerProfileParam({
    required this.id,
    required this.practitionerProfile,
  });

  int id;
  Practitioner practitionerProfile;

  factory EditPractitionerProfileParam.fromJson(Map<String, dynamic> json) =>
      EditPractitionerProfileParam(
        id: json["id"],
        practitionerProfile: Practitioner.fromJson(json["practitionerProfile"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "practitionerProfile": practitionerProfile.toJson(),
      };
}
