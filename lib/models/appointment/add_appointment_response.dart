import 'dart:convert';

AddAppointmentResponse addAppointmentResponseFromJson(String str) =>
    AddAppointmentResponse.fromJson(json.decode(str));

String addAppointmentResponseToJson(AddAppointmentResponse data) =>
    json.encode(data.toJson());

class AddAppointmentResponse {
  AddAppointmentResponse({
    required this.appointmentId,
    required this.totalFee,
    required this.practitionerFee,
    required this.systemFee,
  });

  int appointmentId;
  double totalFee;
  double practitionerFee;
  double systemFee;

  factory AddAppointmentResponse.fromJson(Map<String, dynamic> json) =>
      AddAppointmentResponse(
        appointmentId: json["appointmentId"],
        totalFee: json["totalFee"],
        practitionerFee: json["practitionerFee"],
        systemFee: json["systemFee"],
      );

  Map<String, dynamic> toJson() => {
        "appointmentId": appointmentId,
      };
}
