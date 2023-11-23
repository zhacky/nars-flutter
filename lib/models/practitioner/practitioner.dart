// To parse required this JSON data, do
//
//     final getPractitionerResponse = getPractitionerResponseFromJson(jsonString);

import 'dart:convert';

import 'package:nars/enumerables/status.dart';
import 'package:nars/models/document/document.dart';
import 'package:nars/models/information/information.dart';
import 'package:nars/models/practitioner/practitioner_hospital.dart';
import 'package:nars/models/practitioner/practitioner_service.dart';
import 'package:nars/models/specialization/specialization.dart';
import 'package:nars/models/user/user_acount.dart';

Practitioner practitionerFromJson(String str) =>
    Practitioner.fromJson(json.decode(str));

String practitionerToJson(Practitioner data) => json.encode(data.toJson());

class Practitioner {
  Practitioner({
    this.id,
    this.userType,
    this.status,
    this.fullName,
    this.address,
    this.profilePicture,
    this.yearOfExperience,
    this.title,
    this.description,
    this.preferredLanguage,
    this.ptr,
    this.signatureLink,
    this.dateOfApplication,
    this.specialization,
    this.prc,
    this.isAvailable,
    this.consultationFee,
    this.medcertFee,
    this.consultationMinute,
    this.userAccount,
    this.information,
    this.practitionerDocuments,
    this.practitionerScheduleHospitals,
    this.getPractitionerServices,
  });

  int? id;
  String? userType;
  Status? status;
  String? fullName;
  dynamic address;
  String? profilePicture;
  double? yearOfExperience;
  String? title;
  String? description;
  String? preferredLanguage;
  String? ptr;
  String? signatureLink;
  DateTime? dateOfApplication;
  List<Specialization>? specialization;
  String? prc;
  bool? isAvailable;
  double? consultationFee;
  double? medcertFee;
  int? consultationMinute;
  UserAccount? userAccount;
  Information? information;
  List<Document>? practitionerDocuments;
  List<PractitionerHospital>? practitionerScheduleHospitals;
  List<PractitionerService>? getPractitionerServices;

  factory Practitioner.fromJson(Map<String, dynamic> json) => Practitioner(
        id: json["id"],
        userType: json["userType"],
        status:
            json["status"] == null ? null : statusValues.map[json["status"]],
        fullName: json["fullName"],
        address: json["address"],
        profilePicture: json["profilePicture"] ??
            'https://acrehealth.s3.ap-southeast-1.amazonaws.com/default_profile.png',
        yearOfExperience: json["yearOfExperience"],
        title: json["title"],
        description: json["description"],
        preferredLanguage: json["preferredLanguage"],
        ptr: json["ptr"],
        signatureLink: json["signatureLink"],
        dateOfApplication: json["dateOfApplication"] == null
            ? null
            : DateTime.parse(json["dateOfApplication"]),
        specialization: json["specialization"] == null
            ? null
            : List<Specialization>.from(
                json["specialization"].map((x) => Specialization.fromJson(x))),
        prc: json["prc"],
        isAvailable: json["isAvailable"],
        consultationFee:
            json["consultationFee"] == null ? null : json["consultationFee"],
        medcertFee: json["medcertFee"] == null ? null : json["medcertFee"],
        consultationMinute: json["consultationMinute"] == null
            ? null
            : json["consultationMinute"],
        userAccount: json["userAccount"] == null
            ? null
            : UserAccount.fromJson(json["userAccount"]),
        information: json["information"] == null
            ? null
            : Information.fromJson(json["information"]),
        practitionerDocuments: json["practitionerDocuments"] == null
            ? null
            : List<Document>.from(
                json["practitionerDocuments"].map((x) => Document.fromJson(x))),
        practitionerScheduleHospitals:
            json["practitionerScheduleHospitals"] == null
                ? null
                : List<PractitionerHospital>.from(
                    json["practitionerScheduleHospitals"]
                        .map((x) => PractitionerHospital.fromJson(x))),
        getPractitionerServices: json["getPractitionerServices"] == null
            ? null
            : List<PractitionerService>.from(json["getPractitionerServices"]
                .map((x) => PractitionerService.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userType": userType,
        "status": statusValues.reverse![status],
        "fullName": fullName,
        "address": address,
        "profilePicture": profilePicture,
        "yearOfExperience": yearOfExperience,
        "title": title,
        "description": description,
        "preferredLanguage": preferredLanguage,
        "ptr": ptr,
        "signatureLink": signatureLink,
        "dateOfApplication": dateOfApplication == null
            ? null
            : dateOfApplication!.toIso8601String(),
        "specialization": specialization == null
            ? null
            : List<dynamic>.from(specialization!.map((x) => x.toJson())),
        "prc": prc,
        "isAvailable": isAvailable,
        "consultationFee": consultationFee == null ? null : consultationFee,
        "medcertFee": medcertFee == null ? null : medcertFee,
        "consultationMinute":
            consultationMinute == null ? null : consultationMinute,
        "userAccount": userAccount == null ? null : userAccount!.toJson(),
        "information": information == null ? null : information!.toJson(),
        "practitionerDocuments": practitionerDocuments == null
            ? null
            : List<dynamic>.from(practitionerDocuments!.map((x) => x.toJson())),
        "practitionerScheduleHospitals": practitionerScheduleHospitals == null
            ? null
            : List<dynamic>.from(
                practitionerScheduleHospitals!.map((x) => x.toJson())),
        "getPractitionerServices": getPractitionerServices == null
            ? null
            : List<dynamic>.from(
                getPractitionerServices!.map((x) => x.toJson())),
      };
}
