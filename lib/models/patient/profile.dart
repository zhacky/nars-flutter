import 'dart:convert';

import 'package:nars/enumerables/gender.dart';
import 'package:nars/models/information/information.dart';

List<Profile> getProfilesFromJson(String str) =>
    List<Profile>.from(json.decode(str).map((x) => Profile.fromJson(x)));

String getProfilesToJson(List<Profile> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  Profile({
    required this.id,
    required this.information,
  });

  int id;
  Information information;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"],
        information: Information.fromJson(json["information"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "information": information.toJson(),
      };
}

List<Profile> profiles = [
  Profile(
    id: 1,
    information: Information(
      firstName: 'Ruby',
      middleName: 'Sandra',
      lastName: 'Matthews',
      dateOfBirth: DateTime(1997, 8, 7, 0, 0),
      gender: Gender.Female,
      phoneNumber: '(0905)-546-1905',
      profilePicture: 'assets/images/users/user_1.png',
      addressAlls: null,
    ),
  ),
  Profile(
    id: 1,
    information: Information(
      firstName: 'Ann',
      middleName: 'Sandra',
      lastName: 'Matthews',
      dateOfBirth: DateTime(1993, 8, 7, 0, 0),
      gender: Gender.Female,
      phoneNumber: '(0916)-198-2400',
      profilePicture: 'assets/images/users/user_2.jpg',
      addressAlls: null,
    ),
  ),
  // Patient(
  //   firstName: 'Ruby',
  //   middleName: 'Sandra',
  //   lastName: 'Matthews',
  //   phoneNumber: '(0905)-546-1905',
  //   pinCode: '1234',
  //   profilePicture: 'assets/images/users/user_1.png',
  //   gender: 'Female',
  //   emailAddress: 'rubymatthews@gmail.com',
  //   prcNumber: '12345',
  //   bankAccount: '1234567890',
  //   dateOfBirth: DateTime(1997, 8, 7, 0, 0),
  //   address: Address(
  //     homeNo: '364',
  //     street: 'Raniag st.',
  //     barangay: 'Antonino',
  //     town: 'Alicia',
  //     province: 'Isabela',
  //     isDefault: false,
  //   ),
  // ),
  // Patient(
  //   firstName: 'Ann',
  //   middleName: 'Sandra',
  //   lastName: 'Matthews',
  //   phoneNumber: '(0916)-198-2400',
  //   pinCode: '1234',
  //   profilePicture: 'assets/images/users/user_2.jpg',
  //   gender: 'Female',
  //   emailAddress: 'annmatthews@gmail.com',
  //   prcNumber: '12345',
  //   bankAccount: '1234567890',
  //   dateOfBirth: DateTime(1993, 8, 7, 0, 0),
  //   address: Address(
  //     homeNo: '364',
  //     street: 'Raniag st.',
  //     barangay: 'Antonino',
  //     town: 'Alicia',
  //     province: 'Isabela',
  //     isDefault: false,
  //   ),
  // ),
];
