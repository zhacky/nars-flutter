import 'dart:convert';

AppointmentDetail appointmentDetailFromJson(String str) =>
    AppointmentDetail.fromJson(json.decode(str));

String appointmentDetailToJson(AppointmentDetail data) =>
    json.encode(data.toJson());

class AppointmentDetail {
  AppointmentDetail({
    this.appointmentId,
    this.id,
    this.patientFeedBack,
    this.remarks,
    this.vitalSigns,
    this.chiefComplaint,
    this.subjective,
    this.objective,
    this.assessment,
    this.plan,
  });

  int? appointmentId;
  int? id;
  String? patientFeedBack;
  String? remarks;
  String? vitalSigns;
  String? chiefComplaint;
  String? subjective;
  String? objective;
  String? assessment;
  String? plan;

  factory AppointmentDetail.fromJson(Map<String, dynamic> json) =>
      AppointmentDetail(
        appointmentId: json["appointmentId"],
        id: json["id"],
        patientFeedBack: json["patientFeedBack"],
        remarks: json["remarks"],
        vitalSigns: json["vitalSigns"],
        chiefComplaint: json["chiefComplaint"],
        subjective: json["subjective"],
        objective: json["objective"],
        assessment: json["assessment"],
        plan: json["plan"],
      );

  Map<String, dynamic> toJson() => {
        "appointmentId": appointmentId,
        "id": id,
        "patientFeedBack": patientFeedBack,
        "remarks": remarks,
        "vitalSigns": vitalSigns,
        "chiefComplaint": chiefComplaint,
        "subjective": subjective,
        "objective": objective,
        "assessment": assessment,
        "plan": plan,
      };
}
