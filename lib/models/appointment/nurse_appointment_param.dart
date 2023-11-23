import 'dart:convert';

NurseAppointmentParam nurseAppointmentParamFromJson(String str) =>
    NurseAppointmentParam.fromJson(json.decode(str));

String nurseAppointmentParamToJson(NurseAppointmentParam data) =>
    json.encode(data.toJson());

class NurseAppointmentParam {
  NurseAppointmentParam({
    required this.nurseServices,
    required this.patientMobility,
    required this.patientContraptionEnums,
  });

  List<int> nurseServices;
  int patientMobility;
  List<int> patientContraptionEnums;

  factory NurseAppointmentParam.fromJson(Map<String, dynamic> json) =>
      NurseAppointmentParam(
        nurseServices: List<int>.from(json["nurseServices"].map((x) => x)),
        patientMobility: json["patientMobility"],
        patientContraptionEnums:
            List<int>.from(json["patientContraptionEnums"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "nurseServices": List<dynamic>.from(nurseServices.map((x) => x)),
        "patientMobility": patientMobility,
        "patientContraptionEnums":
            List<dynamic>.from(patientContraptionEnums.map((x) => x)),
      };
}
