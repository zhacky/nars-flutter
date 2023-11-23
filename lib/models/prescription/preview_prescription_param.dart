import 'dart:convert';

PreviewPrescriptionParam previewPrescriptionParamFromJson(String str) =>
    PreviewPrescriptionParam.fromJson(json.decode(str));

String previewPrescriptionParamToJson(PreviewPrescriptionParam data) =>
    json.encode(data.toJson());

class PreviewPrescriptionParam {
  PreviewPrescriptionParam({
    required this.prescriptionCommon,
  });

  PrescriptionCommon prescriptionCommon;

  factory PreviewPrescriptionParam.fromJson(Map<String, dynamic> json) =>
      PreviewPrescriptionParam(
        prescriptionCommon:
            PrescriptionCommon.fromJson(json["prescriptionCommon"]),
      );

  Map<String, dynamic> toJson() => {
        "prescriptionCommon": prescriptionCommon.toJson(),
      };
}

class PrescriptionCommon {
  PrescriptionCommon({
    required this.id,
    required this.doctorName,
    required this.customerName,
    required this.address,
    required this.dateCreated,
    required this.gender,
    required this.age,
    required this.prescriptionItems,
    required this.signatureUrl,
    required this.prc,
    required this.ptr,
    required this.description,
  });

  int id;
  String doctorName;
  String customerName;
  String address;
  DateTime dateCreated;
  String gender;
  int age;
  List<PrescriptionItem> prescriptionItems;
  String signatureUrl;
  String prc;
  String ptr;
  String description;

  factory PrescriptionCommon.fromJson(Map<String, dynamic> json) =>
      PrescriptionCommon(
        id: json["id"],
        doctorName: json["doctorName"],
        customerName: json["customerName"],
        address: json["address"],
        dateCreated: DateTime.parse(json["dateCreated"]),
        gender: json["gender"],
        age: json["age"],
        prescriptionItems: List<PrescriptionItem>.from(
            json["prescriptionItems"].map((x) => PrescriptionItem.fromJson(x))),
        signatureUrl: json["signatureUrl"],
        prc: json["prc"],
        ptr: json["ptr"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "doctorName": doctorName,
        "customerName": customerName,
        "address": address,
        "dateCreated": dateCreated.toIso8601String(),
        "gender": gender,
        "age": age,
        "prescriptionItems":
            List<dynamic>.from(prescriptionItems.map((x) => x.toJson())),
        "signatureUrl": signatureUrl,
        "prc": prc,
        "ptr": ptr,
        "description": description,
      };
}

class PrescriptionItem {
  PrescriptionItem({
    required this.medicineName,
    required this.qty,
    required this.dosage,
    required this.preparation,
    required this.duration,
  });

  String medicineName;
  String qty;
  String dosage;
  String preparation;
  String duration;

  factory PrescriptionItem.fromJson(Map<String, dynamic> json) =>
      PrescriptionItem(
        medicineName: json["medicine_name"],
        qty: json["qty"],
        dosage: json["dosage"],
        preparation: json["preparation"],
        duration: json["duration"],
      );

  Map<String, dynamic> toJson() => {
        "medicine_name": medicineName,
        "qty": qty,
        "dosage": dosage,
        "preparation": preparation,
        "duration": duration,
      };
}
