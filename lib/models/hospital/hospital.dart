import 'dart:convert';

import 'package:nars/models/hospital/hospital_address.dart';

String getHospitalsToJson(List<Hospital> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Hospital hospitalFromJson(String str) => Hospital.fromJson(json.decode(str));

String hospitalToJson(Hospital data) => json.encode(data.toJson());

class Hospital {
  Hospital({
    required this.addressId,
    required this.createdDate,
    required this.description,
    required this.id,
    this.imageLink,
    required this.isDeleted,
    required this.name,
    required this.address,
    this.practitionerHospitals,
    this.isSelected = false,
  });

  int id;
  int addressId;
  String name;
  String description;
  String? imageLink;
  HospitalAddress address;
  dynamic practitionerHospitals;
  bool isDeleted;
  bool isSelected;
  DateTime createdDate;

  factory Hospital.fromJson(Map<String, dynamic> json) => Hospital(
        id: json["id"],
        addressId: json["addressId"],
        name: json["name"],
        description: json["description"],
        imageLink: json["imageLink"],
        address: HospitalAddress.fromJson(json["address"]),
        practitionerHospitals: json["practitionerHospitals"],
        isDeleted: json["isDeleted"],
        createdDate: DateTime.parse(json["createdDate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "addressId": addressId,
        "name": name,
        "description": description,
        "imageLink": imageLink,
        "address": address.toJson(),
        "practitionerHospitals": practitionerHospitals,
        "isDeleted": isDeleted,
        "createdDate": createdDate.toIso8601String(),
      };
}
