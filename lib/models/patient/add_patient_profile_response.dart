import 'dart:convert';

AddPatientProfileResponse addPatientProfileResponseFromJson(String str) =>
    AddPatientProfileResponse.fromJson(json.decode(str));

String addPatientProfileResponseToJson(AddPatientProfileResponse data) =>
    json.encode(data.toJson());

class AddPatientProfileResponse {
  AddPatientProfileResponse({
    required this.patientProfileId,
  });

  int patientProfileId;

  factory AddPatientProfileResponse.fromJson(Map<String, dynamic> json) =>
      AddPatientProfileResponse(
        patientProfileId: json["patientProfileId"],
      );

  Map<String, dynamic> toJson() => {
        "patientProfileId": patientProfileId,
      };
}
