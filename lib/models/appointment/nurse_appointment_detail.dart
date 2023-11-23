import 'dart:convert';

NurseAppointmentDetail nurseAppointmentDetailFromJson(String str) =>
    NurseAppointmentDetail.fromJson(json.decode(str));

String nurseAppointmentDetailToJson(NurseAppointmentDetail data) =>
    json.encode(data.toJson());

class NurseAppointmentDetail {
  NurseAppointmentDetail({
    this.nurseServicesEnums,
    required this.patientMobilityEnum,
    this.patientContraptionEnum,
  });

  String? nurseServicesEnums;
  String patientMobilityEnum;
  String? patientContraptionEnum;

  factory NurseAppointmentDetail.fromJson(Map<String, dynamic> json) =>
      NurseAppointmentDetail(
        nurseServicesEnums: json["nurseServicesEnums"],
        patientMobilityEnum: json["patientMobilityEnum"],
        patientContraptionEnum: json["patientContraptionEnum"],
      );

  Map<String, dynamic> toJson() => {
        "nurseServices": nurseServicesEnums,
        "patientMobility": patientMobilityEnum,
        "patientContraptions": patientContraptionEnum,
      };
}
