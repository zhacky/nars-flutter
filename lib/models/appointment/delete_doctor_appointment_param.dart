import 'dart:convert';

DeleteDoctorAppointmentParam deleteDoctorAppointmentParamFromJson(String str) =>
    DeleteDoctorAppointmentParam.fromJson(json.decode(str));

String deleteDoctorAppointmentParamToJson(DeleteDoctorAppointmentParam data) =>
    json.encode(data.toJson());

class DeleteDoctorAppointmentParam {
  DeleteDoctorAppointmentParam({
    required this.id,
  });

  int id;

  factory DeleteDoctorAppointmentParam.fromJson(Map<String, dynamic> json) =>
      DeleteDoctorAppointmentParam(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
