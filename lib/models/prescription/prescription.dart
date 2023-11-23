import 'dart:convert';

List<Prescription> prescriptionsFromJson(String str) => List<Prescription>.from(
    json.decode(str).map((x) => Prescription.fromJson(x)));

Prescription prescriptionFromJson(String str) =>
    Prescription.fromJson(json.decode(str));

String prescriptionToJson(Prescription data) => json.encode(data.toJson());

class Prescription {
  Prescription({
    this.id,
    required this.appointmentId,
    required this.drugName,
    this.preparation,
    required this.dosage,
    this.duration,
    this.quantity,
    this.status,
  });

  int? id;
  int appointmentId;
  String drugName;
  String? preparation;
  String dosage;
  String? duration;
  String? quantity;
  int? status;

  factory Prescription.fromJson(Map<String, dynamic> json) => Prescription(
        id: json["id"],
        appointmentId: json["appointmentId"],
        drugName: json["drugName"],
        preparation: json["preparation"],
        dosage: json["dosage"],
        duration: json["duration"],
        quantity: json["quantity"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "appointmentId": appointmentId,
        "drugName": drugName,
        "preparation": preparation,
        "dosage": dosage,
        "duration": duration,
        "quantity": quantity,
        "status": status,
      };
}
