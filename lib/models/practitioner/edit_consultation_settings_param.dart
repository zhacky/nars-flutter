// To parse required this JSON data, do
//
//     final editConsultationSettingsParam = editConsultationSettingsParamFromJson(jsonString);

import 'dart:convert';

EditConsultationSettingsParam editConsultationSettingsParamFromJson(String str) => EditConsultationSettingsParam.fromJson(json.decode(str));

String editConsultationSettingsParamToJson(EditConsultationSettingsParam data) => json.encode(data.toJson());

class EditConsultationSettingsParam {
    EditConsultationSettingsParam({
        required this.id,
        required this.practitionerProfile,
    });

    int id;
    PractitionerProfile practitionerProfile;

    factory EditConsultationSettingsParam.fromJson(Map<String, dynamic> json) => EditConsultationSettingsParam(
        id: json["id"],
        practitionerProfile: PractitionerProfile.fromJson(json["practitionerProfile"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "practitionerProfile": practitionerProfile.toJson(),
    };
}

class PractitionerProfile {
    PractitionerProfile({
        required this.consultationFee,
        required this.consultationMinute,
    });

    double consultationFee;
    int consultationMinute;

    factory PractitionerProfile.fromJson(Map<String, dynamic> json) => PractitionerProfile(
        consultationFee: json["consultationFee"],
        consultationMinute: json["consultationMinute"],
    );

    Map<String, dynamic> toJson() => {
        "consultationFee": consultationFee,
        "consultationMinute": consultationMinute,
    };
}
