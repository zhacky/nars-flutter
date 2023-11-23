import 'dart:convert';

PractitionerSpecialization practitionerSpecializationFromJson(String str) =>
    PractitionerSpecialization.fromJson(json.decode(str));

String practitionerSpecializationToJson(PractitionerSpecialization data) =>
    json.encode(data.toJson());

List<PractitionerSpecialization> practitionerSpecializationsFromJson(
        String str) =>
    List<PractitionerSpecialization>.from(
        json.decode(str).map((x) => PractitionerSpecialization.fromJson(x)));

class PractitionerSpecialization {
  PractitionerSpecialization({
    required this.id,
    required this.specialityId,
    required this.specialityName,
  });

  int id;
  int specialityId;
  String specialityName;

  factory PractitionerSpecialization.fromJson(Map<String, dynamic> json) =>
      PractitionerSpecialization(
        id: json["id"],
        specialityId: json["specialityId"],
        specialityName: json["specialityName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "specialityId": specialityId,
        "specialityName": specialityName,
      };
}
