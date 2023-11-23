import 'dart:convert';

import 'package:nars/enumerables/gender.dart';
import 'package:nars/models/address/addressAlls.dart';

String informationToJson(Information data) => json.encode(data.toJson());

class Information {
  Information({
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.phoneNumber,
    this.profilePicture,
    this.addressAlls,
  });

  String firstName;
  String? middleName;
  String lastName;
  DateTime dateOfBirth;
  Gender gender;
  String phoneNumber;
  String? profilePicture;
  List<AddressAll>? addressAlls;
  late String fullName = firstName +
      ' ' +
      (middleName != null ? (middleName! + ' ') : '') +
      lastName;

  factory Information.fromJson(Map<String, dynamic> json) => Information(
        firstName: json["firstName"],
        middleName: json["middleName"],
        lastName: json["lastName"],
        dateOfBirth: DateTime.parse(json["dateOfBirth"]),
        gender: genderValues.map[json["gender"]]!,
        phoneNumber: json["phoneNumber"],
        profilePicture: json["profilePicture"] ??
            'https://acrehealth.s3.ap-southeast-1.amazonaws.com/default_profile.png',
        addressAlls: json["addressAlls"] == null
            ? null
            : List<AddressAll>.from(
                json["addressAlls"].map((x) => AddressAll.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "middleName": middleName,
        "lastName": lastName,
        "dateOfBirth": dateOfBirth.toIso8601String(),
        "gender": genderValues.reverse![gender],
        "phoneNumber": phoneNumber,
        "profilePicture": profilePicture,
        "addressAlls": addressAlls == null
            ? null
            : List<dynamic>.from(addressAlls!.map((x) => x.toJson())),
      };
}
