import 'dart:convert';

PractitionerAddSpecializationsParam practitionerAddSpecializationsParamFromJson(
        String str) =>
    PractitionerAddSpecializationsParam.fromJson(json.decode(str));

String practitionerAddSpecializationsParamToJson(
        PractitionerAddSpecializationsParam data) =>
    json.encode(data.toJson());

class PractitionerAddSpecializationsParam {
  PractitionerAddSpecializationsParam({
    required this.specialtiesIds,
  });

  List<int> specialtiesIds;

  factory PractitionerAddSpecializationsParam.fromJson(
          Map<String, dynamic> json) =>
      PractitionerAddSpecializationsParam(
        specialtiesIds: List<int>.from(json["specialtiesIds"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "specialtiesIds": List<dynamic>.from(specialtiesIds.map((x) => x)),
      };
}
